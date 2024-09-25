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
      "chatgpt"
      "dropbox"
      "element"
      "expressvpn"
      "google-drive"
      "insomnia"
      "logi-options+"
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
      "1Password for Safari" = 1569813296;
      "Amazon Kindle" = 302584613;
      "Be Focused Pro - Focus Timer" = 961632517;
      "Bear: Markdown Notes" = 1091189122;
      "Evernote" = 406056744;
      LimeChat = 414030210;
      Magnet = 441258766;
      "Notion Web Clipper" = 1559269364;
      "Save to Raindrop.io" = 1549370672;
      "Todoist: To-Do List & Tasks" = 585829637;
      Xcode = 497799835;
    };
  };
}
