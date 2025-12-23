{
  config,
  pkgs,
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
    coreutils
    findutils
    gnused
    gnugrep
    gnutar

    # Fonts
    nerd-fonts.hack

    # GUI Applications
    vscode

    # Languages and Runtimes
    (python313.withPackages (
      ps: with ps; [
        pip
        pip-audit
        safety
        wheel
        httpx
        mcp
      ]
    ))
    uv
    go
    nodejs_22
    nodePackages.pnpm
    volta
    yarn
    ruby_3_4
    elixir_1_18

    # DevOps Tools
    awscli2
    ssm-session-manager-plugin
    gh
    act
    terraform
    terraform-local
    terragrunt
    ansible
    ansible-lint
    nginx
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs

    # Development Tools
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
    tree
    xclip
    git
    gcc
    unzip
    wget
    curl
    fd
    graphviz
    ffmpeg
    imagemagick

    shfmt
    tflint
    tfsec
    shellcheck
    nixfmt-rfc-style
    statix # Nix linter
    sqlfluff
    hadolint

    awscli2
    aws-vault
    #unazure-cli
    #unazure-cli-extensions.containerapp
    #unazure-cli-extensions.ad
    #unazure-cli-extensions.vme
    #unazure-cli-extensions.fzf
    #unazure-cli-extensions.alb
    #unazure-cli-extensions.portal
    #unazure-cli-extensions.terraform
    #unazure-cli-extensions.azure-devops
    #unazure-cli-extensions.rdbms-connect
    #unazure-cli-extensions.log-analytics
    #unazure-cli-extensions.network-analytics
    tmux
    starship
    neovim
    pre-commit
    tldr
    nix-prefetch-github
    inputs.devenv.packages.${pkgs.system}.devenv
    inputs.iecs.packages.${system}.default
    claude-code
    asdf2nix-wrapper

    # Build tools for Mason LSPs
    cargo
    rustc

    # Language servers (LazyVim will find them)
    nil # Nix LSP
    #lua-language-server # Lua LSP
    #nodePackages.typescript-language-server # JS/TS LSP
    #gopls              # Go LSP
    #pyright            # Python LSP
    #terraform-ls       # Terraform LSP
    #yaml-language-server # YAML LSP
    #erlang-ls # Erlang LSP
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
