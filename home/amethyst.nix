{ pkgs, ... }:
let
  conf = {
    floating = [
      "com.apple.finder"
      "com.apple.systempreferences"
      "com.adobe.acc.AdobeCreativeCloud"
      "com.apple.Music"
    ];
    layouts = [
      "tall"
      "wide"
      "middle-wide"
      "bsp"
      "fullscreen"
      "column"
    ];
  };
  yamlFormat = pkgs.formats.yaml { };
in
{
  xdg.configFile."amethyst/amethyst.yml".source = yamlFormat.generate "amethyst-config" conf;
}


