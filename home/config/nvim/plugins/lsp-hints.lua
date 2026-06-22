-- LazyVim already enables inlay hints globally (inlay_hints.enabled = true), but
-- a server only shows them if configured to emit them. Turn them on for gopls
-- and lua_ls here. Toggle per-buffer anytime with <leader>uh.
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              hint = {
                enable = true,
                arrayIndex = "Disable",
                setType = true,
              },
            },
          },
        },
      },
    },
  },
}
