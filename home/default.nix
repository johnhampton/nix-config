{ pkgs, config, age, inputs, ... }:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    { programs.nix-index-database.comma.enable = true; }

    ./alacritty.nix
    ./amethyst.nix
    ./cachix
    ./git.nix
    ./kitty.nix
    ./navi.nix
    ./neovim
    ./ssh.nix
    ./tmux
    ./wezterm.nix
  ];
  home.packages = with pkgs; [
    argocd
    argocd-autopilot
    chartmuseum
    colima
    darwin.trash
    docker-client
    dos2unix
    fd
    fishPlugins.foreign-env
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    graphite-cli
    inputs.hchart.packages.${pkgs.system}.default
    (wrapHelm kubernetes-helm { plugins = [ kubernetes-helmPlugins.helm-mapkubeapis ]; })
    just
    kind
    kubectl
    kubectx
    kustomize
    nerdfonts
    patchutils_0_4_2
    pragmata-pro
    ripgrep
    terraform-ls
    watchman
  ];

  nix.extraOptions = ''
    !include ${age.secrets.access_token.path}
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

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

  programs.eza.enable = true;
  programs.eza = {
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.fish.enable = true;
  programs.fish = {
    plugins = [
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

  programs.fzf.enable = true;
  programs.fzf = {
    tmux.enableShellIntegration = true;
  };
  programs.zoxide.enable = true;

  programs.gh.enable = true;
  programs.gh = {
    settings = {
      git_protocol = "https";
      aliases = {
        co = "pr checkout";
        tc = "repo clone topagentnetwork/$1 -- -c 'user.email=john@topagentnetwork.com'";
      };
      version = "1";
    };
  };

  programs.jq.enable = true;


  # https://starship.rs/config/
  programs.starship.enable = true;
  programs.starship.settings = {
    command_timeout = 1000;
    aws = {
      disabled = true;
    };
  };


  xdg.configFile."process-compose/shortcuts.yaml".source = let yamlFormal = pkgs.formats.yaml { }; in yamlFormal.generate "shortcuts.yaml" {
    shortcuts = {
      process_stop = {
        shortcut = "Ctrl-X";
      };
      quit = {
        shortcut = "Ctrl-Q";
      };

    };
  };
}

