{
  description = "NixOS Configuration with Home Manager";

  inputs = {
    # NixOS stable release
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    
    # NixOS unstable (optional, for newer packages)
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Hardware optimizations (optional but recommended)
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };

    lazy-nvim = {
      url = "github:LazyVim/starter";
      flake = false;
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix":
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, git-hooks, ... }@inputs: 
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
            unstable = nixpkgs-unstable.legacyPackages.${system};
          })
        ];
      };
    in
    {
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
            git-hooks.homeManagerModules.git-hooks
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
