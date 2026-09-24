final: prev:
{
  # WORKAROUND(2026-09-24): pinned nixpkgs only ships Worktrunk 0.74.0. Pin 0.79.0.
  # Drop once nixpkgs ships >=0.79.0. See docs/nix-workarounds.md.
  worktrunk = prev.worktrunk.overrideAttrs (finalAttrs: _: {
    version = "0.79.0";
    src = prev.fetchFromGitHub {
      owner = "max-sixty";
      repo = "worktrunk";
      tag = "v${finalAttrs.version}";
      hash = "sha256-wOTNqyBd+qw+fREbY52BKtBod0Y50OHRKdHAGljXNuc=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) src;
      hash = "sha256-S8W13psL288D1iVux70N5UzBdvHLNemMJx9G6bh7+K4=";
    };
  });
}
