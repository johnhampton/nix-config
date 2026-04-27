# Personal Homebrew tap for cask downgrades

**Date:** 2026-04-27
**Status:** Approved
**Repo to be created:** `johnhampton/homebrew-downgrades` (public, GitHub)

## Background

Homebrew casks are single-version artifacts. Since 2025 Homebrew has rejected URL-based and bare-file cask installs as a security measure, removing the previously-common downgrade tricks. The only supported path to install a non-current cask version is a tap.

A previous downgrade (Claude Code 2.1.119 → 2.1.118) used a purely local tap created with `brew tap-new john/downgrades`. The recipe is documented at `~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Big Brain/raw/processed/2026-04/2026-04-24-0949-downgrade-homebrew-cask.md` and is the basis for this design.

This spec promotes the local tap to a public GitHub-backed tap so:

- The workflow is reproducible across machines (`brew tap johnhampton/downgrades` from anywhere).
- A committed `bin/add-downgrade` helper script replaces the manual recipe.
- A README turns the repo into a self-explanatory artifact rather than a private brew internals dir.

The immediate driver is downgrading `claude-code@latest` from 2.1.120 to 2.1.119.

## Scope

In scope:

- Create the public GitHub repo `johnhampton/homebrew-downgrades`.
- Commit a `bin/add-downgrade` helper script and `README.md`.
- Use the helper to generate the first cask file: `claude-code@2.1.119.rb`.
- Swap the local install: uninstall `claude-code@latest`, install the pinned `@2.1.119`.

Out of scope:

- Automated tests for the helper script.
- CI / GitHub Actions on the tap.
- Multi-cask migration of any other currently-installed software.
- Auto-commit / auto-push from the helper script.

## Architecture

### Repo layout

```
homebrew-downgrades/
  README.md
  bin/add-downgrade
  Casks/c/claude-code@2.1.119.rb
```

The Homebrew tap convention requires the GitHub repo to be named `homebrew-<name>`, which lets users invoke `brew tap johnhampton/downgrades` (Homebrew expands the short name to the `homebrew-` prefixed repo).

### Working copy location

The working copy lives at the standard tap path returned by `brew --repo johnhampton/downgrades`, i.e. `/opt/homebrew/Library/Taps/johnhampton/homebrew-downgrades`. Edits, commits, and pushes happen directly from there. There is no separate clone elsewhere on disk.

Rationale: a single-user single-machine personal tap doesn't benefit from a second working copy. The only place Homebrew reads the cask `.rb` files is the tap directory, so editing in place removes a sync step.

### Cask renaming strategy (preserved from the previous recipe)

Each downgraded cask is renamed inside its `.rb` to carry a version suffix:

```ruby
# original
cask "claude-code@latest" do
  version "2.1.119"
  ...
# renamed
cask "claude-code@2.1.119" do
  version "2.1.119"
  ...
```

The renamed cask has no counterpart in the official Homebrew tap, so `brew upgrade` cannot accidentally upgrade it. To move forward later, install a different versioned cask from this tap or reinstall the original name from the official tap.

## Component: `bin/add-downgrade`

### Signature

```
bin/add-downgrade <cask-name> <version>
```

Examples:

```
bin/add-downgrade claude-code@latest 2.1.119
bin/add-downgrade visual-studio-code 1.95.0
```

### Behavior

1. **Validate inputs.** Require both arguments; fail with usage message if missing. Reject obviously bad values (empty string, version containing whitespace).
2. **Resolve cask file path.** `Casks/<first-letter-of-cask>/<cask>.rb`. URL-encode `@` as `%40` for the GitHub API query.
3. **Find commit SHA.** Query `https://api.github.com/repos/Homebrew/homebrew-cask/commits?path=Casks/<letter>/<encoded-cask>.rb&per_page=50` via `gh api --jq` (or curl + minimal JSON extraction). The matching commit is the one whose message is exactly `<cask> <version>`. Fail if not found.
4. **Fetch the raw `.rb`.** `curl -fsSL https://raw.githubusercontent.com/Homebrew/homebrew-cask/<sha>/Casks/<letter>/<cask>.rb`. Fail loudly on non-2xx.
5. **Rename the cask.** `sed 's/cask "<cask>"/cask "<cask>@<version>"/'`.
6. **Write to the tap.** Output path: `<repo-root>/Casks/<letter>/<cask>@<version>.rb`. Repo root is computed relative to the script's own location (so it works regardless of cwd).
7. **Print next steps.** Suggested `git add` / `git commit` message / `brew install` command.

