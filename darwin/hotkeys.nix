{ ... }: {
  system.activationScripts.extraUserActivation.enable = true;
  system.activationScripts.extraUserActivation.text =
    let
      keys = {
        "118" = 18; # ^1 to switch to Desktop 1
        "119" = 19; # ^2 to switch to Desktop 2
        "120" = 20; # ^3 to switch to Desktop 3
        "121" = 21; # ^4 to switch to Desktop 4
        "122" = 23; # ^5 to switch to Desktop 5
        "123" = 22;
        "124" = 26;
        "125" = 28;
        "126" = 25;
      };

      enableHotKeysCommands = builtins.map
        (key:
          let value = keys.${key}; in ''
                defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${key} '
            		<dict>
            			<key>enabled</key>
            			<true/>
            			<key>value</key>
            			<dict>
            				<key>parameters</key>
            				<array>
            					<integer>65535</integer>
            					<integer>${toString value}</integer>
            					<integer>262144</integer>
            				</array>
            				<key>type</key>
            				<string>standard</string>
            			</dict>
            		</dict>'
          '')
        (builtins.attrNames keys);

    in
    ''
       echo >&2 "configuring hotkeys..."

      ${builtins.concatStringsSep "\n" enableHotKeysCommands}
    '';

}
