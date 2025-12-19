return {
  -- Configure LSP to not use Mason for all your language extras
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      
      -- Disable Mason for all servers and configure them
      local servers = {
        -- Core
        "nil_ls",           -- Nix
        "lua_ls",           -- Lua
        "tsserver",         -- TypeScript/JavaScript
        "bashls",           -- Bash
        
        -- Your enabled language extras
        -- "ansiblels",        -- Ansible (removed due to unmaintained error)
        "cmake",            -- CMake
        "dockerls",         -- Docker
        "gopls",            -- Go
        "jsonls",           -- JSON
        "marksman",         -- Markdown
        "pyright",          -- Python
        "sqlls",            -- SQL
        "terraformls",      -- Terraform
        "taplo",            -- TOML
        "volar",            -- Vue
        "yamlls",           -- YAML
      }
      
      for _, server in ipairs(servers) do
        opts.servers[server] = { mason = false }
      end
      
      return opts
    end,
  },
}
