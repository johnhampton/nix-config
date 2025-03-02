# CLAUDE.md - NixConfig Assistant Guide

## Build Commands
- Build configuration: `just build`
- Switch to new generation: `just switch`
- Rebuild and switch: `just rebuild-switch`
- Upgrade packages: `just upgrade`
- Clean up: `just clean`
- Optimize store: `just optimize-store`

## Code Style Guidelines
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