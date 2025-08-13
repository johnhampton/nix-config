# Neovim Keybindings Documentation

This document provides a comprehensive overview of all keybindings configured in my Neovim setup, organized by functionality.

## Table of Contents
- [Leader Key and Key Groups](#leader-key-and-key-groups)
- [Navigation](#navigation)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [File Management](#file-management)
- [Telescope (Fuzzy Finding)](#telescope-fuzzy-finding)
- [Git Integration](#git-integration)
- [General Operations](#general-operations)
- [Code Manipulation](#code-manipulation)
- [Autocompletion](#autocompletion)
- [AI and Copilot](#ai-and-copilot)
- [Haskell-specific](#haskell-specific)
- [Testing (Neotest)](#testing-neotest)
- [Tmux Navigation](#tmux-navigation)

## Leader Key and Key Groups

The configuration has multiple keybinding groups organized under leader-based prefixes:

| Prefix     | Description                  |
|------------|------------------------------|
| `<leader>a` | AI-related commands          |
| `<leader>A` | Aider-related commands       |
| `<leader>b` | Buffer operations            |
| `<leader>c` | Code operations              |
| `<leader>F` | Find operations (Telescope)  |
| `<leader>g` | Git operations               |
| `<leader>h` | Haskell-specific operations  |
| `<leader>l` | LSP operations               |
| `<leader>L` | LSP control                  |
| `<leader>t` | Testing (Neotest)            |
| `<leader>y` | Yank/Copy operations         |

## Navigation

### General Navigation

Standard Vim navigation keys apply (h,j,k,l, etc.)

### Tmux Integration

| Keybinding | Description                     |
|------------|---------------------------------|
| `Ctrl-h`   | Navigate to left pane/split     |
| `Ctrl-j`   | Navigate to down pane/split     |
| `Ctrl-k`   | Navigate to up pane/split       |
| `Ctrl-l`   | Navigate to right pane/split    |
| `Ctrl-\`   | Navigate to previous pane/split |

## LSP (Language Server Protocol)

| Keybinding       | Description                        |
|------------------|------------------------------------|
| `gl`             | Show line diagnostics              |
| `<leader>ca`     | Code action                        |
| `<F2>`           | Rename symbol                      |
| `<leader>cl`     | CodeLens action                    |
| `<leader>cr`     | Refresh CodeLens                   |
| `gd`             | Go to definition                   |
| `gD`             | Go to type definition              |
| `grr`            | Find references                    |
| `<leader>ld`     | Document diagnostics               |
| `<leader>lw`     | Workspace diagnostics              |
| `<leader>ls`     | Document symbols                   |
| `<leader>lS`     | Workspace symbols                  |
| `<leader>Li`     | LSP info                           |
| `<leader>Lx`     | Stop LSP                           |
| `<leader>Ls`     | Start LSP                          |
| `<leader>Lr`     | Restart LSP                        |
| `<leader>lf`     | Format file or range               |

## File Management

### Mini.Files Explorer

| Keybinding    | Description                                 |
|---------------|---------------------------------------------|
| `<leader>e`   | Open file explorer                          |
| `-`           | Explore directory of current file           |
| `<leader>E`   | Open fresh explorer                         |
| Inside explorer: |                                          |
| `-`           | Go up to parent directory                   |
| `<C-x>`       | Split horizontally                          |
| `<C-v>`       | Split vertically                            |
| `<C-t>`       | Open in new tab                             |
| `g~`          | Set current working directory               |
| `gX`          | Open file with system default application   |
| `gy`          | Yank relative path of entry under cursor    |
| `gY`          | Yank full path of entry under cursor        |

### Buffer Management

| Keybinding      | Description         |
|-----------------|---------------------|
| `<leader>bd`    | Delete buffer       |
| `<leader>bw`    | Wipeout buffer      |
| `<leader>bh`    | Hide buffer         |

## Telescope (Fuzzy Finding)

| Keybinding      | Description                              |
|-----------------|------------------------------------------|
| `<leader>f`     | Find files                               |
| `<leader>.`     | Show buffers                             |
| `<leader>/`     | Live grep (search in files)              |
| `<leader>Fh`    | Help tags                                |
| `<leader>Fk`    | Show keymaps                             |
| `<leader>F.`    | Resume last picker                       |
| `<leader>Fg`    | Git files                                |
| `<leader>FR`    | Recent files (Global)                    |
| `<leader>Fr`    | Recent files (Current directory)         |
| `<M-p>`         | Toggle preview (in normal and insert mode)|

## Git Integration

| Keybinding      | Description           |
|-----------------|-----------------------|
| `<leader>gg`    | Toggle git overlay    |
| `<leader>gs`    | Show at cursor        |
| `<leader>gf`    | Changed files         |
| `<leader>gb`    | Branches              |

## General Operations

| Keybinding      | Description                              |
|-----------------|------------------------------------------|
| `<leader>yc`    | Copy unnamed register to system clipboard|
| `<leader>yp`    | Copy relative path to system clipboard   |

## Code Manipulation

### Comments

The code commenting functionality is provided by the mini.comment plugin:

| Keybinding | Description                                |
|------------|--------------------------------------------|
| `gc`       | Toggle comment (works with text objects)   |
| `gcc`      | Toggle comment on current line             |

### Surroundings

The mini.surround plugin provides operations for working with surroundings (quotes, brackets, etc.):

| Keybinding | Description                            |
|------------|----------------------------------------|
| `sa`       | Add surrounding in Normal/Visual modes |
| `sd`       | Delete surrounding                     |
| `sr`       | Replace surrounding                    |
| `sf`       | Find surrounding (to the right)        |
| `sF`       | Find surrounding (to the left)         |

## Autocompletion

| Keybinding     | Description                           |
|----------------|---------------------------------------|
| `<Tab>`        | Accept Copilot suggestion/next item   |
| `<S-Tab>`      | Previous item                         |
| `<C-b>`        | Scroll docs up                        |
| `<C-f>`        | Scroll docs down                      |
| `<C-Space>`    | Complete                              |
| `<C-e>`        | Abort                                 |
| `<CR>`         | Confirm selection                     |

## AI and Copilot

### Copilot/AI Keybindings

| Keybinding      | Description                |
|-----------------|----------------------------|
| `<leader>aa`    | AI Toggle                  |
| `<leader>ax`    | AI Reset                   |
| `<leader>ah`    | AI Help Actions            |
| `<leader>ap`    | AI Prompt Actions          |
| `<leader>ae`    | AI Explain                 |
| `<leader>ar`    | AI Review                  |
| `<leader>at`    | AI Tests                   |
| `<leader>af`    | AI Fix                     |
| `<leader>ao`    | AI Optimize                |
| `<leader>ad`    | AI Documentation           |
| `<leader>ac`    | AI Generate Commit         |

### Aider Integration

| Keybinding      | Description                   |
|-----------------|-------------------------------|
| `<leader>A/`    | Open Aider                    |
| `<leader>As`    | Send to Aider                 |
| `<leader>Ac`    | Send Command To Aider         |
| `<leader>Ab`    | Send Buffer To Aider          |
| `<leader>A+`    | Add File to Aider             |
| `<leader>A-`    | Drop File from Aider          |
| `<leader>Ar`    | Add File as Read-Only         |
| In NvimTree:    |                               |
| `<leader>A+`    | Add File from Tree to Aider   |
| `<leader>A-`    | Drop File from Tree from Aider|

## Markdown Preview

| Keybinding      | Description                |
|-----------------|----------------------------|
| `<leader>mp`    | Toggle Markdown Preview    |
| `<leader>ms`    | Stop Markdown Preview      |

## Haskell-specific

| Keybinding      | Description                             |
|-----------------|-----------------------------------------|
| `<leader>he`    | Evaluate all code snippets              |
| `<leader>hh`    | Hoogle search                           |
| `<leader>hp`    | Open the package cabal file             |
| `<leader>hP`    | Open the project file                   |
| `<leader>hrf`   | Toggle GHCi repl for current buffer     |
| `<leader>hrq`   | Quit the GHCi repl                      |
| `<leader>hrr`   | Toggle GHCi repl for current package    |
| `<leader>hs`    | Hoogle signature search                 |

## Testing (Neotest)

| Keybinding      | Description                   |
|-----------------|-------------------------------|
| `<leader>tt`    | Run nearest test              |
| `<leader>tf`    | Run all tests in current file |
| `<leader>to`    | Open test output window       |
| `<leader>ts`    | Toggle test summary           |
| `<leader>ta`    | Attach to running test        |

## Vim Core Commands

Standard Vim keybindings apply, including:

- Normal mode navigation (`hjkl`, `w`, `b`, etc.)
- Text objects (`iw`, `ap`, etc.)
- Visual mode selection (`v`, `V`, `<C-v>`)
- Search (`/`, `?`, `n`, `N`)
- Replace (`:%s/old/new/g`)
- Window management (`<C-w>` commands)