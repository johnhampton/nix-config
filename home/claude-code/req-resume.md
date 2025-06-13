# File: .claude/commands/req-resume.md

Resume work on the current implementation phase: $ARGUMENTS

Loads AI guidance for the current phase without advancing. Perfect for new sessions or after compaction.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file with progress tracking.

## Process

### 1. Load Requirements File
- Read the requirements file
- Parse the "Implementation Progress" section
- Identify current phase and status

If file not found:
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Looking for recent requirements files...**
[List any requirements-*.md files found in scratch/, tmp/, docs/]

📝 **Usage:** /user:req-resume [filename]
```

If no progress section found:
```
⚠️ **No progress tracking found in:** $ARGUMENTS

💡 **This spec hasn't been started yet.**
📝 **To begin implementation:** /user:req-start $ARGUMENTS
```

### 2. Load Current Phase AI Guidance

**Loading AI guidance for [current phase name]...**

**Phase 1 (Foundation) - AI guidance active:**
- Proactively suggest sub-agents for database design validation when user creates schemas
- Automatically offer architecture review when user makes structural decisions  
- Recommend dependency analysis when user adds new libraries
- Suggest sub-agents when user mentions "database," "schema," "migration," or "dependencies"

**Phase 2 (Core Logic) - AI guidance active:**
- Automatically offer sub-agents for business logic verification when user implements complex rules
- Suggest edge case analysis when user handles data processing
- Recommend algorithm validation when user writes computational logic
- Offer sub-agents when user encounters complex business requirements or data transformations

**Phase 3 (API & Integration) - AI guidance active:**
- Suggest sub-agents for security review when user creates endpoints
- Recommend integration testing when user connects external services
- Offer API design validation when user defines interfaces
- Proactively suggest security analysis for authentication and data handling

**Phase 4 (Testing & Polish) - AI guidance active:**
- Recommend sub-agents for test coverage analysis when user writes tests
- Suggest performance review when user optimizes code
- Offer deployment readiness checks when user prepares for production
- Suggest sub-agents for bug investigation and comprehensive testing

**Phase 5+ (Extended Development) - AI guidance active:**
- Recommend sub-agents for analyzing additional work needed
- Suggest investigation of performance bottlenecks or bugs
- Offer architecture review for any significant changes
- Recommend comprehensive testing for any new functionality

### 3. Display Current Status
```
🔄 **Resuming Work: [Feature Name]**

**File:** [filename]
**Current Phase:** [Phase N: Phase Name]
**Started:** [start date] ([X] days ago)

### 📋 Current Focus
**Active Todo Items:**
- [ ] [Current task 1]
- [ ] [Current task 2]
- [ ] [Current task 3]

### 🤖 AI Guidance Loaded
Sub-agent suggestions are now active for [Phase N] tasks.

### ⚡ Quick Actions
- **Add tasks:** /user:req-add-task "task description"
- **Check full status:** /user:req-status [filename]
- **Ready to advance:** /user:req-next [filename]
- **Review specification:** /user:req-review [filename]

**Estimated Progress:** [X]% complete ([completed phases]/[total phases] phases done)
```

### 4. Phase-Specific Focus Tips
Provide brief, actionable guidance for current phase:

**Phase 1 - Foundation:**
```
💡 **Foundation Focus:**
- Get the basic structure solid before moving forward
- Architecture decisions made now affect everything later
```

**Phase 2 - Core Logic:**
```
💡 **Core Logic Focus:**
- This is typically the most complex phase - break large tasks down
- Test core functionality thoroughly before adding integrations
```

**Phase 3 - API & Integration:**
```
💡 **Integration Focus:**
- Security is critical - don't skip authentication/authorization
- Test API responses and error handling extensively
```

**Phase 4 - Testing & Polish:**
```
💡 **Testing Focus:**
- Focus on edge cases and error scenarios now
- Performance issues are easier to catch before deployment
```

**Phase 5+ - Extended Development:**
```
💡 **Extended Work Focus:**
- Address issues discovered during implementation
- Consider long-term maintainability of any new features
```

## Notes
- This command NEVER advances phases
- Use /user:req-next when ready to move to the next phase
- Perfect for reloading AI guidance after session compaction or new sessions