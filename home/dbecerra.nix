{ config, pkgs, ... }:

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
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    vscode
    awscli2
    gh
    terraform
    ansible
    google-chrome
    firefox
    microsoft-edge

    python311
    python311Packages.pip
    go
    nodejs_20
    
    ripgrep
    htop
    fzf
    bat
    jq
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
    # EDITOR = "emacs";
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    
    shellAliases = {
      ll = "ls -l";
      la = "ls -la";
      ls = "ls";
      lh = "ls -alh";
      cat = "bat";
      top = "htop";
      
      # Git aliases
      gs = "git status";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline";
    };
    
    bashrcExtra = ''
      # Custom prompt
      export PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
      
      # History settings
      export HISTCONTROL=ignoredups:erasedups
      export HISTSIZE=10000
      export HISTFILESIZE=20000
      shopt -s histappend
      
      # Better directory navigation
      shopt -s autocd
      shopt -s cdspell
      shopt -s dirspell
      
      # FZF key bindings and completion
      if command -v fzf >/dev/null 2>&1; then
        source ${pkgs.fzf}/share/fzf/key-bindings.bash
        source ${pkgs.fzf}/share/fzf/completion.bash
      fi
      
      # Set editor
      export EDITOR=nvim
      export VISUAL=nvim
    '';
    
    # Bash initialization that runs for interactive shells
    initExtra = ''
      # Load any additional configurations
      if [ -f ~/.bashrc.local ]; then
        source ~/.bashrc.local
      fi
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
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
