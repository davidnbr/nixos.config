{
  config,
  pkgs,
  pkgs-unstable,
  inputs,
  lib,
  ...
}:
{
  home.username = "dbecerra";
  home.homeDirectory = "/home/dbecerra";
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

    # DevOps Tools
    pkgs-unstable.awscli2
    pkgs-unstable.ssm-session-manager-plugin
    pkgs-unstable.gh
    pkgs-unstable.act
    pkgs-unstable.terraform
    pkgs-unstable.terraform-local
    terragrunt
    ansible
    ansible-lint
    pkgs-unstable.nginx
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs

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
    pkgs-unstable.git
    pkgs-unstable.gcc
    pkgs-unstable.unzip
    pkgs-unstable.wget
    pkgs-unstable.curl
    pkgs-unstable.fd
    pkgs-unstable.graphviz
    pkgs-unstable.ffmpeg
    pkgs-unstable.imagemagick

    shfmt
    tflint
    tfsec
    shellcheck
    pkgs-unstable.nixfmt-rfc-style
    statix # Nix linter
    sqlfluff
    pkgs-unstable.hadolint

    pkgs-unstable.awscli2
    pkgs-unstable.aws-vault
    #pkgs-unstable.azure-cli
    #pkgs-unstable.azure-cli-extensions.containerapp
    #pkgs-unstable.azure-cli-extensions.ad
    #pkgs-unstable.azure-cli-extensions.vme
    #pkgs-unstable.azure-cli-extensions.fzf
    #pkgs-unstable.azure-cli-extensions.alb
    #pkgs-unstable.azure-cli-extensions.portal
    #pkgs-unstable.azure-cli-extensions.terraform
    #pkgs-unstable.azure-cli-extensions.azure-devops
    #pkgs-unstable.azure-cli-extensions.rdbms-connect
    #pkgs-unstable.azure-cli-extensions.log-analytics
    #pkgs-unstable.azure-cli-extensions.network-analytics
    pkgs-unstable.tmux
    pkgs-unstable.starship
    pkgs-unstable.neovim
    pkgs-unstable.pre-commit
    pkgs-unstable.tldr
    nix-prefetch-github
    inputs.devenv.packages.${pkgs.system}.devenv
    inputs.iecs.packages.${system}.default
    pkgs-unstable.claude-code
    asdf2nix-wrapper

    # Build tools for Mason LSPs
    cargo
    rustc

    # Language servers (LazyVim will find them)
    pkgs-unstable.nil # Nix LSP
    #pkgs-unstable.lua-language-server # Lua LSP
    #pkgs-unstable.nodePackages.typescript-language-server # JS/TS LSP
    #pkgs-unstable.gopls              # Go LSP
    #pkgs-unstable.pyright            # Python LSP
    #pkgs-unstable.terraform-ls       # Terraform LSP
    #pkgs-unstable.yaml-language-server # YAML LSP
    #pkgs-unstable.erlang-ls # Erlang LSP
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
    Exec=${inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs}/bin/claude-desktop %F
    Icon=claude-desktop
    StartupNotify=true
    Categories=Office;Development;
    StartupWMClass=Claude Desktop
  '';

  # Tmux with oh-my-tmux
  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";

  # Neovim configuration
  home.file.".config/nvim/lua/plugins".source = ./config/nvim/plugins;
  home.file.".config/nvim/lua/config".source = ./config/nvim/config;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
