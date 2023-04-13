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

  programs.fish = {
    shellAbbrs = {
      "tn" = "tmux new -s (pwd | sed 's/.*\\///g')";
    };
    shellInit = ''
      fish_add_path ${t-smart-tmux-session-manager}/share/tmux-plugins/t-smart-tmux-session-manager/bin
    '';
  };

  programs.kitty.keybindings = {
    "cmd+j" = "send_text all \\x01T";
  };
}
