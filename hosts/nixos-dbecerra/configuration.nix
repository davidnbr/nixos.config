# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 2;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable flakes and modern nix commands
  nix.settings = {
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
    trusted-users = [ "root" "dbecerra" "@wheel" ];
    experimental-features = [ "nix-command" "flakes" ];
    download-buffer-size = 524288000;
  };

  networking.hostName = "nixos-dbecerra"; # Define your hostname.
  networking.networkmanager.enable =
    true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ m17n uniemoji ];
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  security.sudo.enable = true;
  security.sudo.wheelNeedsPassword = true;

  # Enable the X11 windowing system.
  # Enable GNOME Ubuntu
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    videoDrivers = [ "nvidia" "intel" ];
    xkb = {
      layout = "us";
      variant = "altgr-intl"; # US international with dead keys
    };
  };

  console = {
    useXkbConfig = true;
    packages = with pkgs; [ terminus_font ];
  };

  # Enable hardware acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # NVIDIA driver with Sync mode
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.xpadneo.enable = true;

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    cheese
    gnome-music
    epiphany
    geary
    gedit
    tali
    iagno
    hitori
    atomix
  ]);

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable sound.
  # sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dbecerra = {
    isNormalUser = true;
    extraGroups =
      [ "wheel" "networkmanager" "docker" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bash;
  };
  nixpkgs.config.allowUnfree = true;

  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    autokey # For Alt+numpad automation
    espanso # Alternative text expander
    xdotool # X11 automation tool

    desktop-file-utils
    pciutils
    vim
    wget
    htop
    btop
    killall
    curl
    gedit
    gcc
    unzip
    gparted
    timeshift
    dconf-editor
    gnome-software
    gnome-tweaks
    gnome-terminal
    gnome-browser-connector

    # Ubuntu-like extensions
    gnomeExtensions.dash-to-dock # Dock sidebar
    gnomeExtensions.appindicator # System tray
    gnomeExtensions.user-themes # Themes

    # Additional useful extensions
    #gnomeExtensions.pop-shell           # Tiling (optional)
    gnomeExtensions.caffeine # Prevent sleep
    gnomeExtensions.vitals # System monitor

    # Emulator
    dolphin-emu
    usbutils
    evtest
    linuxConsoleTools
  ];

  programs.dconf = {
    enable = true;
    profiles = {
      user.databases = [{
        lockAll = true;
        settings = {
          # Window controls (minimize, maximize, close)
          "org/gnome/desktop/wm/preferences" = {
            button-layout = "appmenu:minimize,maximize,close";
          };

          "org/gnome/desktop/wm/keybindings" = {
            #maximize = ["<Super>Up"];
            unmaximize = [ "<Super>Down" ];
            toggle-maximized = [ "<Super>Up" ];
            move-to-side-w = "disabled";
            move-to-side-e = "disabled";
            move-to-workspace-left = [ "<Super><Shift>Left" ];
            move-to-workspace-right = [ "<Super><Shift>Right" ];
          };

          "org/gnome/mutter" = {
            edge-tiling = true;
            overlay-key = "Super_L";
          };

          "org/gnome/mutter/keybindings" = {
            toggle-tiled-left = [ "<Super>Left" ];
            toggle-tiled-right = [ "<Super>Right" ];
          };

          # Enable GNOME Shell extensions
          "org/gnome/shell" = {
            enabled-extensions = [
              "dash-to-dock@micxgx.gmail.com"
              "appindicatorsupport@rgcjonas.gmail.com"
              "user-theme@gnome-shell-extensions.gcampax.github.com"
              "Vitals@CoreCoding.com"
              "caffeine@patapon.info"
            ];
          };

          # Dash to Dock configuration
          "org/gnome/shell/extensions/dash-to-dock" = {
            dock-position = "LEFT";
            extend-height = true;
            dock-fixed = true;
            #show-apps-at-top = true;
            show-running = true;
            show-favorites = true;
            isolate-workspaces = false;
            #transparency-mode = "FIXED";
            dash-max-icon-size = lib.gvariant.mkInt32 48;
            #unity-backlit-items = true;
            #running-indicator-style = "DOTS";
            #apply-custom-theme = false;
            autohide = false;
            #intellihide = false;
            #require-pressure-to-show = false;
          };

          #"org/gnome/shell/extensions/pop-shell" = {
          #  tile-by-default = false;
          #  show-title = true;
          #  active-hint = true;
          #};

          # AppIndicator settings
          "org/gnome/shell/extensions/appindicator" = {
            icon-size = lib.gvariant.mkInt32 22;
            icon-spacing = lib.gvariant.mkInt32 12;
            tray-pos = "right";
          };

          # Vitals extension settings
          "org/gnome/shell/extensions/vitals" = {
            hot-sensors =
              [ "_processor_usage_" "_memory_usage_" "_storage_free_" ];
            show-storage = true;
            show-network = true;
            show-processor = true;
            show-memory = true;
          };

          # Additional GNOME settings for Ubuntu-like experience
          "org/gnome/desktop/interface" = {
            show-battery-percentage = true;
            clock-show-weekday = true;
            enable-hot-corners = false;
          };

          "org/gnome/shell/overrides" = { dynamic-workspaces = true; };

          "org/gnome/desktop/session" = {
            idle-delay = lib.gvariant.mkUint32 300;
          };
        };
      }];
    };
  };

  #environment.etc."dconf/db/local.d/02-keybindings".text = ''
  #  [org/gnome/desktop/wm/keybindings]
  #  move-to-side-w=@as []
  #  move-to-side-e=@as []
  #  maximize=['<Super>Up']
  #  unmaximize=['<Super>Down']
  #  toggle-maximized=['<Super>Up']
  #  move-to-workspace-left = ["<Super><Shift>Left"];
  #  move-to-workspace-right = ["<Super><Shift>Right"];
  #
  #  [org/gnome/mutter/keybindings]
  #  toggle-tiled-left=['<Super>Left']
  #  toggle-tiled-right=['<Super>Right']
  #'';
  #
  programs.git = {
    enable = true;
    config = { push = { autoSetupRemote = true; }; };
  };

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    stdenv.cc.cc
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  fonts.packages = with pkgs; [
    ubuntu_font_family
    liberation_ttf
    dejavu_fonts
    noto-fonts
    noto-fonts-emoji
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  services.printing.enable = true;
  services.libinput.enable = true;
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";     # Copy the NixOS configuration file and link it from the resulting system
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  #system.copySystemConfiguration = true;

  virtualisation.docker.enable = true;

  system.autoUpgrade = {
    enable = true;
    allowReboot = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.extraOptions = ''
    extra-substituters = https://devenv.cachix.org
    extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
  '';
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
