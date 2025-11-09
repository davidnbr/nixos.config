-- Python configuration that extends LazyVim's lang.python extra
-- This overrides specific settings while keeping LazyVim's defaults

-- Helper to find project root
local function find_root(fname)
  local root_markers = { ".git", "pyproject.toml", "setup.py", ".pylintrc", "requirements.txt" }
  local path = vim.fs.dirname(fname)
  return vim.fs.find(root_markers, { path = path, upward = true })[1]
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

  -- Configure linting: Use pylint with proper working directory
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- Only use pylint for Python files
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.python = { "pylint" }

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

          -- Look for .pylintrc in root or server/
          local pylintrc_paths = {
            root .. "/.pylintrc",
            root .. "/server/.pylintrc",
            root .. "/pylintrc",
          }

          for _, rc in ipairs(pylintrc_paths) do
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

      return opts
    end,
  },

  -- Black formatting is already handled by lazyvim.plugins.extras.formatting.black
  -- No need to configure it here
}
