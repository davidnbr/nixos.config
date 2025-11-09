return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      -- Uses your existing Claude Code CLI installation
      terminal_cmd = "claude", -- Points to your installed Claude Code CLI

      -- Server configuration for WebSocket communication
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info",

      -- Terminal integration for continuous use
      terminal = {
        split_side = "right",
        split_width_percentage = 0.35,
        provider = "auto",
        auto_close = false, -- Keep Claude Code CLI session open
      },

      -- Real-time diff integration
      diff_opts = {
        auto_close_on_accept = false,
        vertical_split = true,
        open_in_current_tab = true,
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
    config = function(_, opts)
      require("claudecode").setup(opts)

      -- Check if Claude Code CLI is properly installed
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          local handle = io.popen("which claude")
          local result = handle:read("*a")
          handle:close()

          if result == "" then
            vim.notify("Claude Code CLI not found in PATH", vim.log.levels.WARN)
          else
            vim.notify("Claude Code CLI found: " .. result:gsub("\n", ""), vim.log.levels.INFO)
          end
        end,
      })
    end,
  },
}