### Non-behavior

- **Does not auto-commit or push.** User reviews the diff first. The early runs may surface issues with the cask file (a unique format, an unexpected dependency line) that are easier to catch before committing.
- **Does not remove existing pinned versions.** Each `add-downgrade` call adds one cask file.

### Dependencies

bash, curl, sed, and `gh` (already authenticated on this machine — used for `gh api` to avoid GitHub rate limits and for cleaner JSON extraction via `--jq`). No `jq` binary required.

### Error handling

- Missing args → usage to stderr, exit 1.
- Cask file path not found in API results → "no commits found for `<cask>.rb`", exit 1.
- No commit message matching `<cask> <version>` in the first 50 results → "version <version> not found in last 50 commits for <cask>; try increasing per_page or check the cask name", exit 1.
- curl non-2xx → "failed to fetch raw .rb at <sha>", exit 1.
- Output file already exists → refuse to overwrite, exit 1 (force flag out of scope).

### Testing

Manual verification: run the script, inspect the generated `.rb`, install the cask, launch the app. No automated tests — the script is short, single-user, and any breakage is caught by the install step.

## Bootstrap (one-time)

1. `gh repo create johnhampton/homebrew-downgrades --public --description "Personal Homebrew tap for pinning casks to specific older versions"`
2. `brew tap-new johnhampton/downgrades` — scaffolds the tap at `/opt/homebrew/Library/Taps/johnhampton/homebrew-downgrades` with a basic structure.
3. Add `bin/add-downgrade` (executable) and `README.md` in the tap directory.
4. Run `bin/add-downgrade claude-code@latest 2.1.119` to generate the first cask file.
5. Inspect the generated `Casks/c/claude-code@2.1.119.rb`.
6. `git remote add origin git@github.com:johnhampton/homebrew-downgrades.git` (or https — use whatever `gh` is configured for).
7. Commit (one or more conventional commits — at minimum "initial commit" and "add claude-code@2.1.119") and push.
8. Swap the local install:
   ```
   brew uninstall --cask claude-code@latest
   brew install --cask johnhampton/downgrades/claude-code@2.1.119
   ```
9. Verify: `brew list --cask --versions | grep claude-code` shows `2.1.119`, and the Claude Code app launches.

## Per-downgrade workflow (going forward)

1. `cd "$(brew --repo johnhampton/downgrades)"`
2. `bin/add-downgrade <cask-name> <version>`
3. Review the generated `.rb`, `git add`, `git commit -m "add <cask>@<version>"`, `git push`.
4. `brew uninstall --cask <cask-name> && brew install --cask johnhampton/downgrades/<cask-name>@<version>`.

## README contents

- One-paragraph description: what this tap is, why it exists (Homebrew removed URL/local-file cask installs in 2025; renamed casks block `brew upgrade` collisions).
- Quick start: `brew tap johnhampton/downgrades`.
- Currently pinned versions: a manual table of cask name → version → date pinned. (Auto-derivable from `Casks/`, but a flat list is plenty for now.)
- Usage of `bin/add-downgrade` with one worked example.
- Caveats: no auto-upgrade, manual maintenance, intentionally breaks `brew upgrade` for the pinned cask.

## Decisions and tradeoffs

- **Working copy is the tap directory itself.** Rejected: separate clone + push + `brew tap` mirror. The mirror approach has no benefit for a personal tap and adds a sync step.
- **No auto-commit in `add-downgrade`.** Rejected: auto-commit + auto-push. Accepted small friction (typing one commit message) in exchange for a guaranteed review before publishing.
- **`bin/add-downgrade` lives in the tap repo, not in nix-config.** The script operates on the tap; co-locating reduces context switching. A public repo with a working script is also more useful to anyone who finds it than one without.
- **Uses `gh api` rather than raw curl + grep.** `gh` is already authenticated on the machine, avoids rate limits, and supports `--jq` for clean JSON extraction without requiring a `jq` install.
- **No CI on the tap.** GitHub Actions on a personal tap with three commits a year would be ceremony for ceremony's sake. Add later if usage grows.
