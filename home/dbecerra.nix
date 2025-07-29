{ config, pkgs, inputs, lib, ... }:
let
  sqlls = pkgs.nodePackages.sql-language-server or null;
in 
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dbecerra";
  home.homeDirectory = "/home/dbecerra";

  home.stateVersion = "25.05";
  
  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "Hack" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    vscode
    google-chrome
    firefox
    wpsoffice

    python311
    python311Packages.pip
    go
    nodejs_20

    awscli2
    gh
    terraform
    terragrunt
    ansible
    ansible-lint
    aws-vault
    lazydocker
    ripgrep
    htop
    fzf
    bat
    jq
    blesh
    tree
    xclip
    tmux
    pre-commit
    nix-prefetch-github
  ];
  fonts.fontconfig.enable = true;

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/dbecerra/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.bash = {
    enable = true;
    enableCompletion = false;
    
    initExtra = ''
      # Load any additional configurations  
      if [ -f ~/.bashrc.local ]; then
        source ~/.bashrc.local
      fi
    '';
    
    bashrcExtra = ''
      # Ble.sh early initialization - MUST be first for interactive shells
      [[ $- == *i* ]] && [[ -f ${pkgs.blesh}/share/blesh/ble.sh ]] && source ${pkgs.blesh}/share/blesh/ble.sh --attach=none
      
      ${builtins.readFile ./.bashrc}

      # Ble.sh final attachment - MUST be last
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
    '';
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";  # Path to your existing key
        identitiesOnly = true;  # Only use the specified key
      };
    };

    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
  services.ssh-agent.enable = true;
  
  programs.eza = {
    enable = true;
    enableBashIntegration = true;
    git = true;
    icons = "auto";
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
  
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      git
      gcc
      nodejs
      python3
      ruby

      # Core LSP servers based on your extras
      nil                                    # Nix LSP (lang.nix)
      lua-language-server                    # Lua LSP
      nodePackages.typescript-language-server # TypeScript/JavaScript LSP
      nodePackages.bash-language-server      # Bash LSP
      
      # Language-specific LSP servers for your extras
      ansible-language-server               # Ansible (lang.ansible)
      cmake-language-server                 # CMake (lang.cmake)  
      dockerfile-language-server-nodejs     # Docker (lang.docker)
      gopls                                 # Go (lang.go)
      nodePackages.vscode-json-languageserver # JSON (lang.json)
      marksman                              # Markdown (lang.markdown)
      pyright                               # Python (lang.python)
      terraform-ls                          # Terraform (lang.terraform)
      taplo                                 # TOML (lang.toml)
      vue-language-server                   # Vue (lang.vue)
      yaml-language-server                  # YAML (lang.yaml)
      
      # Additional LSP servers
      jsonnet-language-server               # For various config files
      helm-ls                               # Helm charts
      
      # Formatters and linters
      black                                 # Python formatter
      isort                                 # Python import sorter
      ruff                                  # Python linter/formatter
      gofumpt                              # Go formatter
      gotools                              # Go tools (goimports, etc)
      golangci-lint                        # Go linter
      stylua                               # Lua formatter
      nodePackages.prettier               # General formatter (JS/TS/JSON/MD/YAML)
      nodePackages.eslint                  # JavaScript/TypeScript linter
      rubocop                              # Ruby linter/formatter
      shfmt                                # Shell script formatter
      shellcheck                           # Shell script linter
      hadolint                             # Dockerfile linter
      tflint                               # Terraform linter
      tfsec                                # Terraform security scanner
      yamllint                             # YAML linter
      ansible-lint                         # Ansible linter
      markdownlint-cli2                    # Markdown linter
      
      # Tools for telescope and other features
      ripgrep                              # For telescope
      fd                                   # For telescope  
      fzf                                  # Fuzzy finder
      tree-sitter                          # For treesitter
      
      # Git tools (lang.git extra)
      gh                                   # GitHub CLI
      glab                                 # GitLab CLI
      delta                                # Git diff tool
      lazygit                              # Git TUI (util.gitui)
      
      # Additional useful tools
      curl
      wget
      unzip
      gnutar
      gzip
      jq                                   # JSON processor
      yq                                   # YAML processor
    ] ++ pkgs.lib.optionals (sqlls != null) [ sqlls ]; # SQL (lang.sql) - if available
    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];
  };

  xdg.configFile."nvim/lua/plugins/mason.lua".text = ''
    return {
      -- Disable Mason completely
      { "williamboman/mason.nvim", enabled = false },
      { "williamboman/mason-lspconfig.nvim", enabled = false },
      
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
            "ansiblels",        -- Ansible
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
          opts.formatters_by_ft.nix = { "nixfmt" }
          
          return opts
        end,
      },
      
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
  '';

  xdg.configFile."nvim/lua/plugins/treesitter.lua".text = ''
    return {
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          auto_install = false,  -- Don't auto-install parsers
          ensure_installed = {}, -- Let Nix handle this
        },
      },
    }
  '';
  
  xdg.configFile."nvim/lua/plugins/extras-config.lua".text = ''
    return {
      -- Go extra configuration
      {
        "ray-x/go.nvim",
        opts = {
          goimports = "goimports", -- Use system goimports
          fillstruct = "fillstruct",
          dap_debug = false, -- Disable DAP for now
        },
      },
      
      -- Python extra configuration  
      {
        "linux-cultist/venv-selector.nvim",
        opts = {
          auto_refresh = true,
        },
      },
      
      -- Disable any DAP configurations that might conflict
      {
        "mfussenegger/nvim-dap",
        enabled = false, -- Disable for now, can enable later with proper Nix setup
      },
      {
        "rcarriga/nvim-dap-ui", 
        enabled = false,
      },
    }
  '';


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";
  home.file.".config/tmux/tmux.conf.local".source = ./tmux.conf.local;
  #home.shellAliases.tmux = "tmux -f ~/.config/tmux/tmux.conf";
  home.file.".config/tmux/plugins/catppuccin" = {
    source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v2.1.2";
      hash = "sha256-vBYBvZrMGLpMU059a+Z4SEekWdQD0GrDqBQyqfkEHPg=";
    };
    recursive = true;
  };
  home.sessionVariables = {
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = import ./starship.nix;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    hooks = {
      pre-commit-custom = pkgs.writeShellScript "pre-commit-custom" ''
        #!/usr/bin/env bash
        set -ex

        ${pkgs.pre-commit}/bin/pre-commit run --config "pre-commit-config.yaml" "$@"
      '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
