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

### graphite-cli: empty shell completions break the Darwin build

- **Added:** 2026-07-06
- **Root cause:** nixpkgs `graphite-cli` 1.8.6's Darwin `postInstall` runs
  `gt completion` to generate a bash completion file, but that command emits
  empty output, so `installShellCompletion` fails with
  `gt.bash ... does not exist or has zero size`.
- **Workaround:** `overlays/graphite-cli-fix.nix` overrides `postInstall = ""`
  to skip completion generation. The `gt` binary is unaffected.
- **Files:** `overlays/graphite-cli-fix.nix`, wired in `flake.nix`.
- **Remove when:** a newer nixpkgs `graphite-cli` fixes `gt completion` (or the
  packaging drops the run-the-binary completion step). To test: temporarily
  remove the overlay import from `flake.nix` and `just build`.

### nix-darwin HTML manual: `nixos-render-docs --toc-depth` removed

- **Added:** 2026-07-06
- **Root cause:** nix-darwin `a1fa429` (`doc/manual/default.nix`) invokes
  `nixos-render-docs manual html --toc-depth 1`, but the updated nixpkgs
  `nixos-render-docs` removed `--toc-depth` (renamed to `--sidebar-depth`), so
  `darwin-manual-html` fails with
  `--toc-depth has been removed, use --sidebar-depth instead`.
- **Workaround (two references, both suppressed in `darwin/default.nix`):**
  1. `documentation.doc.enable = false` — drops our config's own HTML manual
     (manpages stay on; the manpage builder doesn't use `--toc-depth`).
  2. `system.tools.darwin-uninstaller.enable = false` — `darwin-uninstaller`
     builds an internal default-config system (docs enabled) whose `system-path`
     also pulls in `darwin-manual-html`, and that nested system can't be
     reconfigured from our options.
- **Files:** `darwin/default.nix`.
- **Remove when:** nix-darwin renames the flag to `--sidebar-depth` (check
  `github:LnL7/nix-darwin` `doc/manual/default.nix`), OR nixpkgs
  `nixos-render-docs` restores `--toc-depth`. To test: re-enable both options
  and `just build`; if `darwin-manual-html` builds, the workaround is obsolete.

## Removed workarounds

_(none yet — move entries here with the date removed when upstream is fixed,
or just delete them; git history preserves the record.)_
