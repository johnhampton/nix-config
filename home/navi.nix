{ pkgs, config, ... }:
{
  home.sessionVariables = {
    NAVI_CONFIG = "${config.home.homeDirectory}/Library/Application Support/navi/config.yaml";
  };

  programs.navi.enable = true;
  programs.navi = {
    settings = {
      cheats = {
        paths =
          let
            configDir =
              if pkgs.stdenv.isDarwin then
                "${config.home.homeDirectory}/Library/Application Support"
              else
                config.xdg.configHome;
          in
          [
            "${config.home.homeDirectory}/Code/me/cheats"
            "${configDir}/navi/cheats"
          ];
      };
    };
  };
}
