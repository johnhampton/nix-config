{
  description = "Nix configuration of John Hampton";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Package sets
    nixpkgs-unstable.url = github:NixOS/nixpkgs/nixpkgs-unstable;
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = github:NixOS/nixpkgs/nixpkgs-22.05-darwin;
    nixos-stable.url = github:NixOS/nixpkgs/nixos-22.05;

    # Environment/system management
    darwin.url = github:LnL7/nix-darwin;
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    agenix.inputs.darwin.follows = "darwin";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    one-nord = { url = "github:rmehri01/onenord.nvim"; flake = false; };
    plugin-foreign-env = { url = "github:oh-my-fish/plugin-foreign-env"; flake = false; };
  };

  outputs =
    { self
    , nixpkgs
    , agenix
    , darwin
    , home-manager
    , flake-utils
    , one-nord
    , plugin-foreign-env
    , ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (inputs.nixpkgs-unstable.lib) attrValues makeOverridable optionalAttrs singleton;

      nixpkgsConfig = rec {
        config = { allowUnfree = true; };
        overlays = [
          (final: prev: {
            pkgs-master = import inputs.nixpkgs-master {
              inherit (prev.stdenv) system;
              inherit config;
            };
          })

          # We need to use the gcloud package from master until the following
          # PR gets merged into unstable
          # https://github.com/NixOS/nixpkgs/pull/219376
          (final: prev: {
            inherit (prev.pkgs-master) google-cloud-sdk;
          })
        ];
      };

      homeManagerStateVersion = "22.05";
      homeManagerCommonConfig = {
        imports = [
          ./home
          { home.stateVersion = homeManagerStateVersion; }
        ];
      };

      nixDarwinCommonModules = [
        agenix.darwinModules.default
        ./darwin
        # ./darwin/darwin-builder.nix
        home-manager.darwinModules.home-manager
        (
          { config, lib, pkgs, ... }:
          let
            primaryUser = "john";
          in
          {
            nixpkgs = nixpkgsConfig;
            # Hack to support legacy worklows that use `<nixpkgs>` etc.
            # nix.nixPath = { nixpkgs = "$HOME/.config/nixpkgs/nixpkgs.nix"; };
            # `home-manager` config
            users.users.${primaryUser}.home = "/Users/${primaryUser}";
            home-manager.useGlobalPkgs = true;
            home-manager.users.${primaryUser} = homeManagerCommonConfig;
            home-manager.extraSpecialArgs = {
              inherit one-nord;
              inherit plugin-foreign-env;
            };
          }
        )
      ];
    in
    {
      darwinConfigurations = {
        Ava = darwinSystem {
          system = "x86_64-darwin";
          modules = nixDarwinCommonModules ++ [
            ./machines/ava.nix
          ];
          inputs = { inherit home-manager; };
        };

        "Johns-MacBook-Pro" = darwinSystem {
          system = "aarch64-darwin";
          modules = nixDarwinCommonModules;
          inputs = { inherit home-manager; };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system: {
      devShell = inputs.nixpkgs-unstable.legacyPackages.${system}.mkShell {
        packages = [ agenix.packages.${system}.default ];
      };

    });
}
