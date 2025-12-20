return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      -- NixOS: Ensure gcc is available for parser compilation
      vim.g.loaded_node_provider = 0
      vim.g.loaded_perl_provider = 0
      vim.g.loaded_python3_provider = 0
      vim.g.loaded_ruby_provider = 0

      -- Set compiler for NixOS
      require("nvim-treesitter.install").compilers = { "gcc" }
      require("nvim-treesitter.install").prefer_git = true

      return opts
    end,
  },
}
