-- Quiet markdownlint-cli2 noise (MD013 line-length, etc.) via a global config.
-- Uses LazyVim's `prepend_args` mechanism (nvim-lint `args` must be a list, so a
-- whole-function override is invalid). markdownlint-cli2's --config takes
-- precedence over auto-discovered project configs; acceptable as a personal
-- default since repos rarely ship a markdownlint config.
return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            vim.fn.expand("~/.config/nvim/markdownlint.jsonc"),
          },
        },
      },
    },
  },
}
