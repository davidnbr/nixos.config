-- Python configuration that extends LazyVim's lang.python extra.
--
-- nvim-lint requires `args` to be a LIST (string|fun():string)[] and `cwd` to be
-- a STRING (lint.lua:368/381). The previous version set both to whole functions,
-- which crashed with "expected table, got function". Here we recompute concrete
-- string lists + cwd per python buffer via an autocmd, which also fixes the stale
-- linter selection (the old opts ran once at startup against whatever buffer was
-- active then).

local root_markers = { ".git", "pyproject.toml", "setup.py", ".pylintrc", "requirements.txt" }

-- Project root DIRECTORY for the given buffer (falls back to cwd).
local function find_root(buf)
	local fname = vim.api.nvim_buf_get_name(buf)
	if fname == "" then
		return vim.fn.getcwd()
	end
	local marker = vim.fs.find(root_markers, { path = vim.fs.dirname(fname), upward = true })[1]
	return marker and vim.fs.dirname(marker) or vim.fn.getcwd()
end

-- True if [tool.<name>] is configured in <root>/pyproject.toml.
local function has_tool_in_pyproject(root, tool_name)
	local pyproject_path = root .. "/pyproject.toml"
	if vim.fn.filereadable(pyproject_path) ~= 1 then
		return false
	end
	for _, line in ipairs(vim.fn.readfile(pyproject_path)) do
		if line:match("%[tool%." .. tool_name .. "%]") or line:match("%[tool%." .. tool_name .. "%.") then
			return true
		end
	end
	return false
end

local function pylint_args(root)
	-- No surrounding single quotes: nvim-lint passes args directly (no shell),
	-- so quotes would become part of the template literal.
	local args = {
		"--output-format=text",
		"--score=no",
		"--msg-template={path}:{line}:{column}: {msg_id} {msg} ({symbol})",
	}
	for _, rc in ipairs({
		root .. "/pyproject.toml",
		root .. "/.pylintrc",
		root .. "/server/.pylintrc",
		root .. "/pylintrc",
	}) do
		if vim.fn.filereadable(rc) == 1 then
			table.insert(args, "--rcfile=" .. rc)
			break
		end
	end
	return args
end

local function mypy_args(root)
	local args = {
		"--show-column-numbers",
		"--show-error-end",
		"--hide-error-codes",
		"--hide-error-context",
		"--no-color-output",
		"--no-error-summary",
		"--no-pretty",
	}
	local pyproject_path = root .. "/pyproject.toml"
	if vim.fn.filereadable(pyproject_path) == 1 then
		table.insert(args, "--config-file=" .. pyproject_path)
	end
	return args
end

return {
	-- Configure LSP: Disable type checking from pyright
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				pyright = {
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "off", -- Disable automatic type checking
								diagnosticMode = "openFilesOnly",
								useLibraryCodeForTypes = true,
							},
						},
					},
				},
			},
		},
	},

	-- Configure linting: pick linters from pyproject.toml and feed pylint/mypy
	-- valid (list) args + (string) cwd, recomputed per python buffer.
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			opts.linters_by_ft = opts.linters_by_ft or {}
			-- Sensible default until the autocmd refines it for the active buffer.
			opts.linters_by_ft.python = { "pylint" }

			local function refresh(buf)
				if vim.bo[buf].filetype ~= "python" then
					return
				end
				local lint = require("lint")
				local root = find_root(buf)

				local selected = {}
				if has_tool_in_pyproject(root, "mypy") then
					table.insert(selected, "mypy")
				end
				if has_tool_in_pyproject(root, "pylint") then
					table.insert(selected, "pylint")
				end
				if #selected == 0 then
					selected = { "pylint" }
				end
				lint.linters_by_ft.python = selected

				-- Lint the file on disk from the project root. Direct assignment
				-- replaces the builtin's args/stdin wholesale (no merge artifacts).
				local pylint = lint.linters.pylint
				pylint.cwd = root
				pylint.stdin = false
				pylint.append_fname = true
				pylint.args = pylint_args(root)

				local mypy = lint.linters.mypy
				mypy.cwd = root
				mypy.stdin = false
				mypy.append_fname = true
				mypy.args = mypy_args(root)
			end

			vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
				group = vim.api.nvim_create_augroup("PythonLintRoot", { clear = true }),
				callback = function(ev)
					refresh(ev.buf)
				end,
			})

			return opts
		end,
	},

	-- Black formatting is handled by lazyvim.plugins.extras.formatting.black,
	-- which reads configuration from pyproject.toml automatically.
}
