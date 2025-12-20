{ config, pkgs, pkgs-unstable, inputs, lib, ... }:
let
  sqlls = pkgs.nodePackages.sql-language-server or null;
  asdf2nix-wrapper = pkgs.writeShellScriptBin "asdf2nix" ''
    #!/usr/bin/env bash
    exec ${
      inputs.nixpkgs.legacyPackages.${pkgs.system}.nix
    }/bin/nix run github:brokenpip3/asdf2nix -- "$@"
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
    nerd-fonts.hack

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
    tree-sitter
    ripgrep
    wget
    curl
    unzip
    fd
    graphviz

    shfmt
    tflint
    tfsec
    checkov
    shellcheck
    nixfmt-classic
    statix # Nix linter/formatter

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
    pkgs-unstable.neovim

    # Build tools for LSPs
    cargo
    rustc

    # LSP servers (NixOS packages for better compatibility)
    pkgs-unstable.lua-language-server
    pkgs-unstable.nil # Nix LSP
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

  home.file = { };

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";

  };

  home.file.".bashrc".source = ./config/bashrc;
  home.file.".config/.aliases/aliases.sh".source = ./config/aliases.sh;

  # LazyVim configuration
  # Copy LazyVim starter as the base config
  home.file.".config/nvim" = {
    source = inputs.lazy-nvim;
    recursive = true;
  };

  # Custom Neovim configurations
  # Config files
  home.file.".config/nvim/lua/config/autocmds.lua".source =
    ./config/nvim/config/autocmds.lua;
  home.file.".config/nvim/lua/config/keymaps.lua".source =
    ./config/nvim/config/keymaps.lua;
  home.file.".config/nvim/lua/config/lazy.lua".source =
    ./config/nvim/config/lazy.lua;
  home.file.".config/nvim/lua/config/options.lua".source =
    ./config/nvim/config/options.lua;

  # Plugin configurations
  home.file.".config/nvim/lua/plugins/bufferline.lua".source =
    ./config/nvim/plugins/bufferline.lua;
  home.file.".config/nvim/lua/plugins/claudecode.lua".source =
    ./config/nvim/plugins/claudecode.lua;
  home.file.".config/nvim/lua/plugins/colorscheme.lua".source =
    ./config/nvim/plugins/colorscheme.lua;
  home.file.".config/nvim/lua/plugins/fix-vscode-paths.lua".source =
    ./config/nvim/plugins/fix-vscode-paths.lua;
  home.file.".config/nvim/lua/plugins/ghaction.lua".source =
    ./config/nvim/plugins/ghaction.lua;
  home.file.".config/nvim/lua/plugins/neo-tree.lua".source =
    ./config/nvim/plugins/neo-tree.lua;
  home.file.".config/nvim/lua/plugins/python.lua".source =
    ./config/nvim/plugins/python.lua;
  home.file.".config/nvim/lua/plugins/lsp-nixos.lua".source =
    ./config/nvim/plugins/lsp-nixos.lua;
  home.file.".config/nvim/lua/plugins/treesitter.lua".source =
    ./config/nvim/plugins/treesitter.lua;
  home.file.".config/nvim/lua/plugins/ui-enhancements.lua".source =
    ./config/nvim/plugins/ui-enhancements.lua;
  home.file.".config/nvim/lua/plugins/vue-fix.lua".source =
    ./config/nvim/plugins/vue-fix.lua;
  home.file.".config/nvim/lua/plugins/window-focus.lua".source =
    ./config/nvim/plugins/window-focus.lua;

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
