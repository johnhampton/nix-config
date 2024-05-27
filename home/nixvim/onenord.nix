{ pkgs, ... }: {

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.onenord-nvim ];
    extraConfigLua = ''
      require('onenord').setup()
    '';
  };
}
