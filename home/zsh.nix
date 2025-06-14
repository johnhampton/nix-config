{ lib, pkgs, ... }: {
  # Zsh shell configuration
  programs.zsh.enable = true;
  programs.zsh = {
    autosuggestion.enable = true;
    enableCompletion = true;
    autocd = true;
    defaultKeymap = "emacs";
    syntaxHighlighting.enable = true;
    history = {
      append = true;
      expireDuplicatesFirst = true;
      findNoDups = true;
      ignoreAllDups = true;
      ignoreDups = true;
      ignoreSpace = true;
      saveNoDups = true;
      share = true;
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
        file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];

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

        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward

        eval "$(${pkgs.coreutils}/bin/dircolors -b)"
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza $realpath'
      ''
    ];

    loginExtra = ''
      # ssh keychain
      ssh-add --apple-load-keychain -q
    '';
  };

  # Shell integrations

  # Direnv - load and unload environment variables depending on the current directory
  # https://direnv.net
  programs.direnv.enable = true;
  programs.direnv = {
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;
  };

  # Fuzzy finder
  programs.fzf.enable = true;
  programs.fzf = {
    enableZshIntegration = true;
    tmux.enableShellIntegration = true;
    defaultOptions = [
      "--walker-skip=.direnv"
    ];
  };

  # Smarter cd command
  programs.zoxide.enable = true;
  programs.zoxide.options = [ "--cmd" "cd" ];

  # Starship prompt
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
}
