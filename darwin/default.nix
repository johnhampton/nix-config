{ inputs, config, pkgs, lib, ... }:
{

  imports = [ ./homebrew.nix ];
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


  # nix.distributedBuilds = true;
  # nix.buildMachines = [{
  #   hostName = "ssh-ng://builder@localhost";
  #   system = "x86_64-linux";
  #   maxJobs = 4;
  #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUpCV2N4Yi9CbGFxdDFhdU90RStGOFFVV3JVb3RpQzVxQkorVXVFV2RWQ2Igcm9vdEBuaXhvcwo=";
  #   sshKey = "/etc/nix/builder_ed25519";
  #
  # }];
  nix.configureBuildUsers = true;

  nix.package = pkgs.nixUnstable;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;

  users.users.john = {
    name = "john";
    description = "John Hampton";
    home = "/Users/john";
    shell = pkgs.fish;
  };

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
}
