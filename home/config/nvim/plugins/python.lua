-- Helper function to check if a tool is available
local function has_tool(tool_name)
  -- Check if tool is in PATH
  if vim.fn.executable(tool_name) == 1 then
    return true
  end

  -- Check if tool is in project's pyproject.toml or requirements files
  local root = vim.fn.getcwd()
  local check_files = {
    root .. "/pyproject.toml",
    root .. "/requirements.txt",
    root .. "/requirements/dev.txt",
    root .. "/setup.py",
  }

  for _, file in ipairs(check_files) do
    if vim.fn.filereadable(file) == 1 then
      local content = vim.fn.readfile(file)
      for _, line in ipairs(content) do
        if line:match(tool_name) then
          return true
        end
      end
    end
  end

  return false
end

-- Detect available formatters
local function get_formatters()
  local formatters = {}

  if has_tool("black") then
    table.insert(formatters, "black")
  end

  if has_tool("isort") then
    table.insert(formatters, "isort")
  end

  -- Fallback to ruff format if black is not available but ruff is
  if #formatters == 0 and has_tool("ruff") then
    table.insert(formatters, "ruff_format")
  end

  return formatters
end

-- Detect available linters
local function get_linters()
  local linters = {}

  -- Priority order for main linter: ruff > pylint > flake8
  if has_tool("ruff") then
    table.insert(linters, "ruff")
  elseif has_tool("pylint") then
    table.insert(linters, "pylint")
  elseif has_tool("flake8") then
    table.insert(linters, "flake8")
  end

  -- Add mypy as a type checker (runs alongside the main linter)
  if has_tool("mypy") then
    table.insert(linters, "mypy")
  end

  return linters
end

-- Find project root by looking for common markers
local function find_project_root(start_path)
  local root_markers = { ".git", "pyproject.toml", "setup.py", "setup.cfg", ".pylintrc", "requirements.txt" }

  local dir = vim.fn.fnamemodify(start_path, ":h")
  while dir ~= "/" do
    for _, marker in ipairs(root_markers) do
      if vim.fn.isdirectory(dir .. "/" .. marker) == 1 or vim.fn.filereadable(dir .. "/" .. marker) == 1 then
        return dir
      end
    end
    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end

  return vim.fn.getcwd() -- Fallback to current directory
end

