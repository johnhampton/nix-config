{ pkgs, config, plugin-foreign-env, access_token, ... }:

{
  imports = [
    ./alacritty.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./ssh.nix
  ];
  home.packages = with pkgs; [

    argocd
    argocd-autopilot
    colima
    comma
    docker-client
    dos2unix
    fzf
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    graphite-cli
    just
    kind
    kubectl
    kubectx
    kustomize
    nerdfonts
    nix-index
    ripgrep
    terraform-ls
    watchman
    yadm
  ];

  nix.extraOptions = ''
    !include ${access_token.path}
  '';

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

  programs.exa.enable = true;
  programs.exa = {
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.fish.enable = true;
  programs.fish = {
    plugins = [
      {
        name = "plugin-foreign-env";
        src = plugin-foreign-env;
      }
    ];

    shellAliases = { };

    shellAbbrs = {
      cloud_sql_proxy_all = "cloud_sql_proxy -projects tan-ng,tan-ng-prod -dir /tmp";
      devenv-init = "nix flake init --template github:cachix/devenv";
      pf-argocd = "kubectl port-forward -n argocd svc/argocd-server 8080:80";
      pf-staging = "sudo -E kubefwd svc -n test";
      pf-prod = "sudo -E kubefwd svc -n prod";
    };

    interactiveShellInit = ''
      # shellAbbrs doesn't support more complex abbreviations
      abbr --add --global flake-init --set-cursor 'nix flake init -t github:johnhampton/flake-templates#%'
    '';

    shellInit = ''
      # nix
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      # Homebrew
      if test -e /opt/homebrew/bin/brew
        eval "$(/opt/homebrew/bin/brew shellenv)"
      else if test -e /usr/local/bin/brew
        eval "$(/usr/local/bin/brew shellenv)"
      end
    '';

    loginShellInit = ''
      ssh-add --apple-load-keychain -q
    '';
  };

  programs.gh.enable = true;
  programs.gh = {
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        tc = "repo clone topagentnetwork/$1 -- -c 'user.email=john@topagentnetwork.com'";
      };

    };
  };

  programs.jq.enable = true;

  programs.navi.enable = true;
  programs.navi = {
    settings = {
      cheats = {
        paths =
          let
            configDir =
              if pkgs.stdenv.isDarwin then
                "${config.home.homeDirectory}/Library/Application Support"
              else
                config.xdg.configHome;
          in
          [
            "${config.home.homeDirectory}/Code/me/cheats"
            "${configDir}/navi/cheats"
          ];
      };
    };
  };

  # https://starship.rs/config/
  programs.starship.enable = true;
  programs.starship.settings = {
    command_timeout = 1000;
  };
}
