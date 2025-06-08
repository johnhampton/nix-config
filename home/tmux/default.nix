{ pkgs, config, ... }: {
  imports = [
    ./sesh.nix
    ./lazygit.nix
  ];
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
    focusEvents = true;

    extraConfig = ''
      # https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6
      set -as terminal-features ",*:RGB"

      set -g renumber-windows on

      bind-key -T copy-mode-vi 'v' send-keys -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-selection-and-cancel

      bind-key a last-window
      bind-key C-a send-prefix
      
      bind-key C-p previous-window
      bind-key C-n next-window
      
      # Send literal Ctrl-l when prefix C-l is pressed (useful for clearing terminal)
      bind-key C-l send-keys 'C-l'

      # Window movement bindings (from pain-control)
      bind-key -r "<" swap-window -d -t -1
      bind-key -r ">" swap-window -d -t +1

      # Pane split bindings (from pain-control)
      bind-key "|" split-window -h -c "#{pane_current_path}"
      bind-key "\\" split-window -fh -c "#{pane_current_path}"
      bind-key "-" split-window -v -c "#{pane_current_path}"
      bind-key "_" split-window -fv -c "#{pane_current_path}"
      bind-key "%" split-window -h -c "#{pane_current_path}"
      bind-key '"' split-window -v -c "#{pane_current_path}"

      # Improve new window binding (from pain-control)
      bind-key "c" new-window -c "#{pane_current_path}"

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

      # Toggle synchronized panes - type in all panes simultaneously
      bind-key e setw synchronize-panes

      # Dynamically update iTerm tab and window titles.
      set-option -g set-titles on

      # - #S = session name
      # - #T = pane title (~/.zshrc sets this to the last/current command)
      set-option -g set-titles-string "#S > #T"

      # But don't change tmux's own window titles.
      set-option -w -g automatic-rename off

      # I don't think we need reattach-to-user-namespace anymore
      set-option -gu default-command

      set-option -g display-panes-time 2000

      set -g status-left-length 25

      set-option -g detach-on-destroy off

      set-option -sg escape-time 10

      # Allow terminal-specific escape sequences to pass through tmux
      set-option -g allow-passthrough on

      # Terminal bell configuration for proper pass-through to WezTerm
      # This allows WezTerm to handle visual bells and notifications

      # Listen to bell events from all windows, not just the current one
      # Options: none (ignore bells), current (only current window), any (all windows)
      set -g bell-action any

      # Enable monitoring for bell events in windows
      # When on, tmux will mark windows with bell activity
      set -g monitor-bell on

      # Disable tmux's visual bell to let WezTerm handle visual feedback
      # When off, tmux passes the bell through without its own visual indication
      set -g visual-bell off

      # Also disable visual notifications for activity and silence
      # This prevents tmux from interfering with terminal bell handling
      set -g visual-activity off
      set -g visual-silence off

      # Smart pane switching with awareness of Vim splits using smart-splits.nvim
      # See: https://github.com/mrjones2014/smart-splits.nvim
      # Smart-splits.nvim sets the @pane-is-vim variable
      bind-key -n 'C-h' if -F "#{@pane-is-vim}" 'send-keys C-h' 'select-pane -L'
      bind-key -n 'C-j' if -F "#{@pane-is-vim}" 'send-keys C-j' 'select-pane -D'
      bind-key -n 'C-k' if -F "#{@pane-is-vim}" 'send-keys C-k' 'select-pane -U'
      bind-key -n 'C-l' if -F "#{@pane-is-vim}" 'send-keys C-l' 'select-pane -R'
      bind-key -n 'C-\' if -F "#{@pane-is-vim}" 'send-keys C-\\' 'select-pane -l'

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Resize panes with Alt + h/j/k/l (smart-splits compatible)
      bind-key -n 'M-h' if -F "#{@pane-is-vim}" 'send-keys M-h' 'resize-pane -L 3'
      bind-key -n 'M-j' if -F "#{@pane-is-vim}" 'send-keys M-j' 'resize-pane -D 3'
      bind-key -n 'M-k' if -F "#{@pane-is-vim}" 'send-keys M-k' 'resize-pane -U 3'
      bind-key -n 'M-l' if -F "#{@pane-is-vim}" 'send-keys M-l' 'resize-pane -R 3'

      # ============================================= #
      # Plugin configuration                          #
      # --------------------------------------------- #

      # Configure prefix-highlight
      set -g @prefix_highlight_show_copy_mode 'on'
      set -g @prefix_highlight_show_sync_mode 'on'
      
      # Configure extrakto
      set -g @extrakto_popup_size "50%,50%"
      set -g @extrakto_popup_position "C"
      set -g @extrakto_editor "nvim"
      
      # Configure resurrect
      set -g @resurrect-dir '${config.xdg.stateHome}/tmux/resurrect'
      set -g @resurrect-capture-pane-contents 'on'
      set -g @resurrect-strategy-vim 'session'
      set -g @resurrect-strategy-nvim 'session'
      set -g @resurrect-processes 'vim nvim man less more tail top htop ssh psql mysql'
      
      # Fix for Nix store paths - clean up saved commands to just the binary name
      set -g @resurrect-hook-post-save-all 'target=$(readlink -f ${config.xdg.stateHome}/tmux/resurrect/last); sed -E "s|/nix/store/[^/]+/bin/||g; s| --cmd .*||g" $target | ${pkgs.moreutils}/bin/sponge $target'
      
      # Configure continuum
      set -g @continuum-restore 'off'
      set -g @continuum-save-interval '15'
      
      # ============================================= #
      # Load all plugins at the very end             #
      # --------------------------------------------- #
      
      run-shell ${pkgs.tmuxPlugins.nord}/share/tmux-plugins/nord/nord.tmux
      run-shell ${pkgs.tmuxPlugins.prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux
      run-shell ${pkgs.tmuxPlugins.sessionist}/share/tmux-plugins/sessionist/sessionist.tmux
      run-shell ${pkgs.tmuxPlugins.extrakto}/share/tmux-plugins/extrakto/extrakto.tmux
      run-shell ${pkgs.tmuxPlugins.resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
      run-shell ${pkgs.tmuxPlugins.continuum}/share/tmux-plugins/continuum/continuum.tmux
    '';
  };
}
