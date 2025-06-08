{ ... }: {
  system.activationScripts.extraActivation.text =
    let
      keys = {
        "118" = 18; # ^1 to switch to Desktop 1
        "119" = 19; # ^2 to switch to Desktop 2
        "120" = 20; # ^3 to switch to Desktop 3
        "121" = 21; # ^4 to switch to Desktop 4
        "122" = 23; # ^5 to switch to Desktop 5
        "123" = 22; # ^6 to switch to Desktop 6
        "124" = 26; # ^7 to switch to Desktop 7
        "125" = 28; # ^8 to switch to Desktop 8
        "126" = 25; # ^9 to switch to Desktop 9
        "27" = 8; # Hyper+C to move focus to next window
      };

      enableHotKeysCommands = builtins.map
        (key:
          let
            value = keys.${key};
            # Use Hyper modifier for key 27, Control modifier for others
            modifier = if key == "27" then "1966080" else "262144";
            # Use ASCII code 99 for 'c' on key 27, 65535 for Control+number shortcuts
            asciiCode = if key == "27" then "99" else "65535";
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
            					<integer>${toString value}</integer>
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

    in
    ''
       echo >&2 "configuring hotkeys..."

      ${builtins.concatStringsSep "\n" enableHotKeysCommands}
      
      echo >&2 "disabling spotlight shortcuts..."
      ${builtins.concatStringsSep "\n" disableSpotlightCommands}
      
      # echo >&2 "activating settings..."
      # sudo -u john /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

}
