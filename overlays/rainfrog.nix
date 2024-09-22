{ ... }: final: prev:
let
  version = "0.2.3";
  src = final.fetchFromGitHub {
    owner = "achristmascarl";
    repo = "rainfrog";
    rev = "v${version}";
    sha256 = "sha256-2eadWYQbCRd9HkTvzwMo6qeCoFB6359TUpLFY5wkl7s=";
  };
in
{
  rainfrog = final.rustPlatform.buildRustPackage {
    pname = "rainfrog";
    inherit src version;

    cargoLock = {
      lockFile = "${src}/Cargo.lock";
    };

    nativeBuildInputs = [

      # pkgs.cmake
      # pkgs.pkg-config
      # pkgs.perl
      # pkgs.protobuf
    ];

    buildInputs = [
      final.darwin.apple_sdk.frameworks.Cocoa
      # pkgs.libcxxabi
    ];
  };
}
