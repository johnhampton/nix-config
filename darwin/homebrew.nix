{ ... }:
{
  homebrew.enable = true;
  homebrew = {
    onActivation.cleanup = "uninstall";
    taps = [
      "txn2/tap"
    ];
    brews = [
      "txn2/tap/kubefwd"
    ];
    casks = [
      "1password"
      "1password-cli"
      "artisan"
      "dropbox"
      "insomnia"
      "logseq"
      "mimestream"
      "notion"
      "raindropio"
      "raycast"
      "slack"
      "tableplus"
      "tuple"
      "zoom"
    ];
    masApps = {
      "1Password for Safari" = 1569813296;
      "Notion Web Clipper" = 1559269364;
      "Save to Raindrop.io" = 1549370672;
      Xcode = 497799835;
      LimeChat = 414030210;
    };
  };
}
