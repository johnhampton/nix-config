{ pkgs, age, ... }:
{
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.ChatGPT-nvim;
    type = "lua";
    config = ''
      require('chatgpt').setup({ 
        api_key_cmd = "${pkgs.bat}/bin/bat -p ${age.secrets.chatgpt.path}"
      }) 
    '';
  }];

}
