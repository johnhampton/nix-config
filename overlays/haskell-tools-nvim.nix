{ ... }:
final: prev:
let
  packageOverrides = luaself: luaprev:
    let
      overlayVersion = "6.0.0-1";
      srcFile = "v${builtins.elemAt (builtins.split "-" overlayVersion) 0}.zip";

      # Helper function to extract major version for comparison (6.0.0-1 -> 6.0.0)
      baseVersion = v: builtins.elemAt (builtins.split "-" v) 0;

      # Check if nixpkgs version is >= 6.0.0
      nixpkgsPackage = luaprev.haskell-tools-nvim or null;
      nixpkgsVersion = nixpkgsPackage.version or "0.0.0";
      nixpkgsMeetsVersion =
        nixpkgsPackage != null &&
        builtins.compareVersions (baseVersion nixpkgsVersion) "6.0.0" >= 0;

      # Define the derivation just once
      overlayDerivation = luaprev.haskell-tools-nvim.overrideAttrs (oa: {
        version = overlayVersion;
        rockspecVersion = overlayVersion;
        knownRockspec = (final.fetchurl {
          url = "https://luarocks.org/manifests/mrcjkb/haskell-tools.nvim-${overlayVersion}.rockspec";
          sha256 = "sha256-FBd4xlnpnTSs2XN3yvSSw5Mav3CGmM0n22xtli78hb8=";
        }).outPath;
        src = final.fetchzip {
          url = "https://github.com/mrcjkb/haskell-tools.nvim/archive/${srcFile}";
          sha256 = "sha256-GFItbi6arFylOsRCKCEJKlH9Udv1cGpVWDUK316PrZY=";
        };
      });

      # Add trace warning only when condition is met
      haskell-tools-with-warning =
        if nixpkgsMeetsVersion
        then
          builtins.trace "WARNING: haskell-tools-nvim version ${nixpkgsVersion} in nixpkgs is >= 6.0.0. Consider removing this overlay."
            overlayDerivation
        else overlayDerivation;
    in
    {
      haskell-tools-nvim = haskell-tools-with-warning;
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
