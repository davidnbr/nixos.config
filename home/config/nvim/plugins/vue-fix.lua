return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Fix Vue language server configuration
        volar = {
          mason = true, -- Let Mason handle it
          -- Remove any incorrect package paths
        },
        -- Disable the incorrectly configured vue-language-server
        ["vue-language-server"] = false,
      },
    },
  },
}
