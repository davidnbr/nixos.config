return {
  -- Minimap-lite scrollbar with git / diagnostic / search / mark decorations.
  {
    "lewis6991/satellite.nvim",
    event = "VeryLazy",
    opts = {
      current_only = false,
      winblend = 50,
      zindex = 40,
      excluded_filetypes = { "neo-tree", "trouble", "snacks_dashboard" },
      handlers = {
        cursor = { enable = true },
        search = { enable = true },
        diagnostic = { enable = true },
        gitsigns = { enable = true },
        marks = { enable = true },
        quickfix = { enable = true },
      },
    },
  },
}
