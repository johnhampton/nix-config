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
      "aider"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adobe-creative-cloud"
      "anki"
      "artisan"
      "backblaze"
      "brave-browser"
      "chatgpt"
      {
        name = "chromium";
        args = { no_quarantine = true; };
      }
      "dropbox"
      "element"
      "expressvpn"
      "google-drive"
      "figma"
      "insomnia"
      "logi-options+"
      "logitune"
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
      "Balatro+" = 6502451661;
      "Be Focused Pro - Focus Timer" = 961632517;
      "Bear: Markdown Notes" = 1091189122;
      "Evernote" = 406056744;
      LimeChat = 414030210;
      Magnet = 441258766;
      "MindNode - Classic" = 1289197285;
      "NordVPN: VPN Fast & Secure" = 905953485;
      "Notion Web Clipper" = 1559269364;
      "Save to Raindrop.io" = 1549370672;
      "Session - Pomodoro Focus Timer" = 1521432881;
      "Todoist: To-Do List & Tasks" = 585829637;
      Xcode = 497799835;
      "Raycast Companion" = 6738274497;
    };
  };
}
