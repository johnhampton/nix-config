{ pkgs, age, ... }:
{
  home.packages = [ pkgs.cachix ];

  nix.settings = {
    extra-substituters = [ "https://tan.cachix.org" ];
    extra-trusted-public-keys = [ "tan.cachix.org-1:y9VYkIo4aZD4oK1wM/mYppPK0Pt//FMmTIyPcT6sbcs=" ];
    netrc-file = age.secrets.nix-netrc.path;
  };

  xdg.configFile."cachix/cachix.dhall".text = ''
    { authToken = ${age.secrets.cachix-authtoken.path}
    , hostname = "https://cachix.org"
    , binaryCaches = [] : List { name : Text, secretKey : Text }
    }
  '';
}
