{ pkgs, ... }:

let


in

{ 
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  home.file.".config/nvim/lua/johnhampton/init.lua".source = ./neovim/lua/johnhampton/init.lua;

  home.file.".config/nvim/lua/johnhampton/colorscheme.lua".source = ./neovim/lua/johnhampton/colorscheme.lua;
  home.file.".config/nvim/lua/johnhampton/keymaps.lua".source = ./neovim/lua/johnhampton/keymaps.lua;
  home.file.".config/nvim/lua/johnhampton/options.lua".source = ./neovim/lua/johnhampton/options.lua;
  home.file.".config/nvim/lua/johnhampton/settings.lua".source = ./neovim/lua/johnhampton/settings.lua;

  programs.neovim.extraConfig = ''
    lua require('johnhampton')
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [
  	onenord-nvim
  ];

}
