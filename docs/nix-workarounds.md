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

### tmux: 3.7c configure fails on darwin without an explicit jemalloc choice

- **Added:** 2026-08-24
- **Root cause:** tmux 3.7c added a hard gate to its `configure` on macOS — it
  errors with `configure: error: must give --enable-jemalloc or
  --disable-jemalloc` unless one of those flags is passed, because macOS
  `calloc(3)` does not reliably zero allocations. The tmux derivation in the
  locked nixpkgs (nixos-unstable, `c8f9065`) passes neither, so every `tmux`
  build fails, which in turn fails `home-manager-path` and the whole
  `darwin-system`. nixpkgs master already carries the fix; nixos-unstable had
  not caught up as of this upgrade.
- **Workaround:** Overlay adds `jemalloc` to `buildInputs` and
  `--enable-jemalloc` to `configureFlags`, mirroring what nixpkgs master's
  `pkgs/by-name/tm/tmux/package.nix` does (both gated on darwin there; this
  config is darwin-only so the overlay is unconditional).
- **Files:** `overlays/tmux-darwin-jemalloc.nix`, wired in `flake.nix`.
- **Remove when:** the locked nixpkgs ships a tmux whose `configureFlags`
  already include `--enable-jemalloc`. To test: delete
  `overlays/tmux-darwin-jemalloc.nix`, remove its line from `flake.nix`, and run
  `just build` — if tmux builds, upstream is fixed and this entry goes too. To
  check without a full build:
  `nix eval --impure --json --expr 'let f = builtins.getFlake "/Users/john/.config/nix-config"; in f.inputs.nixpkgs.legacyPackages.aarch64-darwin.tmux.configureFlags'`
  — if `--enable-jemalloc` is already in that list, the overlay is redundant.
