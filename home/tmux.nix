{ pkgs, ... }: {
  # We need this in order to 
  home.packages = [ pkgs.ncurses5 ];
  programs.tmux.enable = true;
  programs.tmux = {
    baseIndex = 1;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = true;
    shortcut = "a";
    terminal = "tmux-256color";

    plugins = [
      pkgs.tmuxPlugins.nord
      pkgs.tmuxPlugins.pain-control
      pkgs.tmuxPlugins.sessionist
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
    '';
  };

}
