{ ... }:
{
  services.yabai.enable = true;
  services.yabai = {
    config = {
      layout = "bsp";
      window_placement = "second_child";

      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
      window_gap = 6;

      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
    };
    extraConfig = ''
      yabai -m rule --add app="^System Settings$" manage=off
      yabai -m rule --add app="^Creative Cloud$" manage=off
    '';
  };


  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    # change window focus within space
    alt - j : yabai -m window --focus south
    alt - k : yabai -m window --focus north
    alt - h : yabai -m window --focus west
    alt - l : yabai -m window --focus east

    # swap windows
    shift + alt - h : yabai -m window --swap west
    shift + alt - j : yabai -m window --swap south
    shift + alt - k : yabai -m window --swap north
    shift + alt - l : yabai -m window --swap east

    # move window and split
    ctrl + shift + alt - j : yabai -m window --warp south
    ctrl + shift + alt - k : yabai -m window --warp north
    ctrl + shift + alt - h : yabai -m window --warp west
    ctrl + shift + alt - l : yabai -m window --warp east

    # rotate layout clockwise
    shift + alt - r : yabai -m space --rotate 270

    # flip along y-axis
    shift + alt - y : yabai -m space --mirror y-axis

    # flip along x-axis
    shift + alt - x : yabai -m space --mirror x-axis

    # float / unfloat window and center on screen
    shift + alt - t : yabai -m window --toggle float;\
              yabai -m window --grid 4:4:1:1:2:2

    # maximize a window
    shift + alt - m : yabai -m window --toggle zoom-fullscreen

    # balance out tree of windows (resize to occupy same area)
    shift + alt - e : yabai -m space --balance

    #move window to prev and next space
    ctrl + shift + alt - left : yabai -m window --space prev;
    ctrl + shift + alt - right : yabai -m window --space next;

    # move window to space #
    ctrl + shift + alt - 1 : yabai -m window --space 1;
    ctrl + shift + alt - 2 : yabai -m window --space 2;
    ctrl + shift + alt - 3 : yabai -m window --space 3;
    ctrl + shift + alt - 4 : yabai -m window --space 4;
    ctrl + shift + alt - 5 : yabai -m window --space 5;
    ctrl + shift + alt - 6 : yabai -m window --space 6;
    ctrl + shift + alt - 8 : yabai -m window --space 8;
    ctrl + shift + alt - 9 : yabai -m window --space 9;

    # stop/start/restart yabai
    ctrl + alt - q : launchctl unload -w $HOME/Library/LaunchAgents/org.nixos.yabai.plist
    ctrl + alt - s : launchctl load -w $HOME/Library/LaunchAgents/org.nixos.yabai.plist
    ctrl + alt - r : launchctl kickstart -k gui/$(id -u)/org.nixos.yabai
  '';
}
