-- Configure LSPs for NixOS compatibility
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Use NixOS-packaged lua_ls instead of Mason
        lua_ls = {
          mason = false,
        },
        -- Use NixOS-packaged nil for Nix files
        nil_ls = {
          mason = false,
        },
      },
    },
  },
}
