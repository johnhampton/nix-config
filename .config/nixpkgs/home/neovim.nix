{ pkgs, ... }:

let
  pluginWithDeps = plugin: deps: plugin.overrideAttrs (_: { dependencies = deps; }); 

  pluginWithConfig = { plugin, optional ? false, jjextraConfig ? "", deps ? [] }: 
    let plugin' = if deps == [] then plugin else pluginWithDeps plugin deps;  in {
    plugin = plugin';
    type = "lua";
    config = ''
      require('johnhampton.' .. string.gsub('${plugin.pname}', '%.', '-'))
    '';
  };

in

{ 
  home.packages = with pkgs; [ fd ];

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

    # which-key
    (pluginWithConfig {plugin=which-key-nvim; })

    # treesitter
    (pluginWithConfig {plugin= nvim-treesitter.withAllGrammars;})

    # Comment
    {plugin=nvim-ts-context-commentstring; }
    (pluginWithConfig {plugin= comment-nvim; })

    # nvim-tree
    (pluginWithConfig {plugin=nvim-tree-lua; deps = [nvim-web-devicons];})

    # telescope
    (pluginWithConfig {plugin=telescope-nvim;})
    {plugin=telescope-ui-select-nvim; }
    {plugin=telescope-fzf-native-nvim;}
  ];
}
