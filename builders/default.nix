{ config, ... }: {

  imports = [ ./darwin.builder.nix ./nixbuild.nix ];

  nix = {
    distributedBuilds = true;
    extraOptions = ''
      builders-use-substitutes = true
    '';
  };
}
