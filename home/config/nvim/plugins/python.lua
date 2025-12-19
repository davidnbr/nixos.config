-- Python configuration that extends LazyVim's lang.python extra
-- This overrides specific settings while keeping LazyVim's defaults

-- Helper to find project root
local function find_root(fname)
	local root_markers = { ".git", "pyproject.toml", "setup.py", ".pylintrc", "requirements.txt" }
	local path = vim.fs.dirname(fname)
	return vim.fs.find(root_markers, { path = path, upward = true })[1]
end

-- Helper to check if a tool is configured in pyproject.toml
local function has_tool_in_pyproject(root, tool_name)
	if not root then
		return false
	end

	local pyproject_path = vim.fs.dirname(root) .. "/pyproject.toml"
	if vim.fn.filereadable(pyproject_path) == 1 then
		local content = vim.fn.readfile(pyproject_path)
		for _, line in ipairs(content) do
			-- Check for tool configuration sections like [tool.mypy], [tool.pylint], [tool.black]
			if line:match("%[tool%." .. tool_name .. "%]") or line:match("%[tool%." .. tool_name .. "%.") then
				return true
			end
		end
	end
	return false
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

	-- Configure linting: Check pyproject.toml for configured linters
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			-- Determine which linters to use based on pyproject.toml
			opts.linters_by_ft = opts.linters_by_ft or {}

			local fname = vim.api.nvim_buf_get_name(0)
			local root = find_root(fname)
			local linters = {}

			-- Check pyproject.toml for configured tools
			if has_tool_in_pyproject(root, "mypy") then
				table.insert(linters, "mypy")
			end
			if has_tool_in_pyproject(root, "pylint") then
				table.insert(linters, "pylint")
			end

			-- Default to pylint if no tools found in pyproject.toml
			if #linters == 0 then
				linters = { "pylint" }
			end

			opts.linters_by_ft.python = linters

			-- Configure pylint to run from project root
			opts.linters = opts.linters or {}
			opts.linters.pylint = {
				cmd = "pylint",
				stdin = false,
				args = function()
					local fname = vim.api.nvim_buf_get_name(0)
					local root = find_root(fname)

					if not root then
						root = vim.fn.getcwd()
					else
						root = vim.fs.dirname(root)
					end

					-- Build args
					local args = {
						"--output-format=text",
						"--score=no",
						"--msg-template='{path}:{line}:{column}: {msg_id} {msg} ({symbol})'",
					}

					-- Look for config files: prioritize pyproject.toml, then .pylintrc
					local config_paths = {
						root .. "/pyproject.toml",
						root .. "/.pylintrc",
						root .. "/server/.pylintrc",
						root .. "/pylintrc",
					}

					for _, rc in ipairs(config_paths) do
						if vim.fn.filereadable(rc) == 1 then
							table.insert(args, "--rcfile=" .. rc)
							break
						end
					end

					-- Add the file to lint
					table.insert(args, fname)

					return args
				end,
				-- CRITICAL: Set working directory to project root
				cwd = function()
					local fname = vim.api.nvim_buf_get_name(0)
					local root = find_root(fname)

					if not root then
						return vim.fn.getcwd()
					end

					return vim.fs.dirname(root)
				end,
			}

			-- Configure mypy to use pyproject.toml
			opts.linters.mypy = {
				cmd = "mypy",
				stdin = false,
				args = function()
					local fname = vim.api.nvim_buf_get_name(0)
					local root = find_root(fname)

					if not root then
						root = vim.fn.getcwd()
					else
						root = vim.fs.dirname(root)
					end

					local args = {
						"--show-column-numbers",
						"--show-error-end",
						"--hide-error-codes",
						"--hide-error-context",
						"--no-color-output",
						"--no-error-summary",
						"--no-pretty",
					}

					-- mypy automatically reads from pyproject.toml if present
					table.insert(args, fname)
					return args
				end,
				cwd = function()
					local fname = vim.api.nvim_buf_get_name(0)
					local root = find_root(fname)

					if not root then
						return vim.fn.getcwd()
					end

					return vim.fs.dirname(root)
				end,
			}

			return opts
		end,
	},

	-- Black formatting is already handled by lazyvim.plugins.extras.formatting.black
	-- Black automatically reads configuration from pyproject.toml if present
}
