return {
  -- snacks "bigfile" forces a buffer's filetype to "bigfile" past a threshold,
  -- which disables LSP, treesitter, completion AND format-on-save (conform has
  -- no formatter keyed on "bigfile"). Defaults are 1.5MB or avg line length
  -- > 1000 chars. Large-but-normal config JSON (long embedded strings, etc.)
  -- tripped the line-length heuristic and stopped formatting on save. Raise
  -- both limits so only genuinely huge / minified files lose features.
  {
    "folke/snacks.nvim",
    opts = {
      bigfile = {
        size = 10 * 1024 * 1024, -- 10MB
        line_length = 5000, -- avg line length before it counts as minified
      },
    },
  },
}
