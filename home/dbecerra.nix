{ config, pkgs, pkgs-unstable, inputs, lib, ... }:
let
  sqlls = pkgs.nodePackages.sql-language-server or null;
  asdf2nix-wrapper = pkgs.writeShellScriptBin "asdf2nix" ''
    #!/usr/bin/env bash
    exec ${inputs.nixpkgs.legacyPackages.${pkgs.system}.nix}/bin/nix run github:brokenpip3/asdf2nix -- "$@"
  '';
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dbecerra";
  home.homeDirectory = "/home/dbecerra";

  home.stateVersion = "25.05";

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nix;
    settings = {
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  home.packages = with pkgs; [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    #(pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
    nerd-fonts.hack

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs-unstable._1password-cli
    pkgs-unstable._1password-gui
    pkgs-unstable.vscode
    pkgs-unstable.google-chrome
    pkgs-unstable.firefox
    pkgs-unstable.slack

    pkgs-unstable.libreoffice-fresh
    kdePackages.okular
    pdfarranger
    pdftk
    pkgs-unstable.hunspell
    pkgs-unstable.hunspellDicts.en_US
    pkgs-unstable.hunspellDicts.es_ES
    # Microsoft-compatible fonts for perfect .docx rendering
    corefonts # Arial, Times New Roman, etc.
    vistafonts # Calibri, Cambria, etc.
    liberation_ttf # Metric-compatible alternatives
    carlito # Calibri replacement
    caladea # Cambria replacement
    dejavu_fonts
    noto-fonts

    gimp
    imagemagick
    inkscape
    krita

    #wpsoffice
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs

    (pkgs.python311.withPackages (ps: with ps; [ pip httpx ]))
    pkgs-unstable.uv
    pkgs-unstable.go
    pkgs-unstable.nodejs_20
    pkgs-unstable.ruby_3_4
    pkgs-unstable.elixir_1_18

    pkgs-unstable.awscli2
    pkgs-unstable.ssm-session-manager-plugin
    pkgs-unstable.gh
    pkgs-unstable.act
    pkgs-unstable.terraform
    pkgs-unstable.terragrunt
    pkgs-unstable.azure-cli
    ansible
    ansible-lint
    pkgs-unstable.aws-vault

    lazydocker
    mqttui
    tcpdump
    trivy
    smem
    ripgrep
    htop
    fzf
    bat
    jq
    pkgs-unstable.blesh
    tree
    xclip
    gcc
    unzip
    fd
    graphviz

    shfmt
    tflint
    tfsec
    checkov
    shellcheck
    nixfmt-classic

    pkgs-unstable.tmux
    pkgs-unstable.pre-commit
    pkgs-unstable.tldr
    nix-prefetch-github
    nix-prefetch-git
    inputs.iecs.packages.${pkgs.system}.default
    inputs.devenv.packages.${pkgs.system}.devenv
    pkgs-unstable.claude-code
    asdf2nix-wrapper
    pkgs-unstable.gemini-cli
    pkgs-unstable.fabric-ai

    # Build tools for LSPs
    cargo
    rustc
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace =
        [ "Hack Nerd Font" "DejaVu Sans Mono" "Liberation Mono" "Courier New" ];
      sansSerif = [ "DejaVu Sans" "Liberation Sans" "Arial" ];
      serif = [ "DejaVu Serif" "Liberation Serif" "Times New Roman" ];
    };
  };

  home.activation.rebuildFontCache =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $VERBOSE_ECHO "Rebuilding font cache..."
      $DRY_RUN_CMD ${pkgs.fontconfig}/bin/fc-cache -rf
    '';

  # MIME associations - .docx files open with LibreOffice automatically
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/vnd.openxmlformats-officedocument.wordprocessingml.document" =
        "libreoffice-writer.desktop";
      "application/msword" = "libreoffice-writer.desktop";
      "application/pdf" = "org.kde.okular.desktop";
      "image/png" = "org.gimp.GIMP.desktop";
      "image/jpeg" = "org.gimp.GIMP.desktop";
    };
  };

  # System integration settings
  home.sessionVariables = {
    SAL_USE_VCLPLUGIN = "gtk3"; # Better desktop integration
  };

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
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";

  };

  home.file.".bashrc".source = ./config/bashrc;



  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519"; # Path to your existing key
        identitiesOnly = true; # Only use the specified key
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
    extraOptions = [ "--group-directories-first" "--header" ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs-unstable;
      [
        git
        gcc
        nodejs
        python3
        ruby

        # Core LSP servers based on your extras
        nil # Nix LSP (lang.nix)
        lua-language-server # Lua LSP
        nodePackages.typescript-language-server # TypeScript/JavaScript LSP
        nodePackages.bash-language-server # Bash LSP

        # Language-specific LSP servers for your extras

        cmake-language-server # CMake (lang.cmake)
        dockerfile-language-server # Docker (lang.docker)
        gopls # Go (lang.go)
        nodePackages.vscode-json-languageserver # JSON (lang.json)
        marksman # Markdown (lang.markdown)
        pyright # Python (lang.python)
        terraform-ls # Terraform (lang.terraform)
        taplo # TOML (lang.toml)
        vue-language-server # Vue (lang.vue)
        yaml-language-server # YAML (lang.yaml)

        # Additional LSP servers
        jsonnet-language-server # For various config files
        helm-ls # Helm charts

        # Formatters and linters
        black # Python formatter
        isort # Python import sorter
        ruff # Python linter/formatter
        gofumpt # Go formatter
        gotools # Go tools (goimports, etc)
        golangci-lint # Go linter
        stylua # Lua formatter
        nodePackages.prettier # General formatter (JS/TS/JSON/MD/YAML)
        nodePackages.eslint # JavaScript/TypeScript linter
        rubocop # Ruby linter/formatter
        shfmt # Shell script formatter
        shellcheck # Shell script linter
        hadolint # Dockerfile linter
        tflint # Terraform linter
        tfsec # Terraform security scanner
        yamllint # YAML linter
        ansible-lint # Ansible linter
        markdownlint-cli2 # Markdown linter

        # Tools for telescope and other features
        ripgrep # For telescope
        fd # For telescope
        fzf # Fuzzy finder
        tree-sitter # For treesitter

        # Git tools (lang.git extra)
        gh # GitHub CLI
        glab # GitLab CLI
        delta # Git diff tool
        lazygit # Git TUI (util.gitui)

        # Additional useful tools
        curl
        wget
        unzip
        gnutar
        gzip
        jq # JSON processor
        yq # YAML processor
      ] ++ pkgs.lib.optionals (sqlls != null)
      [ sqlls ]; # SQL (lang.sql) - if available
    plugins = with pkgs.vimPlugins; [];
  };

  xdg.configFile =
    let
      lazyVimConfig = pkgs.linkFarm "lazyvim-config" [
        { name = "nvim"; path = inputs.lazy-nvim; }
        { name = "nvim/lua/plugins"; path = ./config; }
      ];
    in
    {
      "nvim" = {
        source = lazyVimConfig;
        recursive = true;
      };
    };


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";
  home.file.".config/tmux/tmux.conf.local".source = ./config/tmux.conf.local;
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
