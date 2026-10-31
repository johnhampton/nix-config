{ config, lib, ... }:
let
  control = 262144;
  hyper = 1966080;

  shortcut = asciiCode: keyCode: modifiers: {
    enabled = true;
    value = {
      type = "standard";
      parameters = [ asciiCode keyCode modifiers ];
    };
  };

  enabledShortcuts = {
    "118" = shortcut 49 18 control; # Control+1: Desktop 1
    "119" = shortcut 50 19 control; # Control+2: Desktop 2
    "120" = shortcut 51 20 control; # Control+3: Desktop 3
    "121" = shortcut 52 21 control; # Control+4: Desktop 4
    "122" = shortcut 53 23 control; # Control+5: Desktop 5

    # Keep the macOS defaults expected by Logi Options+ desktop gestures.
    "79" = shortcut 65535 123 control; # Control+Left: previous space
    "81" = shortcut 65535 124 control; # Control+Right: next space
    "32" = shortcut 65535 126 control; # Control+Up: Mission Control
    "33" = shortcut 65535 125 control; # Control+Down: Application Windows

    "27" = shortcut 99 8 hyper; # Hyper+C: focus the next window
  };

  disabledShortcuts = lib.genAttrs [
    "64" "65" # Spotlight and Finder search
    "123" "124" "125" "126" # Desktops 6–9
    "80" "82" # Alternate space navigation
    "28" "29" "30" "31" "184" # Screenshots and screen recording
  ] (_: { enabled = false; });

  user = lib.escapeShellArg config.system.primaryUser;
  writeShortcut = key: value:
    let
      plist = lib.escapeShellArg (lib.generators.toPlist { escape = true; } value);
    in
    ''
      /bin/launchctl asuser "$(/usr/bin/id -u -- ${user})" /usr/bin/sudo --user=${user} -- \
        /usr/bin/defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${lib.escapeShellArg key} ${plist}
    '';
in
{
  # CustomUserPreferences replaces the whole AppleSymbolicHotKeys dictionary.
  # Merge individual entries to preserve shortcuts managed by macOS and other apps.
  # Match nix-darwin's user-defaults handling: both the user identity and login session.
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    echo >&2 "configuring hotkeys..."
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList writeShortcut (enabledShortcuts // disabledShortcuts))}
  '';

  # Writing defaults does not reload WindowServer's active shortcuts. Refresh
  # after all user preferences have been written so a logout is not required.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo >&2 "reloading keyboard shortcuts..."
    /bin/launchctl asuser "$(/usr/bin/id -u -- ${user})" /usr/bin/sudo --user=${user} -- \
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
}
