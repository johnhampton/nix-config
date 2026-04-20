{ pkgs, lib, ... }:
let
  isAarch64 = pkgs.stdenv.hostPlatform.isAarch64;
in
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

    brews = [
      "kubefwd"
    ];

    casks = [
      "1password"
      "1password-cli"
      "adobe-creative-cloud"
      "anki"
      "artisan"
      "backblaze"
      "brave-browser"
      "capacities"
      "citrix-workspace"
      "claude"
      "claude-code@latest"
      "discord"
      "dropbox"
      "element"
      "google-chrome"
      "google-drive"
      "figma"
      "insomnia"
      "libreoffice"
      "logi-options+"
      "logitune"
      "logseq"
      "mimestream"
      "notion"
      "obsidian"
      "parallels"
      "raindropio"
      "raycast"
      "slack"
      "tableplus"
      "tailscale-app"
      "tuple"
      "wezterm@nightly"
      "wispr-flow"
      "zoom"
    ]
    ++ lib.optionals isAarch64 [
      "chatgpt"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Amazon Kindle" = 302584613;
      "Balatro+" = 6502451661;
      "Capacities Web Extension" = 6502697899;
      "Be Focused Pro - Focus Timer" = 961632517;
      "Bear: Markdown Notes" = 1091189122;
      Drafts = 1435957248;
      # "Evernote" = 406056744;
      LimeChat = 414030210;
      Magnet = 441258766;
      "MindNode - Classic" = 1289197285;
      "NordVPN: VPN Fast & Secure" = 905953485;
      "Notion Web Clipper" = 1559269364;
      "Obsidian Web Clipper" = 6720708363;
      "Raycast Companion" = 6738274497;
      "Save to Raindrop.io" = 1549370672;
      "Session - Pomodoro Focus Timer" = 1521432881;
      "TickTick:To-Do List, Calendar" = 966085870;
      "Todoist: To-Do List & Tasks" = 585829637;
      Xcode = 497799835;
    };
  };
}
