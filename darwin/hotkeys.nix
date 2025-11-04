{ ... }: {
  system.activationScripts.extraActivation.text =
    let
      keys = {
        "118" = { keyCode = 18; asciiCode = 49; }; # ⌘⌥1 to switch to Desktop 1
        "119" = { keyCode = 19; asciiCode = 50; }; # ⌘⌥2 to switch to Desktop 2
        "120" = { keyCode = 20; asciiCode = 51; }; # ⌘⌥3 to switch to Desktop 3
        "79" = { keyCode = 123; asciiCode = 65535; }; # ⌘⌥← to move left a space
        "81" = { keyCode = 124; asciiCode = 65535; }; # ⌘⌥→ to move right a space
        "27" = { keyCode = 8; asciiCode = 99; }; # Hyper+C to move focus to next window
        "32" = { keyCode = 126; asciiCode = 65535; }; # ⌘⌥↑ Mission Control
        "33" = { keyCode = 125; asciiCode = 65535; }; # ⌘⌥↓ Application Windows
      };

      enableHotKeysCommands = builtins.map
        (key:
          let
            keyInfo = keys.${key};
            # Use different modifiers based on key type:
            # - Hyper (1966080) for key 27
            # - Cmd+Option (1572864) for desktop switching and arrow keys
            modifier = if key == "27" then "1966080" else "1572864";
            asciiCode = toString keyInfo.asciiCode;
          in
          ''
                sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '
            		<dict>
            			<key>enabled</key>
            			<true/>
            			<key>value</key>
            			<dict>
            				<key>parameters</key>
            				<array>
            					<integer>${asciiCode}</integer>
            					<integer>${toString keyInfo.keyCode}</integer>
            					<integer>${modifier}</integer>
            				</array>
            				<key>type</key>
            				<string>standard</string>
            			</dict>
            		</dict>'
          '')
        (builtins.attrNames keys);

      # Disable Spotlight shortcuts
      disableSpotlightCommands = [
        # Key 64: Show Spotlight search (Cmd+Space)
        ''
          sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '<dict><key>enabled</key><false/></dict>'
        ''
        # Key 65: Show Finder search window (Cmd+Option+Space)
        ''
          sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 '<dict><key>enabled</key><false/></dict>'
        ''
      ];

      # Disable unused desktop switching shortcuts (4-9)
      disableUnusedDesktopCommands = builtins.map
        (key: ''
          sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '<dict><key>enabled</key><false/></dict>'
        '')
        ["121" "122" "123" "124" "125" "126"];

      # Disable alternate space navigation shortcuts (Control+Option+Arrow)
      disableAlternateSpaceCommands = builtins.map
        (key: ''
          sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '<dict><key>enabled</key><false/></dict>'
        '')
        ["80" "82"];

      # Disable screenshot shortcuts
      disableScreenshotCommands = builtins.map
        (key: ''
          sudo -u john defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '<dict><key>enabled</key><false/></dict>'
        '')
        [
          "28"   # Cmd-Shift-3: Save picture of screen as a file
          "29"   # Ctrl-Cmd-Shift-3: Copy picture of screen to the clipboard
          "30"   # Cmd-Shift-4: Save picture of selected area as a file
          "31"   # Ctrl-Cmd-Shift-4: Copy picture of selected area to the clipboard
          "184"  # Cmd-Shift-5: Screenshot and recording options
        ];

    in
    ''
       echo >&2 "configuring hotkeys..."

      ${builtins.concatStringsSep "\n" enableHotKeysCommands}
      
      echo >&2 "disabling spotlight shortcuts..."
      ${builtins.concatStringsSep "\n" disableSpotlightCommands}
      
      echo >&2 "disabling unused desktop shortcuts..."
      ${builtins.concatStringsSep "\n" disableUnusedDesktopCommands}
      
      echo >&2 "disabling alternate space navigation shortcuts..."
      ${builtins.concatStringsSep "\n" disableAlternateSpaceCommands}
      
      echo >&2 "disabling screenshot shortcuts..."
      ${builtins.concatStringsSep "\n" disableScreenshotCommands}
      
      # echo >&2 "activating settings..."
      # sudo -u john /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

}
