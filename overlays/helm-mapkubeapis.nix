{ ... }:
final: prev:
let
  version = "0.4.1";
  src = final.fetchFromGitHub {
    owner = "helm";
    repo = "helm-mapkubeapis";
    sha256 = "sha256-6NeePXTdp5vlBLfIlWeXQZMZ0Uz/e1ZCgZmJvBJfaFw=s";
    rev = "v${version}";
  };
in
{
  kubernetes-helmPlugins = prev.kubernetes-helmPlugins // {
    helm-mapkubeapis =
      let
        pname = "helm-mapkubeapis";
      in
      final.buildGoModule {
        inherit pname src version;
        vendorHash = "sha256-rVrQqeakPQl3rjzmqzHw74ffreLEVzP153wWJ8TEOIM=";

        ldflags = [ "-s" "-w" "-X main.Version=${version}" ];
        subPackages = [ "cmd/mapkubeapis" ];
        env.CGO_ENABLED = 0;

        # NOTE: Remove the install and upgrade hooks.
        postPatch = ''
          sed -i '/^hooks:/,+2 d' plugin.yaml
        '';

        postInstall = ''
          install -dm755 $out/${pname}
          install -dm755 $out/${pname}/config
          mv $out/bin $out/${pname}/
          install -m644 -Dt $out/${pname} plugin.yaml
          install -m644 -Dt $out/${pname}/config config/Map.yaml
        '';
      };
  };
}
