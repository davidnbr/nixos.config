return {
  -- Configure linters for all your languages
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      
      -- Configure linters based on your extras
      opts.linters_by_ft.python = { "ruff" }
      opts.linters_by_ft.go = { "golangci-lint" }
      opts.linters_by_ft.ruby = { "rubocop" }
      opts.linters_by_ft.javascript = { "eslint" }
      opts.linters_by_ft.typescript = { "eslint" }
      opts.linters_by_ft.vue = { "eslint" }
      opts.linters_by_ft.dockerfile = { "hadolint" }
      opts.linters_by_ft.terraform = { "tflint", "tfsec" }
      opts.linters_by_ft.yaml = { "yamllint" }
      opts.linters_by_ft.ansible = { "ansible-lint" }
      opts.linters_by_ft.sh = { "shellcheck" }
      opts.linters_by_ft.bash = { "shellcheck" }
      
      return opts
    end,
  },
}
