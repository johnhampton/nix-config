{ config, ... }:
{
  programs.navi.enable = true;
  programs.navi = {
    settings = {
      cheats = {
        paths =
          [
            "${config.home.homeDirectory}/Code/me/cheats"
          ];
      };
    };
  };
}
