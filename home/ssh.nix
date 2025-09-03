{ config, ... }:
{
  programs.ssh.enable = true;
  programs.ssh = {
    enableDefaultConfig = false;
    
    includes = [
      "${config.home.homeDirectory}/.colima/ssh_config"
    ];
    
    matchBlocks."*" = {
      addKeysToAgent = "yes";
      forwardAgent = false;
      compression = false;
      serverAliveInterval = 0;
      serverAliveCountMax = 3;
      hashKnownHosts = false;
      userKnownHostsFile = "~/.ssh/known_hosts";
      controlMaster = "no";
      controlPath = "~/.ssh/master-%r@%n:%p";
      controlPersist = "no";

      extraOptions = {
        UseKeychain = "yes";
      };
    };
  };
}
