{ ... }: {
  nix = {
    buildMachines = [
      {
        hostName = "ssh-ng://builder@localhost";
        system = "aarch64-linux";
        sshKey = "/etc/nix/builder_ed25519";
        supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        maxJobs = 4;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
      }
    ];
  };
}
     
