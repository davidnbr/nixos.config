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
    awscli2
    gh
    terraform
    ansible
    google-chrome
    firefox
    wpsoffice

    python311
    python311Packages.pip
    go
    nodejs_20
    
    ripgrep
    htop
    fzf
    bat
    jq
    blesh
    tree
    xclip
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
    enableCompletion = false;  # We'll handle this manually due to tmux check
    
    historySize = 100000;
    historyFileSize = 100000;
    historyControl = [ "ignoreboth" ];
    
    shellOptions = [
      "histappend"
      "cmdhist"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    
    shellAliases = {
      # From original .bashrc
      ll = "ls -alF";
      la = "ls -A"; 
      l = "ls -CF";
      lh = "ls -lah";
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      alert = "notify-send --urgency=low -i \"$([ $? = 0 ] && echo terminal || echo error)\" \"$(history|tail -n1|sed -e 's/^\\s*[0-9]\\+\\s*//;s/[;&|]\\s*alert$//')\"";
      
      # From home-manager additions
      cat = "bat";
      eza = "eza --icons auto --git --group-directories-first --header";
      lla = "eza -la";
      lt = "eza --tree";
      top = "htop";
      z = "zoxide";
      zi = "zoxide query -i";
      
      # Git aliases
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit";
      gl = "git log --oneline";
      gp = "git push";
      gs = "git status";
      
      # Tools
      lzd = "lazydocker";
      awsx = "aws-vault exec";
      tf = "terraform";
      vim = "nvim";
      cursor = "~/apps/cursor-0.48.9.AppImage --no-sandbox &";
      
      # Project aliases
      cdGRC = "cd ~/Documents/Stackbuilders/Projects/GRC/";
      cdSW = "cd ~/Documents/Stackbuilders/Projects/Spireworks/";
      cdDurst = "cd ~/Documents/Stackbuilders/Projects/Durst/";
      cdDevops = "cd ~/Documents/DevOps/";
      cdNix = "cd ~/Documents/Nix/";
    };
    
    sessionVariables = {
      EDITOR = "nvim";
    };
    
    initExtra = ''
      # Load any additional configurations  
      if [ -f ~/.bashrc.local ]; then
        source ~/.bashrc.local
      fi
      if [[ -f ${pkgs.blesh}/share/blesh/ble.sh ]]; then
        source ${pkgs.blesh}/share/blesh/ble.sh --noattach
      fi
    '';
    
    bashrcExtra = ''
      # Ble.sh early initialization - MUST be first for interactive shells
      [[ $- == *i* ]] && [[ -f ${pkgs.blesh}/share/blesh/ble.sh ]] && source ${pkgs.blesh}/share/blesh/ble.sh --attach=none
      
      # If not running interactively, don't do anything
      case $- in
        *i*) ;;
        *) return ;;
      esac
      
      # History settings
      HISTCONTROL=ignoreboth
      set -H # tmux
      
      # Less pipe support
      [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
      
      # Debian chroot support
      if [ -z "''${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
      fi
      
      # Colored prompt setup
      case "$TERM" in
        xterm-color|*-256color) color_prompt=yes ;;
      esac
      
      unset color_prompt force_color_prompt
      
      # Terminal title
      case "$TERM" in
        xterm*|rxvt*)
          PS1="\[\e]0;$${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
          ;;
        *) ;;
      esac
      
      # Enable color support
      if [ -x /usr/bin/dircolors ]; then
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
      fi
      
      # Load bash aliases
      if [ -f ~/.bash_aliases ]; then
        . ~/.bash_aliases
      fi
      
      # Bash completion - only if outside tmux
      if [[ -z "$TMUX" ]]; then
        if ! shopt -oq posix; then
          if [ -f /usr/share/bash-completion/bash_completion ]; then
            . /usr/share/bash-completion/bash_completion
          elif [ -f /etc/bash_completion ]; then
            . /etc/bash_completion
          fi
        fi
      fi
      
      # Terraform completion
      complete -C /usr/bin/terraform terraform 2>/dev/null
      
      # PATH additions
      export PATH="/home/$USER/.local/bin:$PATH"
      export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
      export PATH="$PATH:~/.nix-profile/bin"
      
      # Git branch function
      parse_git_branch() {
        git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
      }
      
      # aws-vault profile selection
      awsxp() {
        aws-vault exec $(aws-vault list | awk 'NR > 2 && $3!= "-" && $1!= "-" {print $1}')
      }
      
      # Load custom aliases
      if [ -f ~/.config/.aliases/aliases.sh ]; then
        . ~/.config/.aliases/aliases.sh
      fi
      
      # Window title function
      function set_win_title() {
        echo -ne "\033]0;$USER @ $HOSTNAME \007"
      }
      starship_precmd_user_func="set_win_title"
      
      # Superfile function
      spf() {
        os=$(uname -s)
        if [[ "$os" == "Linux" ]]; then
          export SPF_LAST_DIR="''${XDG_STATE_HOME:-$HOME/.local/state}/superfile/lastdir"
        fi
        if [[ "$os" == "Darwin" ]]; then
          export SPF_LAST_DIR="$HOME/Library/Application Support/superfile/lastdir"
        fi
        command spf "$@"
        [ ! -f "$SPF_LAST_DIR" ] || {
          . "$SPF_LAST_DIR"
          rm -f -- "$SPF_LAST_DIR" >/dev/null
        }
      }
      
      # Load z.sh
      if [ -f ~/.local/bin/z/z/z.sh ]; then
        . ~/.local/bin/z/z/z.sh
      fi
      
      # Ble.sh final attachment - MUST be last
      [[ ! ''${BLE_VERSION-} ]] || ble-attach
      
      # Starship init                      
      eval "$(starship init bash)"         
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

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    extraConfig = ''
      source-file ${inputs.oh-my-tmux}/.tmux.conf
      ${builtins.readFile ./tmux.conf.local}
    '';
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
  xdg.configFile."starship.toml".source = ./starship.toml;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
