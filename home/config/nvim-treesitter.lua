return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = false,  -- Don't auto-install parsers
      ensure_installed = {}, -- Let Nix handle this
    },
  },
}
