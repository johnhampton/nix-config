{ inputs, config, pkgs, lib, ... }:
{
  nix.settings = {
    substituters = [
      "https://cache.nixos.org/"
      "https://hydra.iohk.io"
      "https://cache.iog.io"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    trusted-users = [
      "john"
      "@admin"
    ];
    auto-optimise-store = true;

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    keep-outputs = true;
    keep-derivations = true;
    access-tokens = [ "github.com=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" ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
  };

  nix.configureBuildUsers = true;

  nix.package = pkgs.nixUnstable;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;


  system.stateVersion = 4;



  programs.fish.enable = true;
  programs.zsh.enable = true;
}
