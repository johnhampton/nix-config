Setup comprehensive .gitignore file

If $ARGUMENTS is "help", show:
```
USAGE: /user:setup-gitignore [technologies...]

EXAMPLES:
  /user:setup-gitignore              # Auto-detect project type
  /user:setup-gitignore node nix     # Explicit technologies
  /user:setup-gitignore haskell      # Single technology

SUPPORTED: node, typescript, haskell, python, rust, rescript, nix, direnv
```

If $ARGUMENTS is empty, auto-detect project type from common files:
- *.cabal or stack.yaml → haskell nix
- package.json → node nix  
- Default fallback: haskell nix (most common case)

Auto-detect other technologies as appropriate based on project files.

Parse $ARGUMENTS as space-separated technology names:
- "node" or "typescript" → Node.js/TypeScript
- "haskell" → Haskell
- "python" → Python  
- "rust" → Rust
- "rescript" → ReScript
- "nix" → Nix
- "direnv" → direnv

Use templates from the github/gitignore repository:
- Language templates: Node.gitignore, Haskell.gitignore, Python.gitignore, etc.
- Global templates: Global/Vim.gitignore, Global/macOS.gitignore

For each technology:
1. Use appropriate GitHub gitignore template patterns
2. Include common variants (e.g., Node.js covers npm, yarn, pnpm)
3. Handle case-insensitive matching

Always include these GitHub Global templates:
- Vim (from Global/Vim.gitignore)
- macOS (from Global/macOS.gitignore) 

Always append these additional patterns:
```
# direnv
.envrc

# Claude Code local settings
.claude/settings.local.json
CLAUDE.local.md
```

Merge with existing .gitignore if present:
- Preserve existing content
- Add new sections with clear headers
- Avoid duplicates
- Maintain readable organization

Output format:
```
🔍 Detecting project type...
✓ Found: [detected/specified technologies]

📝 Setting up .gitignore...
✓ Added [Technology] patterns
✓ Added direnv patterns  
✓ Added Claude Code settings
✓ Merged with existing .gitignore

📊 Summary: Added patterns for [list of technologies]
```

Error handling:
- If no project type detected and no arguments: list common options
- For unrecognized technology names: suggest closest matches
- If .gitignore exists but is binary/locked: report error clearly

Never:
- Create backup files
- Commit changes  
- Add overly specific IDE configurations
- Include temporary files in templates
