{ pkgs, config, ... }: {
  imports = [ ./t-smart-tmux-session-manager.nix ];
  # We need this in order to 
  home.packages = [ pkgs.ansifilter pkgs.ncurses5 ];

  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    historyLimit = 50000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "tmux-256color";

    plugins = [
      pkgs.tmuxPlugins.logging
      pkgs.tmuxPlugins.nord
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.sessionist

      # Use the same src as the vim plugin 
      (pkgs.tmuxPlugins.vim-tmux-navigator.overrideAttrs (_: {
        inherit (pkgs.vimPlugins.vim-tmux-navigator) src version;
      }))
    ];

    extraConfig = ''
      # https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
      set -sg terminal-overrides ",*:RGB"

      set -g renumber-windows on

      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

      bind-key a last-window
      bind-key C-a send-prefix
      
      bind-key C-p previous-window
      bind-key C-n next-window

      # https://github.com/wincent/wincent/blob/main/aspects/dotfiles/files/.tmux.conf
      unbind-key -T copy-mode-vi MouseDragEnd1Pane

      # Scroll 3 lines at a time instead of default 5; don't extend dragged selections.
      bind-key -T copy-mode-vi WheelUpPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-up
      bind-key -T copy-mode-vi WheelDownPane select-pane\; send-keys -t'{mouse}' -X clear-selection\; send-keys -t'{mouse}' -X -N 3 scroll-down

      # Make double and triple click work outside of copy mode (already works inside it with default bindings).
      bind-key -T root DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
      bind-key -T root TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

      # Don't exit copy mode on double or triple click.
      bind-key -T copy-mode-vi DoubleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-word"
      bind-key -T copy-mode-vi TripleClick1Pane if-shell -Ft'{mouse}' '#{alternate_on}' "send-keys -M" "copy-mode -t'{mouse}'; send-keys -t'{mouse}' -X select-line"

      # For those times when C-c and q are not enough.
      bind-key -T copy-mode-vi Escape send-keys -X cancel

      # Dynamically update iTerm tab and window titles.
      set-option -g set-titles on

      # - #S = session name
      # - #T = pane title (~/.zshrc sets this to the last/current command)
      set-option -g set-titles-string "#S > #T"

      # Needed as on tmux 1.9 and up (defaults to off).
      # Added in tmux commit c7a121cfc0137c907b7bfb.
      set-option -g focus-events on

      # But don't change tmux's own window titles.
      set-option -w -g automatic-rename off

      # I don't think we need reattach-to-user-namespace anymore
      set-option -gu default-command

      set-option -g display-panes-time 2000

      set -g status-left-length 25

      # tmux-logging
      set-option -g "@logging-path" ${config.home.homeDirectory}/Documents/TMUX 
      set-option -g "@screen-capture-path" ${config.home.homeDirectory}/Documents/TMUX 
      set-option -g "@save-complete-history-path" ${config.home.homeDirectory}/Documents/TMUX 

      set-option -g detach-on-destroy off

      set-option -sa terminal-features ',xterm-kitty:RGB'
      set-option -sg escape-time 10
    '';
  };
}
