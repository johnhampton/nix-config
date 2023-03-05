{ config, pkgs, plugin-foreign-env, ... }:

{

  imports = [
    ./kitty.nix
    ./neovim.nix
  ];
  home.packages = with pkgs; [

    argocd
    argocd-autopilot
    colima
    docker-client
    dos2unix
    just
    kind
    kubectl
    kubectx
    kustomize
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    nerdfonts
    terraform-ls
    watchman
    yadm
    (haskell-language-server.override { supportedGhcVersions = [ "944" "8107" ]; })
    haskell.compiler.ghc944
    # haskell.compiler.ghc8107
    haskellPackages.cabal-fmt


  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  programs.autojump.enable = true;

  programs.bat.enable = true;
  programs.bat = {
    config = {
      theme = "Nord";
    };
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.fish.enable = true;
  programs.fish = {
    plugins = [
      {
        name = "plugin-foreign-env";
        src = plugin-foreign-env;
      }
    ];

    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';
  };

  programs.git.enable = true;
  programs.git = {
    userName = "John Hampton";
    userEmail = "john.hampton@stanfordalumni.org";

    extraConfig = {
      credential = { helper = "osxkeychain"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "master"; };
      "mergetool \"nvim\"" = {
        cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
      };
      mergetool = { prompt = false; };
      merge = { tool = "nvim"; };
    };
  };

  programs.gh.enable = true;
  programs.gh = {
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        tc = "repo clone topagentnetwork/$1";
      };

    };
  };

  # https://starship.rs/config/
  programs.starship.enable = true;
  programs.starship.settings = {
    command_timeout = 1000;
  };
}