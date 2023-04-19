{ ... }:
{
  programs.tmux.extraConfig = ''
    bind-key G new-window -n lazygit -c "#{pane_current_path}" direnv exec . lazygit
  '';

  programs.kitty.keybindings = {
    "cmd+g" = "send_text all \\x01G";
  };
}
