# Temporary overlay to fix fish build on Darwin by disabling tests
# Issue: https://github.com/NixOS/nixpkgs/issues/461406
# Fix PR: https://github.com/NixOS/nixpkgs/pull/462090
# Remove this overlay once the fix reaches nixpkgs-unstable
{ inputs }:

final: prev: {
  fish = prev.fish.overrideAttrs (oldAttrs: {
    # Disable tests on Darwin until PR #462090 reaches unstable
    doCheck = !prev.stdenv.isDarwin;
  });
}
