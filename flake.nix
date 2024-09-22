{
  description = "Nix configuration of John Hampton";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Package sets
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixpkgs-22.05-darwin";
    nixos-stable.url = "github:NixOS/nixpkgs/nixos-22.05";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Environment/system management
    # TODO: Temporary work around until https://github.com/LnL7/nix-darwin/pull/1083 is merged
    # or resolved
    # darwin.url = "github:LnL7/nix-darwin";
    darwin.url = "github:emilazy/nix-darwin/push-zovpmlzlzvvm";
    darwin.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # agenix
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs-unstable";
    agenix.inputs.darwin.follows = "darwin";

    # nix-index
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs-unstable";

    flake-compat = { url = "github:edolstra/flake-compat"; flake = false; };
    flake-utils.url = "github:numtide/flake-utils";

    focus-nvim = { url = "github:nvim-focus/focus.nvim"; flake = false; };
    plugin-foreign-env = { url = "github:oh-my-fish/plugin-foreign-env"; flake = false; };
    pragmata-pro = { url = "github:johnhampton/pragmata-pro"; };
    telescope-hoogle-nvim = { url = "github:johnhampton/telescope-hoogle.nvim"; flake = false; };
    t-smart-tmux-session-manager = { url = "github:joshmedeski/t-smart-tmux-session-manager"; flake = false; };

    # TAN utilities
    hchart.url = "github:topagentnetwork/hchart";
  };

  outputs =
    { agenix
    , darwin
    , home-manager
    , flake-utils
    , ...
    }@inputs:
    let
      inherit (darwin.lib) darwinSystem;

      nixpkgsConfig = rec {
        config = { allowUnfree = true; };
        overlays = [
          # We need to use the gcloud package from master until the following
          # PR gets merged into unstable
          # https://github.com/NixOS/nixpkgs/pull/219376
          (final: prev: rec {
            pkgs-master = import inputs.nixpkgs-master {
              inherit (prev.stdenv) system;
              inherit config;
            };

            inherit (pkgs-master) google-cloud-sdk;
          })
          inputs.pragmata-pro.overlays.default
          (import ./overlays/chartmuseum.nix { inherit inputs; })
          (import ./overlays/helm-mapkubeapis.nix { inherit inputs; })
          (import ./overlays/fishPlugins.nix { inherit inputs; })
          (import ./overlays/lsp-zero.nix { inherit inputs; })
          (import ./overlays/rainfrog.nix { inherit inputs; })
          (import ./overlays/tmuxPlugins.nix { inherit inputs; })
          (import ./overlays/vimPlugins.nix { inherit inputs; })
        ];
      };

      homeManagerStateVersion = "22.05";
      homeManagerCommonConfig = {
        imports = [
          inputs.nixvim.homeManagerModules.nixvim
          ./home
          { home.stateVersion = homeManagerStateVersion; }
          (args: {
            xdg.configFile."nix/inputs/nixpkgs".source = inputs.nixpkgs-unstable.outPath;
            home.sessionVariables.NIX_PATH = "nixpkgs=${args.config.xdg.configHome}/nix/inputs/nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
            nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
          })
        ];
      };

      nixDarwinCommonModules = [
        {
          environment.etc."nix/inputs/nixpkgs".source = inputs.nixpkgs-unstable.outPath;
          nix.nixPath = [ "nixpkgs=/etc/nix/inputs/nixpkgs" ];
          nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
        }
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
              inherit (config) age;
              inherit inputs;
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
          # system = "aarch64-darwin";
          modules = [ ({ ... }: { nixpkgs.hostPlatform = "aarch64-darwin"; }) ] ++ nixDarwinCommonModules;
          inputs = { inherit home-manager; };
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs =
        import inputs.nixpkgs-unstable { inherit (nixpkgsConfig) config overlays; inherit system; };
    in
    {
      legacyPackages = pkgs;

      devShell = pkgs.mkShell {
        packages = [ agenix.packages.${system}.default ];
      };
    });
}
