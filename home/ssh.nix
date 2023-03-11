{ config, ... }:
{
  programs.ssh.enable = true;
  programs.ssh = {
    extraConfig = ''
      AddKeysToAgent yes
      UseKeychain yes
    '';

    includes = [
      "${config.home.homeDirectory}/.colima/ssh_config"
    ];
  };
}
