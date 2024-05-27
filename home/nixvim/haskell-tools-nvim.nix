{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.haskell-tools-nvim ];

    files = {
      "after/ftplugin/haskell.lua" = {
        extraConfigLua = ''
          require('haskell-tools')
        '';
      };

      "after/ftplugin/cabal.lua" = {
        extraConfigLua = ''
          require('haskell-tools')
        '';
      };
    };
  };
}
