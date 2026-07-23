---
name: workaround
description: This skill should be used when the user asks to "add a workaround", "record a workaround", "track a workaround", invokes /workaround, or when patching around upstream breakage (nixpkgs, nix-darwin, home-manager, a flake input) with a temporary override/patch that should be removed once upstream ships a fix.
---

# Add a Workaround

## Overview

Record a **temporary** patch or override for upstream breakage so a future
`nix-flake-upgrade` knows to try removing it. Every workaround has two synced
halves: a code-site comment and an entry in `docs/nix-workarounds.md`. Create
both, or the workaround becomes permanent by forgetting.

## When this applies

Use this only for **temporary** patches that exist because upstream is broken —
an overlay override, a pin to a newer/older version, a disabled option, a patch
file. It is a candidate for removal once upstream is fixed.

Do **not** use it for permanent config choices (those are just normal config).
If you can't state a concrete "remove when" condition, it isn't a workaround.

## Steps

### 1. Get today's date

Run `date +%Y-%m-%d` — do not guess. Use it as `YYYY-MM-DD` in both halves below.

### 2. Leave a code-site comment

At the code that implements the workaround (the overlay, the disabled option,
the pin), add a comment that names the root cause and points back to the doc:

```nix
# WORKAROUND(YYYY-MM-DD): <one-line root cause>. <what this does>.
# Drop this once <remove-when condition>. See docs/nix-workarounds.md.
```

Keep the code comment and the doc entry in sync — when one is removed, so is the
other.

### 3. Add an entry to docs/nix-workarounds.md

Add a new `###` subsection under `## Active workarounds`, matching the existing
entries' shape:

```markdown
### <package/component>: <short problem summary>

- **Added:** YYYY-MM-DD
- **Root cause:** <what upstream does that breaks, with specifics>.
- **Workaround:** <what the override/patch does>.
- **Files:** <file paths>, wired in `flake.nix` (if applicable).
- **Remove when:** <concrete upstream condition>. To test: <exact steps —
  usually "remove the override and `just build`", plus how to confirm>.
```

The **Remove when** line must be concrete and testable — a version bound
(`nixpkgs ships foo >= X`), a renamed flag, a dropped packaging step — not
"when upstream fixes it".

### 4. Verify it builds and stage the files

- If the workaround changed what gets built, run `just build` (background it;
  full rebuilds can exceed 10 minutes) and confirm it succeeds.
- Stage the specific files by name — the code site, `docs/nix-workarounds.md`,
  and `flake.nix` if the overlay is wired there. **Never `git add -A`/`.`**
- Nix flake rule: every referenced file (new overlays included) must be staged
  or committed before building, or the flake won't see it.

### 5. Commit

Commit the workaround and its doc entry together, Conventional Commits style
(e.g. `feat(nix): pin foo to X via overlay` or `fix(nix): work around foo build`).
The commit body should state the root cause and the remove-when condition.

## Removing a workaround later

`nix-flake-upgrade` handles this: after updating the lock file it reverts each
active workaround, rebuilds, and if the build still passes deletes both halves
(code site + doc entry). To remove one manually, do the same — revert, `just
build`, and if green delete the code and its `docs/nix-workarounds.md` entry.
