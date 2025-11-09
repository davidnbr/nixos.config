return {
  -- Bufferline - Better buffer/tab management
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>", desc = "Toggle pin" },
      { "<leader>bP", "<Cmd>BufferLineGroupClose ungrouped<CR>", desc = "Delete non-pinned buffers" },
      { "<leader>bo", "<Cmd>BufferLineCloseOthers<CR>", desc = "Delete other buffers" },
      { "<leader>br", "<Cmd>BufferLineCloseRight<CR>", desc = "Delete buffers to the right" },
      { "<leader>bl", "<Cmd>BufferLineCloseLeft<CR>", desc = "Delete buffers to the left" },
      { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
      { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
      { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
    },
    opts = {
      options = {
        close_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        right_mouse_command = function(n)
          require("mini.bufremove").delete(n, false)
        end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
        -- Better visual appearance
        separator_style = "thin", -- Options: "slant", "slope", "thick", "thin"
        indicator = {
          icon = "▎",
          style = "icon",
        },
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        move_wraps_at_ends = false,
        -- Grouping
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            {
              name = "Tests",
              highlight = { underline = true, sp = "blue" },
              priority = 2,
              icon = "",
              matcher = function(buf)
                return buf.name:match("%_test") or buf.name:match("%_spec")
              end,
            },
            {
              name = "Docs",
              highlight = { underline = true, sp = "green" },
              auto_close = false,
              matcher = function(buf)
                return buf.name:match("%.md") or buf.name:match("%.txt")
              end,
            },
          },
        },
      },
    },
    config = function(_, opts)
      require("bufferline").setup(opts)

      -- Smart :q behavior
      -- Close buffer first, then close window if it's the last buffer
      vim.api.nvim_create_user_command("SmartQuit", function()
        local bufnr = vim.api.nvim_get_current_buf()
        local buffers = vim.fn.getbufinfo({ buflisted = 1 })

        -- Count listed buffers
        local listed_count = 0
        for _, buf in ipairs(buffers) do
          if buf.listed == 1 then
            listed_count = listed_count + 1
          end
        end

        -- If only one buffer, quit vim
        if listed_count <= 1 then
          vim.cmd("quit")
        else
          -- Close current buffer and switch to next
          local success = pcall(require("mini.bufremove").delete, bufnr, false)
          if not success then
            vim.cmd("quit")
          end
        end
      end, {})

      -- Remap :q to use SmartQuit
      vim.api.nvim_create_user_command("Q", "SmartQuit", {})

      -- Also handle :q in command mode
      vim.keymap.set("n", "<leader>q", "<cmd>SmartQuit<cr>", { desc = "Smart quit (close buffer or vim)" })
    end,
  },
}
