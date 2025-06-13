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

### 1. Find Requirements File
Look for the most recent requirements-*.md file in common directories (scratch/, tmp/, docs/, current directory):
- Check for files with "Implementation Progress" sections
- Use the most recently modified requirements file
- If multiple files found, use the one with most recent "Last Updated" timestamp

If no requirements file found:
```
❌ **No requirements file found**

🔍 **Looking in:** scratch/, tmp/, docs/, current directory
📝 **Create one with:** /user:req-gather "feature description"
```

### 2. Read Current Phase (NEVER MODIFY PHASE STATUS)
**CRITICAL: This command NEVER advances phases or modifies phase status**

Read the requirements file "Implementation Progress" section:
- Find the "Current Phase:" field and use exactly as written
- Identify which phase is marked as active/started
- **DO NOT interpret, modify, or advance phase status**
- Phase advancement ONLY happens via /user:req-next with explicit user confirmation

If no progress section found:
```
❌ **No progress tracking found in requirements file**

💡 **Start implementation first:** /user:req-start [filename]
```

### 3. Add Task to Claude Code Todo List
Add the new task(s) to Claude Code's built-in todo list:

```
I'm adding task(s) to your todo list:

[List the task(s) to be added]

Please add these tasks to the todo list so we can track them with your other implementation work.
```

### 4. MANDATORY FILE UPDATE - DO NOT SKIP
**CRITICAL: File modification is required, not optional**

**Step-by-step file update process:**
1. Open the requirements file for modification
2. Locate the exact line "### Current Todo Items"  
3. **Analyze $ARGUMENTS and create appropriate todo item(s):**
   - If $ARGUMENTS describes one task: add single todo item
   - If $ARGUMENTS describes multiple logical tasks: create separate todo items for each
   - Use clear, actionable descriptions for each task
   - Format each as: "- [ ] [task description]"
4. Add the new todo item(s) after existing todo items
5. Update the "**Last Updated:**" line with current date
6. Save the file

**File modification example:**
```markdown
### Current Todo Items
- [ ] [Existing task 1]
- [ ] [Existing task 2]
- [ ] [New task from $ARGUMENTS]
- [ ] [Another new task if $ARGUMENTS contained multiple tasks]

**Last Updated:** [current date]
```

### 5. Verify File Update Completed
**Mandatory verification step:**
After modifying the file, confirm:
- The new task(s) appear in the requirements file
- The "Last Updated" timestamp was updated
- File was saved successfully

If verification fails:
```
❌ **File update failed**
- File location: [requirements file path]
- New task(s) that should be added manually: $ARGUMENTS
- Please add these tasks to the "Current Todo Items" section
```

### 6. Confirmation Message
```
✅ **Task(s) Added Successfully**

**New Task(s):** [List tasks added]
**Added to:** [requirements filename]
**Current Phase:** [Phase N: Phase Name] (unchanged)

**Your updated todo list now has:** [N] tasks

🎯 **Current Focus:** Continue working through [current phase] tasks

**Command Reference:**
💡 **After compaction/new session:** /user:req-resume [filename]
💡 **When phase complete:** /user:req-next [filename]
📊 **Check progress:** /user:req-status [filename]
```

### 7. Smart Suggestions
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

**For multi-step tasks:**
```
💡 **Complex Task Detected**
I've broken this into [N] separate todo items for better tracking.
Consider using sub-agents to help with investigation and validation.
```

## Error Handling

**Multiple requirements files found:**
```
⚠️ **Multiple requirements files found:**
[List files with timestamps]

Using most recent: [filename]
💡 **To specify different file:** Include filename in your task description
```

**File modification permissions:**
```
❌ **Cannot modify requirements file:** [filename]
- Check file permissions
- Ensure file is not open in another application
- Task added to Claude Code todo list only
```

**Corrupted progress section:**
```
⚠️ **Requirements file progress section appears corrupted**
- Task added to Claude Code todo list
- Please manually add to requirements file: $ARGUMENTS
- Consider running: /user:req-review [filename]
```

## Advanced Usage Examples

**Single task:**
```bash
/user:req-add-task "add input validation for email field"
# Creates: - [ ] add input validation for email field
```

**Complex multi-step task:**
```bash
/user:req-add-task "compare column counts between new and legacy tables using MCP, then check for 100% null columns"
# Creates: 
# - [ ] compare column counts between new projection tables and legacy tables using database MCP
# - [ ] check nullable columns in new tables for 100% null values and report findings
```

**Important Reminders:**
- This command NEVER advances phases - only adds tasks to current phase
- File modification is mandatory, not optional
- Complex tasks can be intelligently broken down into multiple todo items
- Phase advancement only happens via /user:req-next with user confirmation