{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [ pkgs.vimPlugins.haskell-tools-nvim ];
		extraPackages = [
		  pkgs.haskellPackages.fast-tags
			pkgs.haskellPackages.haskell-debug-adapter
		];

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
