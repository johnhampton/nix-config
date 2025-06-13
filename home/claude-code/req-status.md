# File: .claude/commands/req-status.md

Check the implementation status and progress for: $ARGUMENTS

If $ARGUMENTS is empty, look for the most recent requirements-*.md file with progress tracking in common directories (scratch/, tmp/, docs/, current directory).

## Process

### 1. Load Requirements File
- Verify the file exists and is readable
- Parse the specification and progress sections
- Extract current status information

If file not found:
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Looking for recent requirements files...**
[List any requirements-*.md files found in scratch/, tmp/, docs/]

📝 **Usage:** /user:req-status [filename]
📝 **Example:** /user:req-status scratch/requirements-csv-import.md
```

### 2. Parse Progress Information
Extract information from the "Implementation Progress" section:
- Current phase and status
- Completed phases
- Remaining phases
- Current todo items
- Start date and elapsed time

If no progress section found:
```
⚠️ **No progress tracking found in:** $ARGUMENTS

💡 **This spec hasn't been started yet.**
📝 **To begin implementation:** /user:req-start $ARGUMENTS
```

### 3. Display Status Overview
```
📊 **Implementation Status: [Feature Name]**

**File:** [filename]
**Started:** [start date] ([X] days ago)
**Current Phase:** [Phase N: Phase Name]

### 📋 Phase Progress
- [✅/🔄/⏸️] **Phase 1:** Foundation [COMPLETED/IN PROGRESS/PENDING]
- [✅/🔄/⏸️] **Phase 2:** Core Logic [COMPLETED/IN PROGRESS/PENDING]  
- [✅/🔄/⏸️] **Phase 3:** API & Integration [COMPLETED/IN PROGRESS/PENDING]
- [✅/🔄/⏸️] **Phase 4:** Testing & Polish [COMPLETED/IN PROGRESS/PENDING]

### 🎯 Current Focus: [Current Phase Description]
**Active Todo Items:**
- [ ] [Current task 1]
- [ ] [Current task 2]
- [ ] [Current task 3]

### ⚡ Quick Actions
**Next Steps:**
- Continue working on current phase todos
- When current phase complete: `/user:req-continue [filename]`
- Add discovered tasks: `/user:req-add-task "task description"`
- Review specification: `/user:req-review [filename]`

**Estimated Progress:** [X]% complete ([completed phases]/4 phases done)
```

### 4. Phase-Specific Guidance
Provide contextual tips based on current phase:

**Phase 1 - Foundation:**
```
💡 **Foundation Phase Tips:**
- Focus on getting the basic structure right before moving on
- Use sub-agents to validate database design and architecture decisions
- Don't skip dependency setup - it saves time later
```

**Phase 2 - Core Logic:**
```
💡 **Core Logic Phase Tips:**
- This is usually the most complex phase - break tasks into smaller pieces
- Use sub-agents to verify business logic and edge cases
- Test core functionality before integrating with APIs
```

**Phase 3 - API & Integration:**
```
💡 **API & Integration Phase Tips:**
- Use sub-agents for security review of endpoints
- Test API responses thoroughly before UI integration
- Document API changes as you go
```

**Phase 4 - Testing & Polish:**
```
💡 **Testing & Polish Phase Tips:**
- Use sub-agents to review test coverage and identify gaps
- Focus on edge cases and error scenarios
- Prepare deployment and monitoring considerations
```

### 5. Health Check Warnings
Identify potential issues and suggest actions:

**Long-running phases:**
```
⚠️ **Phase has been active for [X] days**
Consider breaking down remaining tasks or moving to next phase if ready.
```

**Stale progress:**
```
⚠️ **No progress updates in [X] days**
Run `/user:req-continue [filename]` to advance or `/user:req-add-task` to add new work.
```

**Missing critical tasks:**
```
💡 **Suggestion:** Consider adding these common tasks:
- Database migration testing
- Error handling validation  
- Performance benchmarking
```