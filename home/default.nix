{ config, pkgs, plugin-foreign-env, access_token, ... }:

{

  imports = [
    ./kitty.nix
    ./neovim.nix
    ./ssh.nix
  ];
  home.packages = with pkgs; [

    argocd
    argocd-autopilot
    colima
    docker-client
    dos2unix
    (google-cloud-sdk.withExtraComponents (with google-cloud-sdk.components; [ cloud_sql_proxy gke-gcloud-auth-plugin ]))
    graphite-cli
    just
    kind
    kubectl
    kubectx
    kustomize
    nerdfonts
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
    };

    interactiveShellInit = ''
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

  programs.git.enable = true;
  programs.git = {
    userName = "John Hampton";
    userEmail = "john.hampton@stanfordalumni.org";
    aliases = {
      fix-commit = "commit --edit --file=.git/COMMIT_EDITMSG";
      use-tan-email = "config user.email \"john@topagentnetwork.com\"";
    };
    extraConfig = {
      credential = { helper = "osxkeychain"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "master"; };
      "mergetool \"nvim\"" = {
        cmd = "nvim -f -c \"Gdiffsplit!\" \"$MERGED\"";
      };
      mergetool = { prompt = false; };
      merge = { tool = "nvim"; };

      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org";
      gpg.format = "ssh";
      gpg.ssh.allowedSignersFile = "${config.xdg.configHome}/git/allowed_signers";
      commit.gpgsign = true;
      tag.gpgsign = true;
    };
  };
  xdg.configFile."git/allowed_signers".text = ''
    john@topagentnetwork.com  ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
    john.hampton@stanfordalumni.org ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIG4wlxsjNK5Qwk4jSR6p2zQH3/OX9xppmu5FpnmGThzm john.hampton@stanfordalumni.org
  '';

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

  # https://starship.rs/config/
  programs.starship.enable = true;
  programs.starship.settings = {
    command_timeout = 1000;
  };
}
