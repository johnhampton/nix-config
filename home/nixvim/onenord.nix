{ pkgs, config, ... }: 
  let 
    inherit (config.nixvim) helpers;
    in 

{

  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.onenord-nvim ];
    extraConfigLua = ''
      require('onenord').setup()
    '';
   

   plugins.lspsaga.ui.kind = helpers.mkRaw "require('onenord.integrations.lspsaga').custom_kind()";
   plugins.lualine.settings.theme = "onenord";
  };
}
