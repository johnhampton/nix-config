{ ... }:
{
  homebrew.enable = true;
  homebrew = {
    onActivation.cleanup = "uninstall";

    casks = [
      "1password"
      "1password-cli"
      "dropbox"
      "logseq"
      "notion"
      "raindropio"
      "raycast"
      "slack"
      "zoom"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Notion Web Clipper" = 1559269364;
      "Save to Raindrop.io" = 1549370672;
      Xcode = 497799835;
    };
  };
}
