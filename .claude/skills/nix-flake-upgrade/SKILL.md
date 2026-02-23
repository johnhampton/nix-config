---
name: nix-flake-upgrade
description: This skill should be used when the user asks to "upgrade flake", "update flake inputs", "update nix packages", "refresh the lock file", "run a flake update", or mentions upgrading nix-darwin/home-manager dependencies.
---

# Nix Flake Upgrade

## Overview

Orchestrate an end-to-end nix flake input upgrade: stash any working changes, create a dated upgrade branch, run `nix flake update --commit-lock-file`, build to verify the new inputs, merge back to master, and restore the stash. The entire workflow runs autonomously — only stop on failure.

## Autonomous Operation

**CRITICAL:** Execute the entire workflow without confirmation prompts. Do not ask "Should I proceed?" or "Is this okay?" at any step. Run each step, verify its result, and move to the next. Only stop when a step fails and cannot be automatically resolved.

## Workflow

### Step 0: Prepare Environment

1. Run `mkdir -p /tmp/claude` to ensure the sandbox temp directory exists (`just` writes temp files here and fails if it's missing).
2. All `just` and `nix` commands in this workflow **must** use `dangerouslyDisableSandbox: true` — nix requires write access to `~/.cache/nix/` for its SQLite fetcher cache and store operations.

### Step 1: Record Starting Branch and Stash Working Changes

1. Record the current branch name (`git branch --show-current`). This is the **starting branch** — it may or may not be `master`.
2. Check for a dirty working tree (`git status`). If there are uncommitted changes:
   - Generate a descriptive stash message: `pre-upgrade-YYYYMMDD: <brief description of changes>`
   - Run `git stash push -u -m "<message>"` — include `-u` to capture meaningful untracked files
   - Record that a stash was created (to restore in Step 5)
3. If the tree is clean, skip stashing and record that no restore is needed.

### Step 2: Switch to Master and Create Upgrade Branch

If not already on `master`, run `git checkout master` before creating the upgrade branch. The upgrade always targets master regardless of which branch was active.

Run `just update-branch` to create or switch to the `update-YYYYMMDD` branch.

**Edge case:** If the branch already exists with prior commits (e.g., a previous failed attempt), `just update-branch` will switch to it. Check the branch state — if it already contains a lock file update commit, consider whether to continue from there or start fresh. If starting fresh, reset to master before proceeding.

### Step 3: Update Flake Inputs

Run `just upgrade` (executes `nix flake update --commit-lock-file`).

This creates an auto-generated commit with the lock file changes. **Do not amend, rewrite, or alter this commit in any way.** Preserve the auto-generated commit message as-is.

### Step 4: Build to Verify

Run `just build` to compile the configuration with updated inputs.

- On **success**: proceed to Step 5
- On **failure**: enter the Failure Recovery procedure below

**CRITICAL:** Never run `just switch` — only `just build`. Activation is the user's decision.

### Step 5: Merge, Return to Starting Branch, and Finalize

1. `git checkout master`
2. `git merge --ff-only update-YYYYMMDD`
3. `git branch -d update-YYYYMMDD`
4. If the starting branch (from Step 1) is not `master`, run `git checkout <starting-branch>` to return the user to where they were
5. If a stash was created in Step 1, run `git stash pop`
6. Report results: list updated inputs, confirm build success, and tell the user to run `just switch` when ready to activate. If returning to a non-master branch, note that master has been upgraded and suggest rebasing if the branch is based on the old master

## Failure Recovery

When `just build` fails:

1. **Diagnose** — Read the build output carefully. Identify the failing derivation, package, or module.
2. **Attempt fixes** — Common fixes include:
   - Updating overlay pins or patches for API changes
   - Adjusting module options for renamed/removed settings
   - Adding missing inputs or overrides
3. **Stage and commit fixes** — Stage specific files by name, then use the `commit-message-writer` skill to create the fix commit. Ensure all referenced files are staged or committed before rebuilding (nix flake rule).
4. **Rebuild** — Run `just build` again. Repeat fix-rebuild cycles as needed.
5. **If unresolvable** — Report to the user with:
   - The exact error output
   - What was attempted
   - Recommendations for manual resolution

### Abandoning an Upgrade

If the upgrade cannot be completed:

1. `git checkout master`
2. `git branch -D update-YYYYMMDD` (force-delete since it won't merge cleanly)
3. If the starting branch is not `master`, run `git checkout <starting-branch>`
4. If a stash was created, run `git stash pop`
5. Report what happened and why

## Important Rules

- **Never use `git add -A` or `git add .`** — always stage specific files by name
- **Always use the `commit-message-writer` skill** for any fix commits created during failure recovery
- **Never run `just switch`** — only `just build` for verification
- **Never rewrite the lock file auto-commit** — preserve it exactly as generated
- **Stage or commit all files before building** — nix flakes require referenced files to be in git

## Examples

### Successful Run (from master)

```
$ git branch --show-current → master
$ git status → dirty tree with WIP changes
$ git stash push -u -m "pre-upgrade-20260208: wezterm config refactor"
$ just update-branch → created update-20260208
$ just upgrade → flake.lock updated, auto-commit created
$ just build → success
$ git checkout master
$ git merge --ff-only update-20260208
$ git branch -d update-20260208
$ git stash pop → WIP restored

Result: All inputs updated. Run `just switch` to activate.
```

### Successful Run (from feature branch)

```
$ git branch --show-current → feat/new-service
$ git status → dirty tree with WIP changes
$ git stash push -u -m "pre-upgrade-20260208: new service config"
$ git checkout master
$ just update-branch → created update-20260208
$ just upgrade → flake.lock updated, auto-commit created
$ just build → success
$ git checkout master
$ git merge --ff-only update-20260208
$ git branch -d update-20260208
$ git checkout feat/new-service → return to starting branch
$ git stash pop → WIP restored

Result: All inputs updated on master. Run `just switch` to activate.
Consider rebasing feat/new-service onto the updated master.
```

### Failed Build, Then Fixed

```
$ git branch --show-current → master
$ git stash push -u -m "pre-upgrade-20260208: adding new service config"
$ just update-branch → created update-20260208
$ just upgrade → flake.lock updated
$ just build → FAILED: nixvim plugin API changed
  → Read error, identify breaking change in plugin module
  → Edit home/nixvim/plugins.nix to fix the option name
  → git add home/nixvim/plugins.nix
  → Use commit-message-writer skill, commit fix
$ just build → success
$ git checkout master && git merge --ff-only update-20260208
$ git branch -d update-20260208
$ git stash pop

Result: Inputs updated with one fix applied. Run `just switch` to activate.
```
