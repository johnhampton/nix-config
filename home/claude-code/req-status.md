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
- Reload AI guidance: `/user:req-resume [filename]`
- When current phase complete: `/user:req-next [filename]`
- Add discovered tasks: `/user:req-add-task "task description"`
- Review specification: `/user:req-review [filename]`

**Estimated Progress:** [X]% complete ([completed phases]/4 phases done)
```

### 4. Phase-Specific Guidance
Provide contextual tips based on current phase:

**Phase 1 - Foundation:**
```
💡 **Foundation Focus:**
- Get the basic structure solid before moving forward
- Architecture decisions made now affect everything later
- Don't rush dependency setup - it saves time in later phases
```

**Phase 2 - Core Logic:**
```
💡 **Core Logic Focus:**
- This is typically the most complex phase - break large tasks down
- Test core functionality thoroughly before adding integrations
- Business logic bugs are hardest to fix later
```

**Phase 3 - API & Integration:**
```
💡 **Integration Focus:**
- Security is critical - don't skip authentication/authorization
- Test API responses and error handling extensively
- Document API changes as you implement them
```

**Phase 4 - Testing & Polish:**
```
💡 **Testing Focus:**
- Focus on edge cases and error scenarios now
- Performance issues are easier to catch before deployment
- Prepare monitoring and deployment considerations early
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
Run `/user:req-next [filename]` to advance or `/user:req-add-task` to add new work.
```

**Missing critical tasks:**
```
💡 **Suggestion:** Consider adding these common tasks:
- Database migration testing
- Error handling validation  
- Performance benchmarking
```

### 6. Command Reference
```
📋 **Available Commands:**
- `/user:req-resume [filename]` - Reload AI guidance for current phase
- `/user:req-next [filename]` - Advance to next phase when ready
- `/user:req-add-task "description"` - Add tasks discovered during work
- `/user:req-review [filename]` - Validate specification quality
- `/user:req-status [filename]` - Check progress (this command)
```