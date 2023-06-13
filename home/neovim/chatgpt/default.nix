{ pkgs, age, ... }:
{
  xdg.configFile."nvim/lua/johnhampton/chatgpt.lua".source = ./chatgpt.lua;
  programs.neovim.plugins = [{
    plugin = pkgs.vimPlugins.ChatGPT-nvim;
    type = "lua";
    config = ''
      require('johnhampton.chatgpt').setup_chatgpt({ 
        api_key_cmd = "${pkgs.bat}/bin/bat -p ${age.secrets.chatgpt.path}",
      })
    '';
  }];
}
