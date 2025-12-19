return {
  -- Configure formatters for all your languages
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      
      -- Configure formatters based on your extras
      opts.formatters_by_ft.lua = { "stylua" }
      opts.formatters_by_ft.python = { "black", "isort" }
      opts.formatters_by_ft.go = { "gofumpt", "goimports" }
      opts.formatters_by_ft.ruby = { "rubocop" }
      opts.formatters_by_ft.javascript = { "prettier" }
      opts.formatters_by_ft.typescript = { "prettier" }
      opts.formatters_by_ft.vue = { "prettier" }
      opts.formatters_by_ft.json = { "prettier" }
      opts.formatters_by_ft.yaml = { "prettier" }
      opts.formatters_by_ft.markdown = { "prettier" }
      opts.formatters_by_ft.terraform = { "terraform_fmt" }
      opts.formatters_by_ft.toml = { "taplo" }
      opts.formatters_by_ft.sh = { "shfmt" }
      opts.formatters_by_ft.bash = { "shfmt" }
      opts.formatters_by_ft.nix = { "nixfmt-rfc-style" }
      
      return opts
    end,
  },
}
