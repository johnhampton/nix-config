# File: .claude/commands/req-continue.md

Continue to the next implementation phase for: $ARGUMENTS

If $ARGUMENTS is empty, look for requirements files with progress tracking.

## Process

### 1. Load and Parse Progress
- Read the requirements file
- Check the "Implementation Progress" section
- Identify current phase and completion status

If no progress section found:
```
❌ **No progress tracking found in:** $ARGUMENTS
💡 **Did you start implementation?** Run: /user:req-start $ARGUMENTS
```

### 2. Validate Current Phase Status
Before continuing, confirm readiness:

```
📊 **Current Status Check**

**File:** [filename]
**Current Phase:** [current phase name]

**Ready to continue?** 
- Have you completed the current phase tasks?
- Are there any blocking issues to resolve first?

Type 'yes' to continue to the next phase, or 'no' to stay in current phase.
```

Wait for user confirmation before proceeding.

### 3. Advance to Next Phase
If user confirms 'yes':

- Identify the next phase from the specification
- Extract tasks for the next phase
- Clear previous todos and add new ones

```
✅ **Moving to Next Phase**

📋 **Phase [N]: [Phase Name]** (adding to todo list)

I'm updating your todo list with Phase [N] tasks:

- [Next phase task 1]
- [Next phase task 2]
- [Next phase task 3]
- [Next phase task 4]

Please add these tasks to the todo list for the next implementation phase.
```

### 4. Update Progress Tracking
Update the progress section in the requirements file:

```markdown
### Phase Status
- [x] Phase 1: Foundation (COMPLETED)
- [ ] Phase 2: Core Logic (STARTED)
- [ ] Phase 3: API & Integration
- [ ] Phase 4: Testing & Polish

### Current Todo Items
- [ ] [New task 1]
- [ ] [New task 2]
- [ ] [New task 3]

**Last Updated:** [current date]
```

### 5. Provide Phase Overview
```
🚀 **Phase [N]: [Phase Name] Started**

**Focus:** [Brief description of this phase's goals]
**Previous Phase:** ✅ Completed
**Current Phase:** 🔄 In Progress
**Remaining Phases:** [count]

**When this phase is complete:**
- Run: /user:req-continue [filename] (if more phases remain)
- Or begin final testing and deployment

💡 **Phase [N] Tips:**
- Use sub-agents to validate complex implementations from multiple perspectives
- Consider spawning specialized sub-agents for code review, testing, or security analysis
- Sub-agents preserve main context while investigating specific technical questions

**Sub-Agent Strategies by Phase:**
- **Foundation Phase:** Use sub-agents to validate database design and dependency choices
- **Core Logic Phase:** Spawn sub-agents to verify business logic and edge case handling
- **API Phase:** Use sub-agents for security review and API design validation
- **Testing Phase:** Spawn sub-agents to review test coverage and identify missing scenarios
```

### 6. Handle Final Phase
If this was the last phase:

```
🎉 **Implementation Complete!**

✅ **All phases finished:**
- [x] Phase 1: Foundation
- [x] Phase 2: Core Logic  
- [x] Phase 3: API & Integration
- [x] Phase 4: Testing & Polish

**Final Steps:**
- [ ] Run comprehensive tests
- [ ] Update documentation
- [ ] Deploy to production
- [ ] Monitor for issues

**Specification file:** [filename]
**Total implementation time:** [calculated from start date]

🚀 **Feature ready for production!**
```

## Error Handling

**File not found:**
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Available requirements files:**
[List any requirements-*.md files in common locations]

📝 **Usage:** /user:req-continue [filename]
```

**No next phase:**
```
✅ **All phases complete!** 

The implementation appears to be finished. Check the final phase section for any remaining cleanup tasks.
```

**Progress tracking corrupted:**
```
⚠️ **Progress tracking section appears corrupted**

I can try to reconstruct it from the specification phases. Continue anyway? (yes/no)
```
