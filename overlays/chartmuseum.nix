{ ... }: final: prev:
let
  version = "0.16.0";
  shortRev = "31cd02b";
  src = final.fetchFromGitHub {
    owner = "helm";
    repo = "chartmuseum";
    sha256 = "sha256-bo5jm5srOvoTXjxvxE8DRCsCHZyuu13b0jrC5GBUxU8=";
    rev = "v${version}";
  };
in
{
  chartmuseum = final.buildGoModule {
    inherit src version;
    pname = "chartmusuem";
    vendorHash = "sha256-zDwscYh5CTL6yEimvIkL/G+1FA8Ixwj0r4s7UUZiAi8=";
    doCheck = false;
    ldflags = [
      "-w"
      "-X main.Version=${version}"
      "-X main.Revision=${shortRev}"
    ];
  };
}
