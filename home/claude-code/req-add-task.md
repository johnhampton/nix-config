# File: .claude/commands/req-add-task.md

Add a new task to the current implementation phase: $ARGUMENTS

The task will be added to Claude Code's todo list and tracked in the requirements file.

If $ARGUMENTS is empty:
```
❌ **Usage:** /user:req-add-task "task description"
📝 **Example:** /user:req-add-task "handle CSV encoding issues (UTF-8 vs Latin-1)"

💡 **Pro tip:** Be specific about what needs to be done for better todo tracking.
```

## Process

### 1. Find Active Requirements File
Look for the most recent requirements-*.md file with active progress tracking:
- Check scratch/, tmp/, docs/, current directory
- Find files with "Implementation Progress" sections
- Identify the one with current phase marked as "STARTED" or "IN PROGRESS"

If no active file found:
```
❌ **No active implementation found**

🔍 **Available requirements files:**
[List any requirements-*.md files found]

💡 **To start implementation:** /user:req-start [filename]
📝 **Or specify file:** /user:req-add-task "task" [filename]
```

### 2. Add Task to Todo List
Add the new task to Claude Code's built-in todo list:

```
I'm adding this task to your current todo list:

- $ARGUMENTS

Please add this task to the todo list so we can track it with your other implementation work.
```

### 3. Update Requirements File
Add the new task to the progress tracking section:

Find the "Current Todo Items" section and append:
```markdown
### Current Todo Items
- [ ] [Existing task 1]
- [ ] [Existing task 2]
- [ ] $ARGUMENTS

**Last Updated:** [current date]
```

### 4. Confirmation Message
```
✅ **Task Added Successfully**

**New Task:** $ARGUMENTS
**Added to:** [requirements filename]
**Current Phase:** [Phase N: Phase Name]

**Your updated todo list now has:** [N] tasks

🎯 **Current Focus:** Continue working through Phase [N] tasks
💡 **When phase complete:** /user:req-continue [filename]
📊 **Check progress:** /user:req-status [filename]
```

### 5. Smart Suggestions
Based on the task description, provide relevant suggestions:

**For database-related tasks:**
```
💡 **Database Task Detected**
Consider also adding:
- Migration rollback testing
- Performance impact assessment
- Index optimization review
```

**For API/security tasks:**
```
💡 **API/Security Task Detected**
Consider also adding:
- Input validation testing
- Authorization edge cases
- Error response formatting
```

**For testing tasks:**
```
💡 **Testing Task Detected**
Consider also adding:
- Edge case coverage
- Performance benchmarking
- Integration test scenarios
```

## Advanced Usage

### Adding Tasks with Context
```bash
# Add task to specific file
/user:req-add-task "validate user permissions" scratch/requirements-auth-system.md

# Add urgent task (gets added to top of todo list)
/user:req-add-task "URGENT: fix authentication bug" 

# Add task with phase specification
/user:req-add-task "performance testing for imports [Phase 4]"
```

## Error Handling

**Task already exists:**
```
⚠️ **Similar task already exists:** [existing task]
Add anyway? This might be a duplicate. (yes/no)
```

**Invalid requirements file:**
```
❌ **Requirements file has no progress tracking:** [filename]
💡 **Start implementation first:** /user:req-start [filename]
```