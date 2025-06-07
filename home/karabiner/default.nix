{ pkgs, lib, ... }:

{
  # Karabiner-Elements configuration
  home.file.".config/karabiner/karabiner.json" = {
    source = ./karabiner.json;
    onChange = ''
      /bin/launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server
    '';
  };
}