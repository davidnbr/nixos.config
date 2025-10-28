{
  description = "Home Manager for Ubuntu - dbecerra";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    devenv.url = "github:cachix/devenv";
    oh-my-tmux = {
      url = "github:gpakosz/.tmux";
      flake = false;
    };
    iecs.url = "github:sestrella/iecs";
    claude-desktop = {
      #url = "github:k3d3/claude-desktop-linux-flake";
      #url = "github:davidnbr/claude-desktop-linux-flake/bc43951f8409dd6e461a037b82ca4765b9f1f40d"; ## Workaround graphics with uv fix
      #url = "github:davidnbr/claude-desktop-linux-flake/dc16836f2770e3dc6ae6387dec5fd4722f9bcf94"; # # Fixed graphics
      url = "github:davidnbr/claude-desktop-linux-flake/e11a21013f35dd44a1b88e82b41b4e39abbc00d4"; # # Fixed python3 tkinter
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    #terramaid.url = "github:RoseSecurity/Terramaid";
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
      nixpkgs-stable,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;

        terraform-local = pkgs.callPackage ./pkgs/terraform-local.nix { };

        overlays = [
          (final: prev: {
            unstable = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            stable = import nixpkgs-stable {
              inherit system;
              config.allowUnfree = true;
            };
            asdf2nix-wrapper = prev.writeShellScriptBin "asdf2nix" ''
              exec ${final.nix}/bin/nix run github:brokenpip3/asdf2nix -- "$@"
            '';
          })
        ];
      };
    in
    {
      homeConfigurations.dbecerra = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [ ./home/dbecerra.nix ];
      };
    };
}
