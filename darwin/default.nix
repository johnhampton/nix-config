{ pkgs, lib, ... }:
{
  imports = [
    ../builders
    ./homebrew.nix
    ./hotkeys.nix
    ./yabai.nix
  ];

  nix.enable = true;
  nix.package = pkgs.nixVersions.nix_2_28;
  nix.settings = {
    download-buffer-size = 1073741824; # 1024MB
    trusted-users = [
      "john"
      "@admin"
    ];

    auto-optimise-store = false;

    experimental-features = [
      "ca-derivations"
      "nix-command"
      "flakes"
    ];
    builders-use-substitutes = true;

    keep-outputs = true;
    keep-derivations = true;

    extra-platforms = lib.mkIf (pkgs.stdenv.hostPlatform.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
  };

  nix.gc = {
    automatic = true;
    interval = { Weekday = 7; Hour = 3; Minute = 0; }; # Sunday at 3:00 AM
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  services.lorri.enable = false;
  services.lorri.logFile = "/var/tmp/lorri.log";

  system.primaryUser = "john";
  system.stateVersion = 4;
  system.defaults = {
    NSGlobalDomain = {
      "com.apple.keyboard.fnState" = true;
    };

    dock = {
      autohide = true;
      mru-spaces = false;
    };

    WindowManager = {
      AppWindowGroupingBehavior = false; # "One at a time" for Stage Manager
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
    shell = pkgs.zsh;
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
    env = {
      file = ../secrets/env.age;
      path = "/Users/john/.env";
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
      mode = "600";
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
    pgpass = {
      file = ../secrets/pgpass.age;
      path = "/Users/john/.pgpass";
      mode = "600";
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

  # System-wide packages
  environment.systemPackages = with pkgs; [
    nodejs
  ];
}
