{ pkgs, ... }:
let inherit (pkgs.tmuxPlugins) t-smart-tmux-session-manager; in {
  home.packages = builtins.attrValues {
    inherit (pkgs) fd fzf zoxide;
  };

  programs.tmux = {
    plugins = [
      t-smart-tmux-session-manager
    ];

    extraConfig = ''
      set -g @t-fzf-prompt '  '
    '';
  };

  programs.zsh = {
    shellAliases = {
      "tn" = "tmux new -s $(basename $PWD)";
    };
    initContent = ''
      export PATH="$PATH:${t-smart-tmux-session-manager}/share/tmux-plugins/t-smart-tmux-session-manager/bin"
    '';
  };

  programs.kitty.keybindings = {
    "cmd+j" = "send_text all \\x01T";
  };
}
