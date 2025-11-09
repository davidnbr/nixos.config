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
    stable.ansible
    stable.ansible-lint
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

    stable.shfmt
    stable.tflint
    stable.tfsec
    stable.shellcheck
    stable.nixfmt
    hadolint

    awscli2
    aws-vault
    #unstable.azure-cli
    #unstable.azure-cli-extensions.containerapp
    #unstable.azure-cli-extensions.ad
    #unstable.azure-cli-extensions.vme
    #unstable.azure-cli-extensions.fzf
    #unstable.azure-cli-extensions.alb
    #unstable.azure-cli-extensions.portal
    #unstable.azure-cli-extensions.terraform
    #unstable.azure-cli-extensions.azure-devops
    #unstable.azure-cli-extensions.rdbms-connect
    #unstable.azure-cli-extensions.log-analytics
    #unstable.azure-cli-extensions.network-analytics
    tmux
    starship
    neovim
    pre-commit
    tldr
    stable.nix-prefetch-github
    inputs.devenv.packages.${pkgs.system}.devenv
    inputs.iecs.packages.${system}.default
    claude-code
    asdf2nix-wrapper

    # Build tools for Mason LSPs
    stable.cargo
    stable.rustc

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

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
