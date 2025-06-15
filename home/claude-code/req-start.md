# File: .claude/commands/req-start.md

Load and begin implementation of the requirements specification: $ARGUMENTS

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories (tmp/, scratch/, docs/, current directory).

## Process

### 1. Load Requirements File
- Verify the file exists and is readable
- Parse the specification content
- Identify the Phase 1 tasks

<error-handling>
  <case condition="file-not-found">
    ❌ **Requirements file not found**
    💡 **Check filename or create new spec**
    📝 **Usage:** /user:req-start [filename]
  </case>
</error-handling>

### 2. Check for Existing Implementation
Check if "Implementation Progress" section exists in the file.

<error-handling>
  <case condition="implementation-exists">
    ⚠️ **Implementation already in progress**
    **Current Phase:** [phase name]
    **Started:** [start date]
    
    💡 **Resume work instead**
    📝 **Run:** /user:req-resume [filename]
    <action>STOP - Do not proceed with starting new implementation</action>
  </case>
</error-handling>

### 3. Extract Phase 1 Tasks
From the "Phase 1: Foundation" section, identify specific, actionable tasks that should be completed first. Look for:
- Database schema changes
- Dependency additions  
- Basic file/directory structure setup
- Authentication/permission setup
- Configuration changes

### 4. Populate Todo List
Add the Phase 1 tasks to Claude Code's built-in todo list using clear, actionable language:

```
I'm adding these Phase 1 tasks to your todo list:

- [Specific task 1 from spec]
- [Specific task 2 from spec]  
- [Specific task 3 from spec]
- [Specific task 4 from spec]

Please add these tasks to the todo list so we can track progress on the foundation work.
```

### 5. Implementation Guidance
```
🚀 **Phase 1: Foundation Started**

📋 **Current Focus:** Setting up the foundation for [feature name]
📄 **Full Spec:** [filename]

**Phase Overview:**
✅ **Phase 1:** Foundation (CURRENT)
⏸️ **Phase 2:** Core Logic  
⏸️ **Phase 3:** API & Integration
⏸️ **Phase 4:** Testing & Polish

**Next Steps:**
1. Work through the todo list tasks
2. When Phase 1 is complete, run: /user:req-next [filename]
3. Use /user:req-add-task "description" to add any discovered tasks

**Command Reference:**
- **After compaction/new session:** /user:req-resume [filename]
- **Ready to advance phases:** /user:req-next [filename]
- **Add discovered tasks:** /user:req-add-task "task description"
- **Check progress:** /user:req-status [filename]
```

**AI Implementation Guidance:**
During Phase 1 implementation, automatically suggest sub-agents when:
- User creates database schemas or migrations (offer architecture validation sub-agent)
- User makes authentication/security decisions (suggest security review sub-agent)
- User adds new dependencies or frameworks (recommend compatibility analysis sub-agent)
- User designs API structures (offer design pattern validation sub-agent)

**Proactive Sub-Agent Triggers:**
- When user mentions "database," "schema," or "migration" → suggest design review
- When user implements authentication logic → offer security validation
- When user encounters technical decisions → spawn investigation sub-agent
- When user reports complexity or uncertainty → offer specialized analysis

### 6. Update Spec File with Progress Tracking
Append a progress tracking section to the requirements file:

```markdown

---
## Implementation Progress

**Started:** [current date]  
**Current Phase:** Phase 1 - Foundation
**Status:** In Progress

### Phase Status
- [ ] Phase 1: Foundation (STARTED)
- [ ] Phase 2: Core Logic  
- [ ] Phase 3: API & Integration
- [ ] Phase 4: Testing & Polish

### Current Todo Items
- [ ] [Task 1]
- [ ] [Task 2]
- [ ] [Task 3]
- [ ] [Task 4]

*This section is auto-updated by Claude Code commands*
```