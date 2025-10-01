# AGENTS.md

macOS system configuration using nix-darwin and home-manager.

## Build Commands
- `just build` - Build configuration (no activation)
- `just switch` - Build and activate new generation (requires sudo - don't run without permission)
- `just rebuild-switch` - Rebuild and switch only
- `just upgrade` - Update flake inputs, commit lock file
- `just clean` - Remove ./result directory
- `just optimize-store` - Run `nix store optimise`
- `nix flake check` - Run flake checks (if defined)

## Repository Structure
- **flake.nix** - Central config (inputs/outputs)
- **darwin/** - System-level (yabai, homebrew, hotkeys)
- **home/** - User-level config (nixvim, tmux, zsh, ssh)
- **machines/** - Host-specific (hostname-based selection)
- **overlays/** - Custom packages, patches, pinned versions
- **secrets/** - Encrypted with agenix (never edit directly)
- **builders/** - CI/build helpers
- **scripts/** - `config-edit.sh` for temporary edits to managed files

## Workflows

### Managing Secrets
- Encrypted with agenix (age-encryption)
- Never modify `secrets/*.age` directly, use agenix

### Temporary Config Edits
- Edit: `just edit-config <path>`
- Restore: `just restore-config <path>`

### Adding Packages
- Home packages: `home/default.nix` → `home.packages`
- Homebrew: `darwin/homebrew.nix`

### Neovim Configuration
- Config files: `home/nixvim/`
- **ALWAYS check native plugin support**: https://nix-community.github.io/nixvim/plugins/
- Use `plugins.<plugin-name>` for native plugins, `extraPlugins` for others
- **ALWAYS update `/docs/neovim-keybindings.md`** when modifying keybindings

## Project Standards

### File Organization
- Use `kebab-case.nix` filenames
- Keep modules small, one per application/tool
- Import via `home/default.nix` or `darwin/default.nix`
- Place overlays in `overlays/`

### Nix Code Style
- 2-space indentation
- Group imports logically (system, home-manager, tools)
- Document non-obvious choices
- Use null-coalescing operators (`//`, `or`) for safe defaults

### Shell Scripts
- Use `bash -euo pipefail`
- Lint with shellcheck (available in devShell)

### Commits
- Follow Conventional Commits: `type(scope): summary`
- Examples: `feat(hotkeys): disable screenshot shortcuts`, `fix(nixvim): correct plugin path`
- One logical change per commit

### Critical Nix Flake Rule
**When modifying flake.nix, all referenced files must be in git (committed or staged)**. This is the most common flake error source.
