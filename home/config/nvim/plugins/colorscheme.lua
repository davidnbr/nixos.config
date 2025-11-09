return {
  -- OneDarkPro - Enhanced for readability
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    opts = {
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
    },
    config = function(_, opts)
      require("onedarkpro").setup(opts)
      vim.cmd("colorscheme onedark")

      -- Apply custom highlights after colorscheme loads
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "onedark",
        callback = function()
          -- Better cursor line visibility
          vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#c678dd", bold = true })

          -- Better search highlighting
          vim.api.nvim_set_hl(0, "Search", { bg = "#e5c07b", fg = "#282c34" })
          vim.api.nvim_set_hl(0, "IncSearch", { bg = "#d19a66", fg = "#282c34" })

          -- Better window separator
          vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#4b5263" })

          -- Dimmed inactive windows (subtle)
          vim.api.nvim_set_hl(0, "NormalNC", { bg = "#282c34", fg = "#5c6370" })

          -- Better floating windows
          vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#56b6c2", bg = "#2c323c" })

          -- Illuminate - word highlighting under cursor
          vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#3e4451", underline = false })
          vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#3e4451", underline = false })
          vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3e4451", underline = false })
        end,
      })

      -- Apply immediately
      vim.cmd("doautocmd ColorScheme onedark")
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "onedark",
      relativenumber = false,
    },
  },
}
