{ ... }: {
  nix = {
    linux-builder.enable = true;
    linux-builder = {
      maxJobs = 4;
      modules = [
        ({ ... }: {
          virtualisation.darwin-builder.memorySize = 8192;
        })
      ];
    };
  };
}
     
