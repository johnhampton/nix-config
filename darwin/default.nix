{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../builders
    ./homebrew.nix
    ./hotkeys.nix
    ./yabai.nix
  ];

  nix.settings = {
    substituters = [
      "https://cache.iog.io"
    ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    ];

    trusted-users = [
      "john"
      "@admin"
    ];
    auto-optimise-store = true;

    experimental-features = [
      "ca-derivations"
      "nix-command"
      "flakes"
    ];
    builders-use-substitutes = true;

    keep-outputs = true;
    keep-derivations = true;
    # access-tokens = [ "github.com=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" ];

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
  };

  services.lorri.enable = false;
  services.lorri.logFile = "/var/tmp/lorri.log";

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
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      autohide = true;
      mru-spaces = false;
    };

    CustomUserPreferences = {
      NSGlobalDomain = {
        AppleSpacesSwitchOnActivate = 0;
      };
    };
  };
  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.zsh.enable = true;

  users.users.john = {
    name = "john";
    description = "John Hampton";
    home = "/Users/john";
    shell = pkgs.fish;
  };
  age.secrets = {
    access_token = {
      file = ../secrets/access_tokens.conf.age;
      mode = "700";
      owner = "john";
      group = "staff";
    };
    cachix-authtoken = {
      file = ../secrets/cachix-authtoken.dhall.age;
      mode = "700";
      owner = "john";
      group = "staff";
    };
    chatgpt = {
      file = ../secrets/chatgpt.age;
      mode = "700";
      owner = "john";
      group = "staff";
    };
    gh = {
      file = ../secrets/hosts.yml.age;
      path = "/Users/john/.config/gh/hosts.yml";
      mode = "700";
      owner = "john";
      group = "staff";
    };
    netrc = {
      file = ../secrets/netrc.age;
      path = "/Users/john/.netrc";
      mode = "700";
      owner = "john";
      group = "staff";
    };
    nix-netrc = {
      file = ../secrets/nix-netrc.age;
      mode = "700";
      owner = "john";
      group = "staff";
    };
    npmrc = {
      file = ../secrets/npmrc.age;
      path = "/Users/john/.npmrc";
      mode = "700";
      owner = "john";
      group = "staff";
    };
    ssh_key = {
      file = ../secrets/id_ed25519.age;
    };
  };
  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];
}
