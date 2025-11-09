return {
  -- Focus.nvim - Dim inactive windows for better focus
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
      enable = true,
      commands = true,
      autoresize = {
        enable = false, -- Don't auto-resize windows
        width = 0,
        height = 0,
        minwidth = 0,
        minheight = 0,
        height_quickfix = 10,
      },
      split = {
        bufnew = false,
        tmux = false,
      },
      ui = {
        number = true, -- Display line numbers in focused window
        relativenumber = false, -- Display relative line numbers in focused window
        hybridnumber = false,
        absolutenumber_unfocussed = true, -- Preserve absolute numbers in unfocused windows

        cursorline = true, -- Display cursorline in focused window
        cursorcolumn = false,
        colorcolumn = {
          enable = false,
        },
        signcolumn = true, -- Display signcolumn in focused window
        winhighlight = true, -- Auto highlighting for focused/unfocused windows
      },
    },
    config = function(_, opts)
      require("focus").setup(opts)

      -- Set up highlighting for focused and unfocused windows
      -- These will work with your onedarkpro colorscheme
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          -- Dimmed background for unfocused windows
          vim.api.nvim_set_hl(0, "NormalNC", {
            bg = vim.api.nvim_get_hl(0, { name = "Normal" }).bg,
            fg = "#6c7a89", -- Dimmed foreground
          })
        end,
      })

      -- Disable for certain filetypes
      local ignore_filetypes = { "neo-tree", "TelescopePrompt" }
      local ignore_buftypes = { "nofile", "prompt", "popup" }

      vim.api.nvim_create_autocmd("WinEnter", {
        callback = function()
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.w.focus_disable = true
          end
        end,
      })
    end,
  },
}
