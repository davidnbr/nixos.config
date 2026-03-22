{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:
{
  home.username = "davidnbr98";
  home.homeDirectory = "/home/davidnbr98";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    pkgs-unstable.coreutils
    pkgs-unstable.findutils
    pkgs-unstable.gnused
    pkgs-unstable.gnugrep
    pkgs-unstable.gnutar

    # Fonts
    pkgs-unstable.nerd-fonts.hack

    # GUI Applications
    pkgs-unstable.vscode

    # Languages and Runtimes
    (pkgs-unstable.python313.withPackages (
      ps: with ps; [
        pip
        pip-audit
        safety
        wheel
        httpx
        mcp
      ]
    ))
    pkgs-unstable.uv
    pkgs-unstable.go
    pkgs-unstable.nodejs_22
    pkgs-unstable.nodePackages.pnpm
    pkgs-unstable.volta
    pkgs-unstable.yarn
    pkgs-unstable.ruby_3_4
    pkgs-unstable.elixir_1_18
    pkgs-unstable.bun

    # DevOps Tools
    pkgs-unstable.awscli2
    pkgs-unstable.aws-vault
    pkgs-unstable.ssm-session-manager-plugin
    pkgs-unstable.gh
    pkgs-unstable.act
    pkgs-unstable.terraform
    pkgs-unstable.terraform-local
    terragrunt
    ansible
    ansible-lint
    pkgs-unstable.nginx
    inputs.claude-desktop.packages.${stdenv.hostPlatform.system}.claude-desktop-with-fhs

    # Development Tools
    pkgs-unstable.lazydocker
    pkgs-unstable.mqttui
    pkgs-unstable.tcpdump
    pkgs-unstable.trivy
    pkgs-unstable.smem
    pkgs-unstable.ripgrep
    pkgs-unstable.htop
    pkgs-unstable.fzf
    pkgs-unstable.bat
    pkgs-unstable.jq
    pkgs-unstable.tree
    pkgs-unstable.xclip
    pkgs-unstable.unzip
    pkgs-unstable.wget
    pkgs-unstable.curl
    pkgs-unstable.fd
    pkgs-unstable.graphviz
    pkgs-unstable.ffmpeg
    pkgs-unstable.imagemagick

    pkgs-unstable.shfmt
    pkgs-unstable.tflint
    pkgs-unstable.tfsec
    pkgs-unstable.checkov
    pkgs-unstable.shellcheck
    pkgs-unstable.nixfmt
    pkgs-unstable.statix # Nix linter
    pkgs-unstable.sqlfluff
    pkgs-unstable.hadolint

    pkgs-unstable.tmux
    pkgs-unstable.neovim
    pkgs-unstable.pre-commit
    pkgs-unstable.tldr
    nix-prefetch-github
    inputs.devenv.packages.${stdenv.hostPlatform.system}.devenv
    inputs.iecs.packages.${stdenv.hostPlatform.system}.default
    inputs.claude-code.packages.${stdenv.hostPlatform.system}.claude-code
    #pkgs-unstable.claude-code
    pkgs-unstable.gemini-cli
    asdf2nix-wrapper

    # Language servers (LazyVim will find them)
    pkgs-unstable.nil # Nix LSP
  ];

  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [
        "Hack Nerd Font"
        "DejaVu Sans Mono"
      ];
      sansSerif = [
        "DejaVu Sans"
        "Liberation Sans"
      ];
      serif = [
        "DejaVu Serif"
        "Liberation Serif"
      ];
    };
  };

  # Session variables
  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
  };

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

  programs.git = {
    enable = true;
    hooks = {
      pre-commit = pkgs.writeShellScript "pre-commit" ''
        #!/usr/bin/env bash
        set -ex

        ${pkgs.pre-commit}/bin/pre-commit run --config "pre-commit-config.yaml" "$@"
      '';
    };
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    settings = import ./starship.nix;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableBashIntegration = true;
  };

  # For terraform-local
  programs.bash.shellAliases = {
    localstack-start = "docker run -d -p 4566:4566 -p 4571:4571 --name localstack localstack/localstack";
    localstack-stop = "docker stop localstack && docker rm localstack";
    localstack-logs = "docker logs -f localstack";
  };

  home.file.".local/share/applications/claude-desktop.desktop".text = ''
    [Desktop Entry]
    Version=1.0
    Type=Application
    Name=Claude Desktop
    Comment=AI assistant by Anthropic
    Exec=${
      inputs.claude-desktop.packages.${pkgs.stdenv.hostPlatform.system}.claude-desktop-with-fhs
    }/bin/claude-desktop %F
    Icon=claude-desktop
    StartupNotify=true
    Categories=Office;Development;
    StartupWMClass=Claude Desktop
  '';

  home.file.".bashrc".source = ./config/.bashrc;
  home.file.".config/.aliases/aliases.sh".source = ./config/aliases.sh;

  # Tmux with oh-my-tmux
  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";
  home.file.".config/tmux/tmux.conf.local".source = ./config/tmux.conf.local;
  home.file.".config/tmux/plugins/catppuccin" = {
    source = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "tmux";
      rev = "v2.1.2";
      hash = "sha256-vBYBvZrMGLpMU059a+Z4SEekWdQD0GrDqBQyqfkEHPg=";
    };
    recursive = true;
  };

  # Neovim configuration
  home.file.".config/nvim/lua/plugins" = {
    source = ./config/nvim/plugins;
    recursive = true;
  };
  home.file.".config/nvim/lua/config" = {
    source = ./config/nvim/config;
    recursive = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
