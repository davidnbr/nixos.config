{
  description = "Home Manager for Ubuntu - dbecerra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    devenv.url = "github:cachix/devenv";
    oh-my-tmux = { url = "github:gpakosz/.tmux"; flake = false; };
  };

  outputs = { nixpkgs, nixpkgs-stable, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            unstable = import nixpkgs { inherit system; config.allowUnfree = true; };
            stable = import nixpkgs-stable { inherit system; config.allowUnfree = true; };
            asdf2nix-wrapper = prev.writeShellScriptBin "asdf2nix" ''
              exec ${final.nix}/bin/nix run github:brokenpip3/asdf2nix -- "$@"
            '';
          })
        ];
      };
    in {
      homeConfigurations.dbecerra = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/dbecerra.nix ];
      };
    };
}
