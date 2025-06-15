# File: .claude/commands/req-add-task.md

Add a new task to the current implementation phase: $ARGUMENTS

The task will be added to Claude Code's todo list and tracked in the requirements file.

If $ARGUMENTS is empty:
```
❌ **No task description provided**
💡 **Provide a specific task to add**
📝 **Example:** /user:req-add-task "handle CSV encoding issues"
```

## Process

### 1. Find Requirements File
Look for the most recent requirements-*.md file in common directories (scratch/, tmp/, docs/, current directory):
- Check for files with "Implementation Progress" sections
- Use the most recently modified requirements file
- If multiple files found, use the one with most recent "Last Updated" timestamp

If no requirements file found:
```
❌ **No requirements file found**
💡 **Create a requirements spec first**
📝 **Run:** /user:req-gather "feature description"
```

### 2. Verify Current Phase
**CRITICAL: This command NEVER modifies phase status - only adds tasks**

Read the "Implementation Progress" section to identify current phase.

If no progress section found:
```
❌ **No implementation started**
💡 **Start implementation first**
📝 **Run:** /user:req-start [filename]
```

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

If file update fails:
```
❌ **Could not update requirements file**
💡 **Task added to Claude Code todo list only**
📝 **Manually add to:** [requirements file path]
```

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

**Multiple requirements files found:**
```
⚠️ **Multiple requirements files found**
Using most recent: [filename]
```

**File modification failed:**
```
❌ **Cannot modify requirements file**
💡 **Task added to todo list only**
📝 **Add manually to:** [filename]
```

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