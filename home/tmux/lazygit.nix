{ ... }:
{
  programs.tmux.extraConfig = ''
    bind-key G new-window -c "#{pane_current_path}" lazygit
  '';

  programs.kitty.keybindings = {
    "cmd+g" = "send_text all \\x01G";
  };
}
