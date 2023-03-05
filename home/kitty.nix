{ pkgs, ... }:
{
  programs.kitty.enable = true;
  programs.kitty = {
    font = {
      name = "Iosevka Nerd Font";
      size = 14;
    };
  };


}
