{ pkgs, ... }:
{
  programs.tmux.extraConfig = ''
    bind-key G new-window -n lazygit -c "#{pane_current_path}" direnv exec . lazygit
  '';

  programs.kitty.keybindings = {
    "cmd+g" = "send_text all \\x01G";
  };

  programs.lazygit = {
    enable = true;

    settings = {
      gui.sidePanelWidth = 0.2;

      git.pagers = [
        {
          # Uses chameleon theme from programs.delta
          pager = "delta --paging=never --side-by-side";
        }
        {
          # Unified view fallback - press | to toggle
          pager = "delta --paging=never";
        }
      ];
    };
  };
}
