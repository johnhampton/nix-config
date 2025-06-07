{ pkgs, age, inputs, lib, ... }:

{
  imports = [
    inputs.nix-index-database.hmModules.nix-index
    { programs.nix-index-database.comma.enable = true; }

    ./aider.nix
    ./alacritty.nix
    ./amethyst.nix
    ./cachix
    ./git.nix
    ./haskell.nix
    ./karabiner
    ./navi.nix
    ./nixvim
    ./postgres
    ./ssh.nix
    ./tmux
    ./vscode.nix
    ./wezterm

  ];
  home.packages = with pkgs; [
    argocd
    argocd-autopilot
    chartmuseum
    colima
    darwin.trash
    docker-client
    dos2unix
    dotenv-cli
    duckdb
    fd
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    graphite-cli
    inputs.hchart.packages.${pkgs.system}.default
    (wrapHelm kubernetes-helm { plugins = [ kubernetes-helmPlugins.helm-mapkubeapis ]; })
    hurl
    just
    kind
    kubectl
    kubectx
    kustomize
    mas
    nodejs
    patchutils_0_4_2
    pgcli
    pragmata-pro
    (python3.withPackages (p: [p.pip]))
    rainfrog
    repomix
    ripgrep
    terraform-ls
    uv
    watchman
    yq-go
  ];

  nix.extraOptions = ''
    !include ${age.secrets.access_token.path}
  '';

  nix.gc = {
    automatic = true;
    frequency = "weekly"; # Runs weekly
    options = "--delete-older-than 30d";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
  };

  # See ./secrets/npmrc.age for configuration of prefix
  home.sessionPath = [
    "$HOME/.npm-global/bin"
    "$HOME/.local/bin"
  ];

  home.activation = {
    createNpmGlobalDir = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      mkdir -p $HOME/.npm-global
    '';
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
  programs.direnv = {
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  programs.eza.enable = true;
  programs.eza = {
    icons = "auto";
    git = true;
  };

  programs.fish.enable = false;

  programs.zsh.enable = true;
  programs.zsh = {
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;

    shellAliases = {
      cloud_sql_proxy_all = "cloud_sql_proxy -projects tan-ng,tan-ng-prod -dir /tmp";
      devenv-init = "nix flake init --template github:cachix/devenv";
      pf-argocd = "kubectl port-forward -n argocd svc/argocd-server 8080:80";
      pf-staging = "sudo -E kubefwd svc -n test";
      pf-prod = "sudo -E kubefwd svc -n prod";
      flake-init = "nix flake init -t github:johnhampton/flake-templates#";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        # nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        
        # Homebrew
        if [ -e /opt/homebrew/bin/brew ]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        elif [ -e /usr/local/bin/brew ]; then
          eval "$(/usr/local/bin/brew shellenv)"
        fi
      '')
      ''
        autoload -Uz edit-command-line
        zle -N edit-command-line
        bindkey '^X^E' edit-command-line
      ''
    ];

    loginExtra = ''
      # ssh keychain
      ssh-add --apple-load-keychain -q
    '';
  };

  programs.fzf.enable = true;
  programs.fzf = {
    enableZshIntegration = true;
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
  programs.starship = {
    enableZshIntegration = true;
    settings = {
      command_timeout = 2000;
      aws = {
        disabled = true;
      };
    };
  };

  targets.darwin.defaults."com.apple.finder".FXRemoveOldTrashItems = true;

  xdg.enable = true;
  xdg.configFile."process-compose/shortcuts.yaml".source =
    let
      yamlFormal = pkgs.formats.yaml
        { };
    in
    yamlFormal.generate
      "shortcuts.yaml"
      {
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

