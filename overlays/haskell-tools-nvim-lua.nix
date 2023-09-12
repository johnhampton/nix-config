{ ... }:
final: prev:
let
  packageOverrides = luaself: luaprev: {
    haskell-tools-nvim = luaprev.haskell-tools-nvim.overrideAttrs (oa: {

      version = "2.1.0-1";
      rockspecVersion = "2.1.0-1";

      knownRockspec = (final.fetchurl {
        url = "https://luarocks.org/manifests/MrcJkb/haskell-tools.nvim-2.1.0-1.rockspec";
        sha256 = "18z5jjmm82hrdslqadyb844icr8xc99qsyg3b785kyx69rjyng05";
      }).outPath;

      src = final.fetchzip {
        url = "https://github.com/mrcjkb/haskell-tools.nvim/archive/2.1.0.zip";
        sha256 = "aQaXEmThShUHPavCqB/uiCVVp+i2lsAR4cJRRoLl6eY=";
      };
    });
  };

  lua = prev.lua.override { inherit packageOverrides; };
  luaPackages = lua.pkgs;

  luajit = prev.luajit.override { inherit packageOverrides; };
  luajitPackages = luajit.pkgs;

  lua5_1 = prev.lua5_1.override { inherit packageOverrides; };
  lua51Packages = lua5_1.pkgs;
in
{
  inherit lua luaPackages luajit luajitPackages lua5_1 lua51Packages;
}
