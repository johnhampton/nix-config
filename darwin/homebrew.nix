{ ... }:
{
  homebrew.enable = true;
  homebrew = {
    onActivation = {
      autoUpdate = false;
      cleanup = "uninstall";
      upgrade = true;
    };

    global = {
      autoUpdate = false;
    };

    taps = [
      "txn2/tap"
    ];

    brews = [
      "txn2/tap/kubefwd"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adobe-creative-cloud"
      "anki"
      "artisan"
      "brave-browser"
      "dropbox"
      "element"
      "expressvpn"
      "google-drive"
      "insomnia"
      "logi-options-plus"
      "logseq"
      "mimestream"
      "notion"
      "obsidian"
      "raindropio"
      "raycast"
      "skype"
      "slack"
      "tableplus"
      "tuple"
      "zoom"
    ];

    masApps = {
      "Todoist: To-Do List & Tasks" = 585829637;
      "1Password for Safari" = 1569813296;
      "Amazon Kindle" = 302584613;
      Magnet = 441258766;
      "Notion Web Clipper" = 1559269364;
      "Save to Raindrop.io" = 1549370672;
      Xcode = 497799835;
      LimeChat = 414030210;
    };
  };
}
