{ pkgs, one-nord, ... }:
{
  programs.kitty.enable = true;
  programs.kitty = {
    font = {
      name = "Iosevka Nerd Font";
      size = 14;
    };
    settings = {
      allow_remote_control = "yes";
      enabled_layouts = "splits,tall:bias=70,fat:bias=70,stack";
      listen_on = "unix:/tmp/mykitty";
      macos_option_as_alt = "left";
      macos_quit_when_last_window_closed = "yes";
      tab_bar_style = "powerline";
    };
    keybindings = {
      "ctrl+j" = "kitten pass_keys.py neighboring_window bottom ctrl+j";
      "ctrl+k" = "kitten pass_keys.py neighboring_window top    ctrl+k";
      "ctrl+h" = "kitten pass_keys.py neighboring_window left   ctrl+h";
      "ctrl+l" = "kitten pass_keys.py neighboring_window right  ctrl+l";

      "cmd+a>|" = "launch --cwd current --location vsplit";
      "cmd+a>-" = "launch --cwd current --location hsplit";
      "cmd+a>z" = "toggle_layout stack";
    };
    extraConfig = ''
      include ${one-nord}/extras/kitty/onenord.conf
    '';
  };

  xdg.configFile."kitty/neighboring_window.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/neighboring_window.py";
  xdg.configFile."kitty/pass_keys.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/pass_keys.py";
}