-- Find the closest config file for a tool
-- Searches both upward (from file's directory) and across project
local function find_config(file_path, config_names, validator)
  -- Start from the file's directory
  local file_dir = vim.fn.fnamemodify(file_path, ":h")

  -- First, search upward from the file's directory
  local dir = file_dir
  while dir ~= "/" do
    for _, config_name in ipairs(config_names) do
      local config_path = dir .. "/" .. config_name
      if vim.fn.filereadable(config_path) == 1 then
        -- If validator provided, check if config is valid
        if validator then
          if validator(config_path, config_name) then
            return config_path
          end
        else
          return config_path
        end
      end
    end

    local parent = vim.fn.fnamemodify(dir, ":h")
    if parent == dir then break end
    dir = parent
  end

  -- If not found upward, search from project root
  local root = find_project_root(file_path)
  local found_configs = {}

  for _, config_name in ipairs(config_names) do
    local configs = vim.fn.globpath(root, "**/" .. config_name, false, true)
    vim.list_extend(found_configs, configs)
  end

  -- Find the config file closest to our file (by path length)
  local closest_config = nil
  local shortest_distance = math.huge

  for _, config_path in ipairs(found_configs) do
    -- Validate config if validator provided
    if validator then
      local config_name = vim.fn.fnamemodify(config_path, ":t")
      if not validator(config_path, config_name) then
        goto continue
      end
    end

    -- Calculate path distance (number of directories between file and config)
    local config_dir = vim.fn.fnamemodify(config_path, ":h")
    local file_rel = vim.fn.fnamemodify(file_path, ":p")
    local config_rel = vim.fn.fnamemodify(config_path, ":p")

    -- Count the path segments difference
    local file_parts = vim.split(file_rel, "/")
    local config_parts = vim.split(config_rel, "/")

    -- Find common prefix length
    local common = 0
    for i = 1, math.min(#file_parts, #config_parts) do
      if file_parts[i] == config_parts[i] then
        common = i
      else
        break
      end
    end

    local distance = (#file_parts - common) + (#config_parts - common)
    if distance < shortest_distance then
      shortest_distance = distance
      closest_config = config_path
    end

    ::continue::
  end

  return closest_config
end

-- Validator for pylint configs
local function validate_pylint_config(config_path, config_name)
  if config_name == "pyproject.toml" or config_name == "setup.cfg" then
    local content = table.concat(vim.fn.readfile(config_path), "\n")
    return content:match("%[tool%.pylint") or content:match("%[pylint")
  end
  return true
end

-- Validator for mypy configs
local function validate_mypy_config(config_path, config_name)
  if config_name == "pyproject.toml" or config_name == "setup.cfg" then
    local content = table.concat(vim.fn.readfile(config_path), "\n")
    return content:match("%[tool%.mypy") or content:match("%[mypy")
  end
  return true
end

return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local formatters = get_formatters()

      return {
        formatters_by_ft = {
          python = formatters,
        },
        formatters = {
          black = {
            command = "black",
            args = {
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
            -- Set cwd to enable black to find its config files
            cwd = require("conform.util").root_file({
              "pyproject.toml",
              ".black",
              "setup.py",
              ".git",
            }),
          },
          isort = {
            command = "isort",
            args = {
              "--stdout",
              "--filename",
              "$FILENAME",
              "-",
            },
            -- Set cwd to enable isort to find its config files
            cwd = require("conform.util").root_file({
              "pyproject.toml",
              ".isort.cfg",
              "setup.py",
              ".git",
            }),
          },
          ruff_format = {
            command = "ruff",
            args = {
              "format",
              "--stdin-filename",
              "$FILENAME",
              "-",
            },
            -- Set cwd to enable ruff to find its config files
            cwd = require("conform.util").root_file({
              "pyproject.toml",
              "ruff.toml",
              ".ruff.toml",
              ".git",
            }),
          },
        },
        -- Fallback to LSP formatting if no formatters are available
        format_on_save = {
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      }
    end,
  },

  -- Conditional linting: auto-detect available linters
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local linters = get_linters()

      -- Preserve the events field from LazyVim defaults
      local config = {
        events = opts.events or { "BufWritePost", "BufReadPost", "InsertLeave" },
        linters_by_ft = opts.linters_by_ft or {},
        linters = vim.tbl_extend("force", opts.linters or {}, {
          ruff = {
            args = {
              "check",
              "--output-format=text",
              "--stdin-filename",
              "$FILENAME",
              "--no-fix",
              "-",
            },
          },
          pylint = {
            cmd = "pylint",
            stdin = false,
            args = function()
              -- Get the current file being linted
              local filename = vim.api.nvim_buf_get_name(0)
              local args = {
                "--output-format=text",
                "--score=no",
                "--msg-template='{path}:{line}:{column}: {msg_id} {msg} ({symbol})'",
              }

              -- Try to find a pylintrc file
              local config_names = { ".pylintrc", "pylintrc", "pyproject.toml", "setup.cfg" }
              local pylintrc = find_config(filename, config_names, validate_pylint_config)
              if pylintrc then
                table.insert(args, "--rcfile=" .. pylintrc)
              end

              table.insert(args, filename)
              return args
            end,
            -- Set working directory to project root (critical for import resolution)
            cwd = function()
              local filename = vim.api.nvim_buf_get_name(0)
              -- Find the project root (where .pylintrc or .git is)
              local root = find_project_root(filename)
              return root
            end,
          },
          mypy = {
            cmd = "mypy",
            stdin = false,
            args = function()
              local filename = vim.api.nvim_buf_get_name(0)
              local args = {
                "--show-column-numbers",
                "--show-error-codes",
                "--no-error-summary",
                "--no-pretty",
              }

              -- Try to find a mypy config file
              local config_names = { "mypy.ini", ".mypy.ini", "pyproject.toml", "setup.cfg" }
              local mypy_config = find_config(filename, config_names, validate_mypy_config)
              if mypy_config then
                table.insert(args, "--config-file=" .. mypy_config)
              end

              table.insert(args, filename)
              return args
            end,
            -- Set working directory to project root (critical for import resolution)
            cwd = function()
              local filename = vim.api.nvim_buf_get_name(0)
              local root = find_project_root(filename)
              return root
            end,
          },
          flake8 = {
            cmd = "flake8",
            stdin = false,
            args = {
              "--format=default",
              "--stdin-display-name",
              "$FILENAME",
              "-",
            },
          },
        }),
      }

      -- Only add linters if available
      if #linters > 0 then
        config.linters_by_ft.python = linters
      end

      return config
    end,
  },
}
