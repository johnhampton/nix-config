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
      tab_title_template = ''{index}:{title}{"*Z" if layout_name == "stack" else ""}'';
    };
    keybindings = {
      "ctrl+j" = "kitten pass_keys.py neighboring_window bottom ctrl+j";
      "ctrl+k" = "kitten pass_keys.py neighboring_window top    ctrl+k";
      "ctrl+h" = "kitten pass_keys.py neighboring_window left   ctrl+h";
      "ctrl+l" = "kitten pass_keys.py neighboring_window right  ctrl+l";

      # tmux-like mappings 
      "ctrl+a>;" = "nth_window -1"; # previous pane
      "ctrl+a>q" = "focus_visible_window"; #visually select pane
      "ctrl+a>z" = "toggle_layout stack"; #toggle zoom
      "ctrl+a>ctrl+a" = "send_text all \\x01"; #send ctrl-a to the terminal

      "ctrl+a>!" = "detach_window new-tab";

      "ctrl+a>shift+r" = "load_config_file";

      "ctrl+a>c" = "new_tab_with_cwd";
      "ctrl+a>," = "set_tab_title";
      "ctrl+a>w" = "select_tab";
      "ctrl+a>n" = "next_tab";
      "ctrl+a>p" = "previous_tab";
      "ctrl+a>a" = "goto_tab -1";
      "ctrl+a>shift+." = "move_tab_forward";
      "ctrl+a>shift+," = "move_tab_backward";

      "ctrl+a>1" = "goto_tab 1";
      "ctrl+a>2" = "goto_tab 2";
      "ctrl+a>3" = "goto_tab 3";
      "ctrl+a>4" = "goto_tab 4";
      "ctrl+a>5" = "goto_tab 5";
      "ctrl+a>6" = "goto_tab 6";
      "ctrl+a>7" = "goto_tab 7";
      "ctrl+a>8" = "goto_tab 8";
      "ctrl+a>9" = "goto_tab 9";

      # similate behavior from tmux-pain-control
      # https://github.com/tmux-plugins/tmux-pain-control
      # splitting
      "ctrl+a>|" = "launch --cwd current --location vsplit";
      "ctrl+a>\\" = "combine : launch --cwd current --location vsplit : layout_action move_to_screen_edge right";
      "ctrl+a>-" = "launch --cwd current --location hsplit";
      "ctrl+a>_" = "combine : launch --cwd current --location hsplit : layout_action move_to_screen_edge bottom";
      # resizing
      # TODO I'll need a kitten for resizing
    };
    extraConfig = ''
      include ${one-nord}/extras/kitty/onenord.conf
    '';
  };

  xdg.configFile."kitty/neighboring_window.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/neighboring_window.py";
  xdg.configFile."kitty/pass_keys.py".source = "${pkgs.vimPlugins.vim-kitty-navigator}/pass_keys.py";
}
