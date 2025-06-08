# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands
- Build configuration: `just build`
- Switch to new generation: `just switch` (builds, switches, and cleans up)
- Rebuild and switch: `just rebuild-switch` (only rebuilds and switches)
- Upgrade packages: `just upgrade` (updates flake inputs and commits lock file)
- Clean up: `just clean` (removes ./result directory)
- Optimize store: `just optimize-store` (runs `nix store optimise`)
- **NOTE**: Don't try to run `just switch` it requires sudo priveledges. 

## Architecture Overview
This repository manages macOS (Darwin) system configuration using nix-darwin and home-manager:

- **flake.nix**: Central configuration file defining inputs (dependencies) and outputs (system configurations)
- **darwin/**: System-level configuration (yabai, homebrew, hotkeys)
- **home/**: User-level configuration (per-application settings)
- **machines/**: Machine-specific configurations
- **overlays/**: Custom package definitions and modifications
- **secrets/**: Encrypted secrets managed with agenix
- **builders/**: Nix build system configurations

## Key Components
- **nix-darwin**: Manages macOS system configuration
- **home-manager**: Manages user-level configuration and dotfiles
- **agenix**: Handles encrypted secrets
- **nixvim**: Manages neovim configuration
- **justfile**: Task runner for common operations

## Working with Secrets
- Secrets are encrypted with agenix (age-encryption)
- Never modify secret files directly, use agenix to edit them

## Neovim Configuration
The Neovim setup is managed through nixvim and includes:
- LSP support for multiple languages
- Telescope for fuzzy finding
- Autocompletion with nvim-cmp
- Git integration
- Testing integration with neotest
- AI assistance with Copilot and Aider
- Haskell-specific tools

See `/docs/neovim-keybindings.md` for comprehensive keybinding documentation.

## Common Development Tasks
- Adding a new package to home environment: Edit `/home/default.nix` and add to `home.packages`
- Adding Homebrew packages: Edit `/darwin/homebrew.nix`
- Modifying Neovim config: Edit files in `/home/nixvim/`

## Nix Configuration Guidelines
- **Nix Formatting**: Follow standard Nix formatting with 2-space indentation
- **Imports**: Group imports logically (system, home-manager, tools, etc.)
- **Organization**: 
  - Use modular structure with separate files for different tools/components
  - Keep configuration for each application in its own file
- **Naming**: Use descriptive, lowercase filenames with `.nix` extension
- **Comments**: Document non-obvious configuration choices
- **Error Handling**: Use Nix's null-coalescing operators (`//`, `or`, etc.) for safe defaults
- **Overlays**: Place custom overlays in `/overlays` directory
- **Secrets**: Use `agenix` for sensitive information, never commit secrets directly

## Environment
- Primary user: `john`
- System: Darwin (macOS)
- Default editor: neovim
- Default shell: zsh