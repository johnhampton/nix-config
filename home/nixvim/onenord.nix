{ pkgs, config, lib, ... }: 

{

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.onenord-nvim ];
    extraConfigLua = ''
      require('onenord').setup()
    '';
   

   plugins.lspsaga.settings.ui.kind = lib.nixvim.mkRaw "require('onenord.integrations.lspsaga').custom_kind()";
   plugins.lualine.settings.theme = "onenord";
  };
}
