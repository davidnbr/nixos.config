{ config, pkgs, inputs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "dbecerra";
  home.homeDirectory = "/home/dbecerra";

  home.stateVersion = "25.05";
  
  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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
    ansible
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
  ];

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
      
      # Additional useful tools
      curl
      wget
      unzip
      gnutar
      gzip
    ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  home.file.".config/tmux/tmux.conf".source = "${inputs.oh-my-tmux}/.tmux.conf";
  home.file.".config/tmux/tmux.conf.local".source = ./tmux.conf.local;
  home.shellAliases.tmux = "tmux -f ~/.config/tmux/tmux.conf";

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.pre-commit = {
    enable = true;
  };

  programs.git = {
    enable = true;
    hooks = {
      pre-commit = pkgs.writeShellScrip "pre-commit-custom" ''
        #!/usr/bin/env bash
        set -ex

        ${pkgs.pre-commit}/bin/pre-commit run --config "pre-commit-config.yaml" "$@"
      '';
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
