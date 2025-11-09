return {
  -- add onedark
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    -- cmd = { "nvim colorscheme onedark" },
    opts = {
      colorscheme = "onedark",
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
      relativenumber = false,
    },
  },
}
