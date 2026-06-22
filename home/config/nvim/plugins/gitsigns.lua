return {
  -- GitLens-style inline blame on the current line.
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 400,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "  <author>, <author_time:%R> · <summary>",
    },
  },
}
