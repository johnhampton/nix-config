{ pkgs, ... }: {
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    font = {
      normal = {
        family = "Iosevka Nerd Font";
      };

      size = 14;
    };
    import = [
      "${pkgs.vimPlugins.onenord-nvim.src}/extras/alacritty/onenord.yaml"
    ];
  };
}
