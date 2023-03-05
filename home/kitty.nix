{ one-nord, ... }:
{
  programs.kitty.enable = true;
  programs.kitty = {
    font = {
      name = "Iosevka Nerd Font";
      size = 14;
    };
    extraConfig = ''
      include ${one-nord}/extras/kitty/onenord.conf
    '';
  };
}
