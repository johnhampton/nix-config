{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../builders
    ./homebrew.nix
    ./hotkeys.nix
    ./yabai.nix
  ];

  nix.enable = true;
  nix.package = pkgs.nixVersions.nix_2_24;
  nix.settings = {
    download-buffer-size = 268435456;
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

    extra-platforms = lib.mkIf (pkgs.system == "aarch64-darwin") [ "x86_64-darwin" "aarch64-darwin" ];
  };

  services.lorri.enable = false;
  services.lorri.logFile = "/var/tmp/lorri.log";

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
}
