---
name: mas-install
description: This skill should be used when the user asks to "install an app from the App Store", "add a Mac App Store app", "install from mas", "add to masApps", or mentions installing a specific app via the Mac App Store.
---

# Mac App Store Install

## Overview

Search the Mac App Store for an app, confirm the selection with the user, and add it to the `masApps` attribute set in `darwin/homebrew.nix`. This ensures the app is declaratively managed by nix-darwin and installed on the next `just switch`.

## Workflow

### Step 1: Search the App Store

Run `mas search <app name>` using the name provided by the user. This returns a list of matching apps with their IDs and names.

### Step 2: Confirm the App with the User

Evaluate the search results:

- **Single obvious match:** Present the app name and ID to the user for confirmation using `AskUserQuestion`.
- **Multiple plausible matches:** Present the top candidates as options using `AskUserQuestion`, letting the user pick the correct one.
- **No results:** Inform the user and ask for an alternative search term.

Do not proceed without user confirmation.

### Step 3: Add to masApps

Edit `darwin/homebrew.nix` to add the confirmed app to the `masApps` attribute set.

#### Formatting Rules

Follow the existing conventions in the file:

- **Alphabetical order** — Insert the new entry in its correct alphabetical position among the existing `masApps` entries.
- **Quoting** — Use the app name exactly as returned by `mas search`. Quote the name if it contains spaces, punctuation, or special characters. Leave it unquoted if it is a single word with no special characters (e.g., `Tailscale`, `Xcode`, `Magnet`).
- **Format** — Each entry follows the pattern: `"App Name" = <numeric-id>;` or `AppName = <numeric-id>;`
- **Indentation** — Match the surrounding 6-space indentation.

#### Example Entries

```nix
# Quoted (contains spaces/special chars)
"Bear: Markdown Notes" = 1091189122;
"Session - Pomodoro Focus Timer" = 1521432881;

# Unquoted (single word, no special chars)
Magnet = 441258766;
Tailscale = 1475387142;
```

### Step 4: Report

After editing, inform the user:
- Which app was added and its ID
- That it will be installed on the next `just switch`
- Do not commit — leave that to the user
