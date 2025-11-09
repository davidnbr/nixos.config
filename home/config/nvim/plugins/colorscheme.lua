return {
  -- OneDarkPro - Enhanced for readability
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    opts = {
      colors = {}, -- Override default colors
      highlights = {
        -- Better cursor line visibility
        CursorLine = { bg = "${bg2}" },
        CursorLineNr = { fg = "${purple}", bg = "${bg2}", bold = true },

        -- Better visual selection
        Visual = { bg = "${selection}" },

        -- Better search highlighting
        Search = { bg = "${yellow}", fg = "${bg}" },
        IncSearch = { bg = "${orange}", fg = "${bg}" },
        CurSearch = { bg = "${orange}", fg = "${bg}", bold = true },

        -- Better window separator
        WinSeparator = { fg = "${gray}", bold = false },
        VertSplit = { fg = "${gray}" },

        -- Dimmed inactive windows (works with focus.nvim)
        NormalNC = { bg = "${bg}", fg = "${gray}" },

        -- Better floating windows
        NormalFloat = { bg = "${bg2}" },
        FloatBorder = { fg = "${cyan}", bg = "${bg2}" },

        -- Better completion menu
        Pmenu = { bg = "${bg2}" },
        PmenuSel = { bg = "${selection}", bold = true },
        PmenuBorder = { fg = "${cyan}", bg = "${bg2}" },

        -- Better status line
        StatusLine = { bg = "${bg2}" },
        StatusLineNC = { bg = "${bg}", fg = "${gray}" },

        -- Better tab line / bufferline
        TabLine = { bg = "${bg}", fg = "${gray}" },
        TabLineFill = { bg = "${bg}" },
        TabLineSel = { bg = "${bg2}", fg = "${fg}", bold = true },

        -- Better Neo-tree
        NeoTreeNormal = { bg = "${bg}" },
        NeoTreeNormalNC = { bg = "${bg}" },
        NeoTreeCursorLine = { bg = "${bg2}" },

        -- Illuminate - word highlighting under cursor
        IlluminatedWordText = { bg = "${bg2}", underline = true },
        IlluminatedWordRead = { bg = "${bg2}", underline = true },
        IlluminatedWordWrite = { bg = "${bg2}", underline = true },
      },
      options = {
        cursorline = true,
        transparency = false, -- Set to true if you want transparent background
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
