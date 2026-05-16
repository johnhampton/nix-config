{ pkgs, ... }:
let
  tomlFormat = pkgs.formats.toml { };
  conf = {
    install = {
      # Seconds. 604800 = 7 days. Added in Bun 1.3.
      minimumReleaseAge = 604800;
      minimumReleaseAgeExcludes = [
        "@tan/*"
        "@topagentnetwork/*"
      ];
    };
  };
in
{
  home.file.".bunfig.toml".source = tomlFormat.generate "bunfig" conf;
}
