{ config, pkgs, sops-nix, ... }:
let
  ageKeyFilePath =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/sops/age/keys.txt"
    else
      ".config/sops/age/keys.txt";
in
{
  imports = [ sops-nix.homeManagerModule ];

  sops.defaultSopsFile = ../secrets/john/secrets.yaml;
  sops.age.keyFile = "${config.home.homeDirectory}/${ageKeyFilePath}";
}
