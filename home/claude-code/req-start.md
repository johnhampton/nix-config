# File: .claude/commands/req-start.md

Load and begin implementation of the requirements specification: $ARGUMENTS

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories (tmp/, scratch/, docs/, current directory).

## Process

### 1. Load Requirements File
- Verify the file exists and is readable
- Parse the specification content
- Identify the Phase 1 tasks

If file not found:
```
❌ **File not found:** $ARGUMENTS
🔍 **Looking for recent requirements files...**
[List any requirements-*.md files found]

📝 **Usage:** /user:req-start [filename]
```

### 2. Extract Phase 1 Tasks
From the "Phase 1: Foundation" section, identify specific, actionable tasks that should be completed first. Look for:
- Database schema changes
- Dependency additions  
- Basic file/directory structure setup
- Authentication/permission setup
- Configuration changes

### 3. Populate Todo List
Add the Phase 1 tasks to Claude Code's built-in todo list using clear, actionable language:

```
I'm adding these Phase 1 tasks to your todo list:

- [Specific task 1 from spec]
- [Specific task 2 from spec]  
- [Specific task 3 from spec]
- [Specific task 4 from spec]

Please add these tasks to the todo list so we can track progress on the foundation work.
```

### 4. Implementation Guidance
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
2. When Phase 1 is complete, run: /user:req-continue [filename]
3. Use /user:req-add-task "description" to add any discovered tasks
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

### 5. Update Spec File with Progress Tracking
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