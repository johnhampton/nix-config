{ pkgs, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
  conf = {
    # Refuse package versions published in the last N minutes — supply-chain
    # embargo. 10080 = 7 days. pnpm 11+ defaults to 1440 (1 day).
    minimumReleaseAge = 10080;
    minimumReleaseAgeExclude = [
      "@tan/*"
      "@topagentnetwork/*"
    ];
  };
in
{
  xdg.configFile."pnpm/config.yaml".source =
    yamlFormat.generate "pnpm-config" conf;
}
