# Nix Workarounds

Temporary patches and overrides added to work around **upstream** breakage
(nixpkgs, nix-darwin, home-manager, flake inputs). Each entry is a candidate for
removal once upstream ships a fix.

**Check this file during every `nix-flake-upgrade`.** After the lock file is
updated but before merging, attempt to remove each workaround below and rebuild.
If the build still succeeds, upstream has fixed the issue — delete the workaround
in the same upgrade.

## How to add an entry

When you add a workaround, also:

1. Leave a `WORKAROUND(YYYY-MM-DD):` comment at the code site explaining the
   root cause and pointing back to this file.
2. Add a row here with enough detail to test removal later.

Keep the code comment and this file in sync; when you remove the workaround,
remove both.

## Active workarounds

### worktrunk: nixpkgs lags behind 0.68.0

- **Added:** 2026-07-23
- **Root cause:** nixpkgs packages `worktrunk` 0.66.0, but we need 0.68.0.
- **Workaround:** `overlays/worktrunk-0.68.nix` overrides the version and source
  to the `v0.68.0` GitHub tag and re-vendors the cargo dependencies with
  `rustPlatform.fetchCargoVendor` (nixpkgs's plain `cargoHash` can't be reached
  via `overrideAttrs`, so `cargoDeps` is rebuilt directly). Two new 0.68.0 unit
  tests that probe live process names/PIDs are also skipped via `checkFlags`
  (they can't pass in the Nix build sandbox).
- **Files:** `overlays/worktrunk-0.68.nix`, wired in `flake.nix`.
- **Remove when:** nixpkgs ships `worktrunk >= 0.68.0`. To test: temporarily
  remove the overlay import from `flake.nix` and check
  `nix eval --raw .#legacyPackages.aarch64-darwin.worktrunk.version` — if it is
  already `>= 0.68.0`, delete the overlay and this entry.
