-- THEME SETUP
--
-- Switch theme = change the single `theme` value below, then restart (or
-- `:LazyVim` reload). Preview any installed theme live, no edit, with <leader>uC.
--
-- Valid values are any colorscheme name provided by the plugins listed in
-- `theme_library` below, e.g.:
--   "onedark", "onedark_vivid", "onedark_dark"
--   "catppuccin", "catppuccin-mocha", "catppuccin-macchiato", "catppuccin-frappe"
--   "tokyonight", "tokyonight-moon", "tokyonight-night", "tokyonight-storm"
--   "kanagawa", "kanagawa-wave", "kanagawa-dragon"
--   "gruvbox", "rose-pine", "rose-pine-moon", "nightfox", "carbonfox", "duskfox"
local theme = "onedark"

-- Installed theme plugins (lazy-loaded). Add a line here to make a new theme
-- available to the picker and to `theme` above. lazy.nvim fetches it on sync.
local theme_library = {
  { "olimorris/onedarkpro.nvim" },
  { "catppuccin/nvim", name = "catppuccin" },
  { "folke/tokyonight.nvim" },
  { "rebelot/kanagawa.nvim" },
  { "ellisonleao/gruvbox.nvim" },
  { "rose-pine/neovim", name = "rose-pine" },
  { "EdenEast/nightfox.nvim" },
}

local specs = {}
for _, plugin in ipairs(theme_library) do
  table.insert(
    specs,
    vim.tbl_extend("force", plugin, { lazy = true, priority = 1000 })
  )
end

-- onedarkpro-specific options (only used when an onedark variant is active).
specs[1].opts = {
  options = {
    cursorline = true,
    transparency = false,
    terminal_colors = true,
    lualine_transparency = false,
    highlight_inactive_windows = true,
  },
  styles = {
    comments = "italic",
    keywords = "bold",
    functions = "NONE",
    strings = "NONE",
    variables = "NONE",
  },
}

-- Tell LazyVim which colorscheme to load on startup (handles loading the
-- corresponding lazy plugin automatically).
table.insert(specs, {
  "LazyVim/LazyVim",
  opts = { colorscheme = theme },
})

-- Extra polish for onedark only — guarded by the ColorScheme pattern, so it
-- never touches other themes.
table.insert(specs, {
  "olimorris/onedarkpro.nvim",
  optional = true,
  config = function(_, opts)
    require("onedarkpro").setup(opts)
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "onedark*",
      callback = function()
        vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c678dd", bold = true })
        vim.api.nvim_set_hl(0, "Search", { bg = "#e5c07b", fg = "#282c34" })
        vim.api.nvim_set_hl(0, "IncSearch", { bg = "#d19a66", fg = "#282c34" })
        vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4b5263" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "#282c34", fg = "#5c6370" })
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#56b6c2", bg = "#2c323c" })
        vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3e4451", underline = false })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3e4451", underline = false })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3e4451", underline = false })
      end,
    })
  end,
})

return specs
