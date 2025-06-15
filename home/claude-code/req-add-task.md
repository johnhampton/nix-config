# File: .claude/commands/req-add-task.md

Add a new task to the current implementation phase: $ARGUMENTS

The task will be added to Claude Code's todo list and tracked in the requirements file.

<error-handling>
  <case condition="empty-arguments">
    ❌ **No task description provided**
    💡 **Provide a specific task to add**
    📝 **Example:** /user:req-add-task "handle CSV encoding issues"
  </case>
</error-handling>

## Process

### 1. Find Requirements File
Look for the most recent requirements-*.md file in common directories (scratch/, tmp/, docs/, current directory):
- Check for files with "Implementation Progress" sections
- Use the most recently modified requirements file
- If multiple files found, use the one with most recent "Last Updated" timestamp

<error-handling>
  <case condition="no-requirements-file">
    ❌ **No requirements file found**
    💡 **Create a requirements spec first**
    📝 **Run:** /user:req-gather "feature description"
  </case>
</error-handling>

### 2. Verify Current Phase
**CRITICAL: This command NEVER modifies phase status - only adds tasks**

Read the "Implementation Progress" section to identify current phase.

<error-handling>
  <case condition="no-progress-section">
    ❌ **No implementation started**
    💡 **Start implementation first**
    📝 **Run:** /user:req-start [filename]
  </case>
</error-handling>

### 3. Add Task to Claude Code Todo List
Add the new task(s) to Claude Code's built-in todo list:

```
📝 Adding to todo list: $ARGUMENTS
```

### 4. Update Requirements File
Add the task to the "Current Todo Items" section:
- Add new task as: `- [ ] $ARGUMENTS`
- Update "Last Updated:" timestamp
- Save the file

<error-handling>
  <case condition="file-update-failed">
    ❌ **Could not update requirements file**
    💡 **Task added to Claude Code todo list only**
    📝 **Manually add to:** [requirements file path]
  </case>
</error-handling>

### 5. Confirmation
```
✅ **Task Added**
**File:** [requirements filename]
**Phase:** [current phase] (unchanged)

**Next:** Continue current phase work
**When done:** /user:req-next [filename]
```

### 6. Smart Suggestions (Optional)
Only if highly relevant, suggest related tasks:

**Database tasks:** Consider migration testing
**API tasks:** Consider security validation
**Complex tasks:** Consider breaking into subtasks

## Error Handling

<error-handling>
  <case condition="multiple-files">
    ⚠️ **Multiple requirements files found**
    Using most recent: [filename]
  </case>
  
  <case condition="file-modification-failed">
    ❌ **Cannot modify requirements file**
    💡 **Task added to todo list only**
    📝 **Add manually to:** [filename]
  </case>
</error-handling>

## Usage Examples

**Single task:**
```bash
/user:req-add-task "add input validation for email field"
```

**Complex task:**
```bash
/user:req-add-task "validate column counts and check for nulls"
```

**Important:** This command NEVER advances phases - only adds tasks