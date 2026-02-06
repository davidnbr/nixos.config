{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    # NixOS stable release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # NixOS unstable (optional, for newer packages)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware optimizations (optional but recommended)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-utils.url = "github:numtide/flake-utils";

    devenv = {
      url = "github:cachix/devenv";
    };

    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    lazy-nvim = {
      url = "github:LazyVim/starter";
      flake = false;
    };

    iecs.url = "github:sestrella/iecs";

    claude-desktop = {
      #url = "github:k3d3/claude-desktop-linux-flake";
      #url = "github:davidnbr/claude-desktop-linux-flake/9a573471258aca69020ebad798cbe3ed736bd3a5"; ## Fixed graphics
      #url = "github:davidnbr/claude-desktop-linux-flake/e11a21013f35dd44a1b88e82b41b4e39abbc00d4"; # # Fixed python3 tkinter
      #url = "github:davidnbr/claude-desktop-linux-flake/adc722925469241652f44fd21e23efe0705f0dc5"; # Aded wayland flags
      url = "github:davidnbr/claude-desktop-linux-flake";

      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    antigravity = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      hostname = "nixos-dbecerra";
      username = "dbecerra";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      # NixOS system configurations
      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            pkgs-unstable = pkgs-unstable;
          };
          modules = [
            # Your system configuration
            ./hosts/${hostname}/configuration.nix
            ./hosts/${hostname}/hardware-configuration.nix

            # Hardware optimizations (optional)
            # Uncomment and adjust for your hardware:
            # nixos-hardware.nixosModules.common-cpu-intel
            # nixos-hardware.nixosModules.common-pc-ssd

            # Global configuration
            {
              networking.hostName = hostname;
              nix.settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
              nixpkgs.config.allowUnfree = true;

              environment.systemPackages = with pkgs; [
                git
                vim
                wget
                curl
              ];
            }
          ];
        };
      };

      # Home Manager configurations
      homeConfigurations = {
        ${username} = home-manager.lib.homeManagerConfiguration {
          pkgs = pkgs;
          extraSpecialArgs = {
            inherit inputs;
            pkgs-unstable = pkgs-unstable;
          };
          modules = [
            ./home/${username}.nix
            {
              home.username = username;
              home.homeDirectory = "/home/${username}";
              home.stateVersion = "25.05"; # Match your NixOS version
              programs.home-manager.enable = true;
            }
          ];
        };
      };

      # Development shell (optional, useful for development)
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          git
          nixpkgs-fmt
          nil # Nix language server
        ];
        shellHook = ''
          echo "NixOS Development Environment"
          echo "Available commands:"
          echo "  sudo nixos-rebuild switch --flake .#${hostname}"
          echo "  home-manager switch --flake .#${username}"
          echo "  nix flake update"
        '';
      };
      ## Commands for updates outside of the directory
      #sudo nixhome-manager switch --flake ~/nixos-config#$(whoami)
      #home-manager switch --flake ~/nixos-config#$(whoami)
    };
}
