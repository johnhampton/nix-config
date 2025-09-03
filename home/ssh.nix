{ config, ... }:
{
  programs.ssh.enable = true;
  programs.ssh = {
    enableDefaultConfig = false;
    
    extraConfig = ''
      AddKeysToAgent yes
      UseKeychain yes
    '';

    includes = [
      "${config.home.homeDirectory}/.colima/ssh_config"
    ];
    
    matchBlocks."*" = {
      extraOptions = {
        # Add any default options you want to keep from the default config here
      };
    };
  };
}
