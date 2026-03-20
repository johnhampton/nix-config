# Proposal: Replace TMUX + Sesh with WezTerm Session Management

## Executive Summary

WezTerm has built-in multiplexing and workspace capabilities that can fully replace tmux and sesh. The transition is well-documented by the community, and there are mature WezTerm plugins that provide equivalent functionality to sesh.

## Terminology Mapping

| TMUX | Sesh | WezTerm Equivalent |
|------|------|-------------------|
| Session | Session | **Workspace** |
| Window | - | **Tab** |
| Pane | - | **Pane** |
| Prefix key | - | **Leader key** |
| - | zoxide integration | **smart_workspace_switcher.wezterm** |
| tmux-resurrect | - | **resurrect.wezterm** |

## Key WezTerm Features

### 1. Native Multiplexing
- Built-in pane splitting (horizontal/vertical)
- Tabs within windows
- **Workspaces** - groups of windows/tabs that can be switched between
- Unix domains for persistent sessions (survives terminal close)

### 2. Multiplexing Domains
WezTerm supports multiple domain types:
- **Local domain** - default, simple tabs/panes
- **Unix domain** - persistent mux server (like tmux server)
- **SSH domain** - multiplex over SSH connections
- **TLS domain** - encrypted remote multiplexing

## Sesh Replacement: smart_workspace_switcher.wezterm

The [smart_workspace_switcher.wezterm](https://github.com/MLFlexer/smart_workspace_switcher.wezterm) plugin (174 stars) is explicitly designed as a sesh replacement:

- **zoxide integration** for fuzzy directory switching
- **Fuzzy finder** for workspace selection
- **Events** for workspace creation/switching
- **Same author** as resurrect.wezterm (they integrate well)

```lua
-- Example config
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
workspace_switcher.zoxide_path = "/opt/homebrew/bin/zoxide"

config.keys = {
  { key = "s", mods = "CTRL|SHIFT", action = workspace_switcher.switch_workspace() },
  { key = "t", mods = "CTRL|SHIFT", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  { key = "[", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(1) },
  { key = "]", mods = "CTRL|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
}
```

## Session Persistence: resurrect.wezterm

The [resurrect.wezterm](https://github.com/MLFlexer/resurrect.wezterm) plugin (263 stars) replaces tmux-resurrect/tmux-continuum:

- **Save/restore** windows, tabs, panes with layouts
- **Restore shell output** from saved sessions
- **Periodic auto-save** (configurable interval)
- **Restore on startup** option
- **Optional encryption** (age/gpg)
- **Re-attach to remote domains** (SSH, WSL, Docker)

```lua
-- Periodic save + restore on startup
resurrect.state_manager.periodic_save()
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)
```

## Benefits Over TMUX + Sesh

| Aspect | TMUX + Sesh | WezTerm Native |
|--------|-------------|----------------|
| **Latency** | Extra draw latency from tmux | Direct GPU rendering |
| **Configuration** | tmux.conf + sesh.toml | Single wezterm.lua (Lua!) |
| **Mouse/clipboard** | Requires configuration | Native support |
| **Scrollback** | tmux-managed | Native terminal scrollback |
| **Image support** | Limited/hacky | Native sixel/iTerm2 support |
| **Neovim integration** | vim-tmux-navigator | smart-splits.nvim |
| **Complexity** | 3 tools (tmux + sesh + plugins) | 1 tool + 2 Lua plugins |

## Implementation Plan

### Phase 1: Core WezTerm Multiplexing Setup
1. Configure **leader key** (Ctrl+a to match tmux prefix)
2. Set up **pane splitting** keybindings
3. Configure **tab navigation**
4. Enable **Unix domain** for session persistence

### Phase 2: Workspace Switching (sesh replacement)
1. Install `smart_workspace_switcher.wezterm` plugin
2. Configure zoxide path
3. Set up keybindings for workspace switching
4. Add workspace name to status bar

### Phase 3: Session Persistence
1. Install `resurrect.wezterm` plugin
2. Configure periodic auto-save
3. Enable restore on startup
4. Set up save/load keybindings

### Phase 4: Neovim Integration
1. Replace `vim-tmux-navigator` with `smart-splits.nvim`
2. Configure WezTerm to work with smart-splits for seamless pane navigation

### Phase 5: Cleanup
1. Remove tmux configuration from nix-config
2. Remove sesh from homebrew/packages
3. Update documentation

## Files to Modify

Based on nix-config structure:
- `home/wezterm/` - Add/modify WezTerm configuration
- `home/default.nix` - Remove tmux/sesh, ensure wezterm is present
- `darwin/homebrew.nix` - Remove sesh if installed via homebrew

## Considerations

### Potential Drawbacks
1. **Remote servers** - WezTerm multiplexing is local-only, but SSH domains can handle this via `wezterm connect SSHMUX:hostname`
2. **Plugin stability** - WezTerm plugins are fetched from URLs (can vendor into dotfiles)
3. **Learning curve** - Minor adjustment period for new keybindings

### Mitigations
- Keep tmux installed for remote server use cases if needed
- Vendor plugins into your dotfiles for stability
- Map keybindings to match current tmux muscle memory

## Reference Links

- [WezTerm Multiplexing Docs](https://wezterm.org/multiplexing.html)
- [WezTerm Workspaces Docs](https://wezterm.org/recipes/workspaces.html)
- [smart_workspace_switcher.wezterm](https://github.com/MLFlexer/smart_workspace_switcher.wezterm)
- [resurrect.wezterm](https://github.com/MLFlexer/resurrect.wezterm)
- [How to switch from Tmux to WezTerm](https://florianbellmann.com/blog/switch-from-tmux-to-wezterm)
- [Session management in Wezterm without tmux](https://fredrikaverpil.github.io/blog/2024/10/20/session-management-in-wezterm-without-tmux/)
- [sesh (for reference)](https://github.com/joshmedeski/sesh)
