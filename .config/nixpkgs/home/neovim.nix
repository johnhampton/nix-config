{ pkgs, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; }); 

  pluginWithConfig = { plugin, optional ? true, extraConfig ? "", deps ? [] }: {
    inherit plugin;
    type = "lua";
    config = ''
      require('johnhampton.' .. string.gsub('${plugin.pname}', '%.', '-'))
    '';
  };

in

{ 
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/lua".source = ./neovim/lua;
  xdg.configFile."nvim/lua".recursive = true;

  programs.neovim.extraConfig = ''
    lua require('johnhampton')
  '';

  programs.neovim.plugins = with pkgs.vimPlugins; [
    # colorscheme
  	(pluginWithConfig {plugin= onenord-nvim; })

    # treesitter
    (pluginWithConfig {plugin= nvim-treesitter.withAllGrammars;})

    # Comment
    nvim-ts-context-commentstring
    (pluginWithConfig {plugin= comment-nvim; })
  ];

}
