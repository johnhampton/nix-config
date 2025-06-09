{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      mgr = {
        sort_by = "mtime";
        sort_reverse = true;
      };
      theme = {
        use = "nord";
      };
    };

    flavors = {
      nord = pkgs.yaziPlugins.nord;
    };
  };

  home.packages = with pkgs; [
    ffmpeg
    imagemagick
    p7zip
    poppler
  ];
}
