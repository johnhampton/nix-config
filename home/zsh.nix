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
      claude-config = "nvim ~/Library/Application\\ Support/Claude/claude_desktop_config.json";
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
        # disable sort when completing `git checkout`
        zstyle ':completion:*:git-checkout:*' sort false

        # set descriptions format to enable group support
        # NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
        zstyle ':completion:*:descriptions' format '[%d]'


        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
        # set list-colors to enable filename colorizing
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'

        # custom fzf flags
        # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
        zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept

        # To make fzf-tab follow FZF_DEFAULT_OPTS.
        # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
        # zstyle ':fzf-tab:*' use-fzf-default-opts yes

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
