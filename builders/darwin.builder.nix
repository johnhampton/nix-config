{ ... }: {
  nix = {
    linux-builder.enable = true;
    linux-builder = {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      maxJobs = 4;

      config = {
        virtualisation.darwin-builder.memorySize = 8192;
        virtualisation.darwin-builder.diskSize = 10240;
      };
    };
  };
}
