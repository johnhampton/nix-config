{ lib, ... }: {
  # sesh dependencies are handled by the module itself
  # we already have fd, fzf, and zoxide in the system

  programs.sesh = {
    enable = true;
    tmuxKey = "j"; # Use prefix + j instead of default prefix + s
    # enableAlias = true; # default, provides 's' shell alias
    enableTmuxIntegration = false; # default
    # icons = true; # default

    settings = {
      default_session = {
        # startup_command = "tmux rename-window 'main'; clear";
        preview_command = "eza --all --git --icons --color=always {}";
      };
      session = [
        {
          name = "Cheatsheets 📝";
          path = "~/Code/me/cheats";
          startup_command = "nvim -c 'Telescope find_files'";
        }
        {
          name = "Downloads 📥";
          path = "~/Downloads";
          startup_command = "yazi";
        }
        {
          name = "Home 🏠";
          path = "~";
        }
        { name = "Configs ⚙︎";
          path = "~/.config/nix-config";
          startup_command = "tmux split-window -h -d && nvim";
        }
      ];
    };
  };

  programs.tmux.extraConfig = lib.mkAfter ''
    bind -N "last-session (via sesh) " L run-shell "sesh last"

    bind-key "j" run-shell "sesh connect \"$(
      sesh list --hide-duplicates --icons | fzf-tmux -p 80%,70% \
        --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
        --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
        --bind 'tab:down,btab:up' \
        --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
        --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
        --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
        --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
        --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
        --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --hide-duplicates --icons)' \
        --preview-window 'right:55%' \
        --preview 'sesh preview {}'
    )\""
  '';
}
