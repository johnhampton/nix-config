{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  conf = {
    # Yarn 4.10+ release-age gate. Duration string per yarn docs.
    npmMinimalAgeGate = "7d";
    npmPreapprovedPackages = [
      "@tan/*"
      "@topagentnetwork/*"
    ];
  };
in
{
  home.file.".yarnrc.yml".source = yamlFormat.generate "yarnrc" conf;
}
