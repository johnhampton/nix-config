{ pkgs, age, inputs, lib, config, ... }:

{
  imports = [
    inputs.nix-index-database.homeModules.nix-index
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
    ./scripts
    ./ssh.nix
    ./tmux
    ./vscode.nix
    ./wezterm
    ./yazi.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    argocd
    argocd-autopilot
    ast-grep
    bun
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
    k9s
    kind
    kubectl
    kubectx
    kustomize
    mas
    neofetch
    nodejs
    patchutils_0_4_2
    pgcli
    pragmata-pro
    (python3.withPackages (p: [ p.pip ]))
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
    dates = "weekly";
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

  programs.eza.enable = true;
  programs.eza = {
    icons = "auto";
    git = true;
  };

  programs.fish.enable = false;

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

