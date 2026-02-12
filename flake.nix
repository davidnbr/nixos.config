{
  description = "Home Manager for Ubuntu - dbecerra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    devenv.url = "github:cachix/devenv/latest";
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };
    iecs.url = "github:sestrella/iecs";
    claude-desktop = {
      #url = "github:k3d3/claude-desktop-linux-flake";
      url = "github:davidnbr/claude-desktop-linux-flake";
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
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      # Create stable pkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            asdf2nix-wrapper = prev.writeShellScriptBin "asdf2nix" ''
              exec ${final.nix}/bin/nix run github:brokenpip3/asdf2nix -- "$@"
            '';
            terraform-local = prev.callPackage ./pkgs/terraform-local.nix { };
          })
        ];
      };

      # Create unstable pkgs separately to avoid dependency conflicts
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      homeConfigurations.dbecerra = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit pkgs-unstable;
        };
        modules = [ ./home/dbecerra.nix ];
      };
    };
}
