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

_(none — all previously tracked workarounds have been resolved upstream and
removed. See git history for the record.)_
