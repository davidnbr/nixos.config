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
      inputs.nixpkgs.follows = "nixpkgs";
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
      url =
        "github:davidnbr/claude-desktop-linux-flake/adac0a33a60210d0e573516f1de0cbd053858fb9";
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

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ...
    }@inputs:
    let
      system = "x86_64-linux";
      hostname = "nixos-dbecerra";
      username = "dbecerra";

      # Create pkgs with overlays for unstable packages
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          # Add unstable packages overlay
          (final: prev: {
            unstable = import nixpkgs-unstable {
              inherit system;
              config.allowUnfree = true;
            };
          })
          # Add wrapper for asdf2nix
          (final: prev: {
            asdf2nix-wrapper = prev.writeShellScriptBin "asdf2nix" ''
              #!/usr/bin/env bash
              exec ${
                inputs.nixpkgs.legacyPackages.${system}.nix
              }/bin/nix run github:brokenpip3/asdf2nix -- "$@"
            '';
          })
        ];
      };
    in {
      # NixOS system configurations
      nixosConfigurations = {
        ${hostname} = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit nixpkgs-unstable;
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
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
              nixpkgs.config.allowUnfree = true;
              # Make the overlay available system-wide
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                  };
                })
              ];

              environment.systemPackages = with pkgs; [ git vim wget curl ];
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
            inherit nixpkgs-unstable;
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
