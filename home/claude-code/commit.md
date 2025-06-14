Analyze the current git state and create an intelligent commit

## Argument Handling
Parse $ARGUMENTS to determine commit scope:
- Empty: Intelligent commit - analyze worktree changes and determine what needs to be committed based on current work
- Contains "staged": Commit only currently staged files
- Contains "all" or "worktree": Stage and commit all changes in worktree  
- "help": Show usage information
- Any other text: Use as context for commit message generation

## Git State Analysis
First, examine the repository state:

1. **Check for staged changes**: `git diff --cached --name-only`
2. **Check for unstaged changes**: `git diff --name-only`
3. **Check for untracked files**: `git ls-files --others --exclude-standard`

## Safety Checks and Decision Logic

### For Empty Arguments (Intelligent Commit)
Analyze the worktree to determine what should be committed:
1. Examine all changed files (modified, added, deleted)
2. Look at git log to understand recent work patterns
3. Group related changes and identify the primary work being done
4. Stage and commit files that belong to the current logical unit of work
5. If multiple unrelated changes exist, ask which work to commit or suggest splitting

### For Arguments Containing "staged"
- Commit only the currently staged files
- Do not stage any additional files
- Generate commit message based on staged changes only

### Change Analysis
Before proceeding, analyze the changes:
1. **Group files by type/purpose**: 
   - Source code (.js, .ts, .py, etc.)
   - Configuration (.json, .yaml, .env)
   - Documentation (.md, .txt)
   - Assets (images, fonts)
   - Tests (*test*, *spec*)

2. **Detect change patterns**:
   - New feature implementation
   - Bug fixes
   - Refactoring
   - Documentation updates
   - Configuration changes
   - Dependency updates

3. **Identify potential issues**:
   - Mixed unrelated changes
   - Large file additions
   - Sensitive files (.env, keys, secrets)
   - Generated files (build outputs, logs)

## Commit Message Generation

Generate conventional commit messages following this format:
`type(scope): description`

### Commit Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, missing semicolons, etc.)
- `refactor`: Code refactoring
- `test`: Adding or modifying tests
- `chore`: Maintenance tasks, dependency updates
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system or external dependency changes

### Scope Detection
Determine scope from changed files:
- Single component/module: Use component name
- Multiple related components: Use feature or area name
- Cross-cutting changes: Omit scope or use broad category

### Description Guidelines
- Use imperative mood ("add", "fix", "update")
- Keep under 50 characters for the subject line
- Be specific but concise
- Focus on "what" and "why", not "how"

## Output Format

Keep output brief and actionable:

```
📝 Committing [X files]: [brief description]

Proposed: type(scope): description

🔄 Executing:
git add [specific files if needed]
git commit -m "type(scope): description"
```

If unrelated changes detected:
```
⚠️  Detected unrelated changes:
- [file]: [what it does]

Proceed anyway? Continue with 'y' or use /user:commit staged for safer option.
```

## Error Handling and Safety

### Pre-commit Validations
- **Sensitive file check**: Warn about .env, config files with secrets, private keys
- **Large file check**: Flag files >10MB for review
- **Generated file check**: Warn about dist/, build/, node_modules/ additions
- **Unrelated change check**: Flag files that don't fit the primary change pattern

### Safety Prompts
Only prompt if genuinely problematic:
```
⚠️  WARNING: [specific issue - sensitive files, very large changes, etc.]
Proceed? [y/N]
```

Keep prompts minimal and actionable.

### Fallback Behaviors
- If commit message generation fails: Provide template for manual completion
- If file analysis is unclear: Ask for user clarification
- If conflicts detected: Guide user through resolution

## Usage Examples

Show these examples when $ARGUMENTS is "help":

```
USAGE: /user:commit [description]

EXAMPLES:
  /user:commit                           # Commit current work (staged or recent changes)
  /user:commit all of the changes        # Stage and commit all worktree changes  
  /user:commit the staged files          # Commit only staged files
  /user:commit help                      # Show this help

BEHAVIOR:
  - Analyzes diffs to generate conventional commit messages
  - Default: commits "stuff we've been working on" 
  - Warns about unrelated changes but doesn't block workflow
  - Avoids 'git add .' unless "all" or "worktree" specified
  - Generates brief, conventional commit messages
```

## Advanced Features

### Multi-part Commit Detection
If changes span multiple logical units:
```
🔍 Detected multiple distinct changes:
1. Feature: New user authentication (5 files)
2. Fix: Button styling issue (2 files)  
3. Docs: Update README (1 file)

Recommend splitting into separate commits:
- Commit authentication changes first
- Then commit styling fix
- Finally commit documentation

Proceed with split commits? [y/N]
```

### Commit Template Integration
If `.gitmessage` template exists in project:
- Incorporate template structure
- Fill in conventional commit format
- Preserve any project-specific requirements

### Hook Integration
Before final commit:
```
🔄 Running pre-commit checks...
✓ Linting passed
✓ Tests passed  
✓ No secrets detected

Ready to commit: [proposed message]
```

Remember: This command prioritizes safety and clarity over speed. Better to ask for clarification than commit inappropriate changes.
