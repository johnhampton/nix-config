{ config, ... }:
{
  programs.ssh.enable = true;
  programs.ssh = {
    enableDefaultConfig = false;
    
    includes = [
      "${config.home.homeDirectory}/.colima/ssh_config"
    ];
    
    settings."*" = {
      AddKeysToAgent = "yes";
      ForwardAgent = false;
      Compression = false;
      ServerAliveInterval = 0;
      ServerAliveCountMax = 3;
      HashKnownHosts = false;
      UserKnownHostsFile = "~/.ssh/known_hosts";
      ControlMaster = "no";
      ControlPath = "~/.ssh/master-%r@%n:%p";
      ControlPersist = "no";
      UseKeychain = "yes";
    };
  };
}
