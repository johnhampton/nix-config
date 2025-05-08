{ ... }:
final: prev:
let
  packageOverrides = luaself: luaprev:
    let
      version = "6.0.0-1";
      srcFile = "v${builtins.elemAt (builtins.split "-" version) 0}.zip";
    in
    {
      haskell-tools-nvim = luaprev.haskell-tools-nvim.overrideAttrs (oa: {
        inherit version;

        rockspecVersion = version;
        knownRockspec = (final.fetchurl {
          url = "https://luarocks.org/manifests/mrcjkb/haskell-tools.nvim-${version}.rockspec";
          sha256 = "sha256-FBd4xlnpnTSs2XN3yvSSw5Mav3CGmM0n22xtli78hb8=";
        }).outPath;

        src = final.fetchzip {
          url = "https://github.com/mrcjkb/haskell-tools.nvim/archive/${srcFile}";
          sha256 = "sha256-GFItbi6arFylOsRCKCEJKlH9Udv1cGpVWDUK316PrZY=";
        };
      });
    };

  luajit = prev.luajit.override { inherit packageOverrides; };
  luajitPackages = luajit.pkgs;

  lua = prev.lua.override { inherit packageOverrides; };
  luaPackages = lua.pkgs;

  lua5_1 = prev.lua5_1.override { inherit packageOverrides; };
  lua51Packages = lua5_1.pkgs;

  lua5_2 = prev.lua5_2.override { inherit packageOverrides; };
  lua52Packages = lua5_2.pkgs;

  lua5_3 = prev.lua5_3.override { inherit packageOverrides; };
  lua53Packages = lua5_3.pkgs;

  lua5_4 = prev.lua5_4.override { inherit packageOverrides; };
  lua54Packages = lua5_4.pkgs;
in
{
  inherit
    luajit luajitPackages
    lua luaPackages
    lua5_1 lua51Packages
    lua5_2 lua52Packages
    lua5_3 lua53Packages
    lua5_4 lua54Packages;
}
