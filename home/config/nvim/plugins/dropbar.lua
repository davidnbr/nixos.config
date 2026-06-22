return {
  -- VSCode-style breadcrumbs: clickable path + symbol winbar at top of buffer.
  -- Requires Neovim >= 0.11 (you run 0.12).
  {
    "Bekaboo/dropbar.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      {
        "<leader>cp",
        function()
          require("dropbar.api").pick()
        end,
        desc = "Breadcrumbs picker (dropbar)",
      },
    },
  },
}
