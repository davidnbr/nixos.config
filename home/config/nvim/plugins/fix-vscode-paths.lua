-- ~/.config/nvim/lua/plugins/fix-vscode-paths.lua
return {
  -- This plugin will load early and fix path issues in VSCode
  {
    "LazyVim/LazyVim",
    optional = true,
    opts = function(_, opts)
      -- Check if running in VSCode
      if vim.g.vscode == 1 then
        -- Disable Lua compilation completely
        vim.g.lua_nocompile = 1

        -- Prevent textobjects modules from loading
        if package.loaded["nvim-treesitter"] then
          package.loaded["nvim-treesitter.textobjects"] = {}
          package.loaded["nvim-treesitter.textobjects.move"] = {}
          package.loaded["nvim-treesitter.textobjects.select"] = {}
        end

        -- Disable snacks.nvim notifications
        if package.loaded["snacks"] then
          package.loaded["snacks.notifier"] = {}
          package.loaded["snacks.win"] = {}
        end
      end
    end,
  },

  -- Explicitly disable problematic plugins in VSCode
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = not vim.g.vscode,
  },

  -- If you know the specific name of snacks.nvim plugin
  --{
  --  "folke/snacks.nvim", -- replace with actual plugin name
  --  enabled = not vim.g.vscode,
  --},
}
