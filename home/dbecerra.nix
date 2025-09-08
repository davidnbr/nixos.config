{ config, pkgs, inputs, lib, ... }:

{
  home.username = "dbecerra";
  home.homeDirectory = "/home/dbecerra";
  home.stateVersion = "25.05";
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Fonts
    nerd-fonts.hack
    
    # GUI Applications
    unstable.vscode
    
    # Languages and Runtimes
    (unstable.python311.withPackages(ps: with ps; [ pip httpx ]))
    unstable.uv
    unstable.go
    unstable.nodejs_20
    unstable.ruby_3_4
    unstable.elixir_1_18
    
    # DevOps Tools
    unstable.awscli2
    unstable.gh
    unstable.terraform
    unstable.terragrunt
    ansible
    ansible-lint
    unstable.aws-vault
    
    # Development Tools
    lazydocker
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

    unstable.tmux
    unstable.starship
    unstable.neovim
    unstable.pre-commit
    unstable.tldr
    nix-prefetch-github
    inputs.devenv.packages.${pkgs.system}.devenv
    unstable.claude-code
    asdf2nix-wrapper
    
    # Language servers (LazyVim will find them)
    nil                # Nix LSP
    lua-language-server # Lua LSP
    nodePackages.typescript-language-server # JS/TS LSP
    gopls              # Go LSP  
    pyright            # Python LSP
    terraform-ls       # Terraform LSP
    yaml-language-server # YAML LSP
  ];

  # Font configuration
  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      monospace = [ "Hack Nerd Font" "DejaVu Sans Mono" ];
      sansSerif = [ "DejaVu Sans" "Liberation Sans" ];
      serif = [ "DejaVu Serif" "Liberation Serif" ];
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

  # Tmux with oh-my-tmux
  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";
  
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.home-manager.enable = true;
}
