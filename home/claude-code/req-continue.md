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

### 2. Check if All Original Phases Complete
If this is Phase 4 and appears complete, go to **Section 8: Final Completion Check** instead of normal flow.

### 3. MANDATORY USER CONFIRMATION - DO NOT SKIP THIS STEP

**CRITICAL INSTRUCTION:** You MUST get explicit user confirmation before proceeding. Do NOT make assumptions about user intent.

Display this exact message and STOP until user responds:

```
📊 **Phase Transition Check**

**Current Phase:** [current phase name]
**Available Next Phase:** [next phase name]

**Ready to advance to the next phase?**

**Type 'yes' to move to next phase**
**Type 'no' to stay in current phase**

⚠️ **Note:** This will load the appropriate AI guidance for your choice.
```

**STOP HERE** - Wait for user to type 'yes' or 'no'. Do not proceed without explicit confirmation.

### 4. Handle User Response - Load Appropriate AI Guidance

**If user types 'no' (staying in current phase):**

```
✅ **Staying in Current Phase**

**Loading AI guidance for [current phase name]...**
```

**Load Current Phase AI Guidance:**

**Phase 1 (Foundation) - Current guidance active:**
- Proactively suggest sub-agents for database design validation when user creates schemas
- Automatically offer architecture review when user makes structural decisions  
- Recommend dependency analysis when user adds new libraries

**Phase 2 (Core Logic) - Current guidance active:**
- Automatically offer sub-agents for business logic verification when user implements complex rules
- Suggest edge case analysis when user handles data processing
- Recommend algorithm validation when user writes computational logic

**Phase 3 (API & Integration) - Current guidance active:**
- Suggest sub-agents for security review when user creates endpoints
- Recommend integration testing when user connects external services
- Offer API design validation when user defines interfaces

**Phase 4 (Testing & Polish) - Current guidance active:**
- Recommend sub-agents for test coverage analysis when user writes tests
- Suggest performance review when user optimizes code
- Offer deployment readiness checks when user prepares for production

```
🔄 **Current Phase Active:** [Phase N: Phase Name]

**AI Guidance Loaded:** Sub-agent suggestions are now active for current phase tasks.

**Current Todo Items:**
- [ ] [Current task 1]
- [ ] [Current task 2]
- [ ] [Current task 3]

**When ready to advance:** Run /user:req-continue [filename] again
```

**STOP HERE** - Do not proceed to phase advancement.

---

**If user types 'yes' (advancing to next phase):**

### 5. Advance to Next Phase
- Identify the next phase from the specification
- Extract tasks for the next phase
- Clear previous todos and add new ones

```
✅ **Advancing to Next Phase**

📋 **Phase [N]: [Phase Name]** (adding to todo list)

I'm updating your todo list with Phase [N] tasks:

- [Next phase task 1]
- [Next phase task 2]
- [Next phase task 3]
- [Next phase task 4]

Please add these tasks to the todo list for the next implementation phase.
```

### 6. Load Next Phase AI Guidance

**Loading AI guidance for new phase [N]...**

**Phase 1 (Foundation) - New phase guidance active:**
- Proactively suggest sub-agents for database design validation when user creates schemas
- Automatically offer architecture review when user makes structural decisions
- Recommend dependency analysis when user adds new libraries

**Phase 2 (Core Logic) - New phase guidance active:**
- Automatically offer sub-agents for business logic verification when user implements complex rules
- Suggest edge case analysis when user handles data processing
- Recommend algorithm validation when user writes computational logic

**Phase 3 (API & Integration) - New phase guidance active:**
- Suggest sub-agents for security review when user creates endpoints
- Recommend integration testing when user connects external services
- Offer API design validation when user defines interfaces

**Phase 4 (Testing & Polish) - New phase guidance active:**
- Recommend sub-agents for test coverage analysis when user writes tests
- Suggest performance review when user optimizes code
- Offer deployment readiness checks when user prepares for production

### 7. Update Progress Tracking
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

### 8. Provide Phase Overview
```
🚀 **Phase [N]: [Phase Name] Started**

**Focus:** [Brief description of this phase's goals]
**Previous Phase:** ✅ Completed
**Current Phase:** 🔄 In Progress
**Remaining Phases:** [count]

**AI Guidance Loaded:** Sub-agent suggestions are now active for Phase [N] tasks.

**When this phase is complete:**
- Run: /user:req-continue [filename] (if more phases remain)
- Or begin final testing and deployment
```

---

### 8. Final Completion Check (Phase 4 Complete)

**CRITICAL:** Do NOT automatically declare completion. Get user confirmation about next steps.

Display this exact message and STOP until user responds:

```
📊 **All Original Phases Complete - What's Next?**

**Completed Phases:**
- [x] Phase 1: Foundation
- [x] Phase 2: Core Logic  
- [x] Phase 3: API & Integration
- [x] Phase 4: Testing & Polish

**What would you like to do next?**

**Type 'done' if implementation is complete and ready for production**
**Type 'continue' to add more tasks to Phase 4 (bugs, fixes, improvements)**
**Type 'phase5' to create a new phase for additional work**

⚠️ **Important:** Only choose 'done' if you're confident the feature is production-ready.
```

**STOP HERE** - Wait for user to type 'done', 'continue', or 'phase5'.

### 9. Handle Final Completion Response

**If user types 'done':**

```
🎉 **Implementation Complete!**

✅ **All phases finished and confirmed complete:**
- [x] Phase 1: Foundation
- [x] Phase 2: Core Logic  
- [x] Phase 3: API & Integration
- [x] Phase 4: Testing & Polish

**Final Steps:**
- [ ] Deploy to production
- [ ] Monitor for issues
- [ ] Update documentation
- [ ] Notify stakeholders

**Specification file:** [filename]
**Total implementation time:** [calculated from start date]

🚀 **Feature ready for production!**
```

Update requirements file to mark as COMPLETED.

---

**If user types 'continue':**

```
✅ **Continuing Phase 4 Work**

**Loading AI guidance for Phase 4 (Testing & Polish)...**
```

**Load Phase 4 AI Guidance:**
- Recommend sub-agents for test coverage analysis when user writes tests
- Suggest performance review when user optimizes code  
- Offer deployment readiness checks when user prepares for production
- Suggest sub-agents for bug investigation and fixing
- Recommend code quality review for production readiness

```
🔄 **Phase 4: Testing & Polish (Continued)**

**AI Guidance Loaded:** Sub-agent suggestions active for testing, bug fixes, and polish work.

**Add new tasks with:** /user:req-add-task "task description"
**Check progress with:** /user:req-status [filename]
**Mark complete when ready:** /user:req-continue [filename]
```

**STOP HERE** - Ready for continued Phase 4 work.

---

**If user types 'phase5':**

```
✅ **Creating Phase 5: Additional Work**

📋 **Phase 5: Extended Development** (adding to todo list)

I'm creating Phase 5 for additional work beyond the original scope:

- [ ] [Identify specific additional work needed]
- [ ] [Address discovered issues]
- [ ] [Implement additional requirements]
- [ ] [Performance optimization]

Please add these initial Phase 5 tasks to the todo list.
```

**Load Phase 5 AI Guidance:**
- Recommend sub-agents for analyzing what additional work is needed
- Suggest investigation of performance bottlenecks or bugs
- Offer architecture review for any significant changes
- Recommend comprehensive testing for any new functionality

Update requirements file to add Phase 5:

```markdown
### Phase Status
- [x] Phase 1: Foundation (COMPLETED)
- [x] Phase 2: Core Logic (COMPLETED)
- [x] Phase 3: API & Integration (COMPLETED)
- [x] Phase 4: Testing & Polish (COMPLETED)
- [ ] Phase 5: Extended Development (STARTED)

### Current Todo Items
- [ ] [Phase 5 task 1]
- [ ] [Phase 5 task 2]

**Last Updated:** [current date]
```

```
🚀 **Phase 5: Extended Development Started**

**Focus:** Additional work, bug fixes, and improvements beyond original scope
**AI Guidance Loaded:** Sub-agent suggestions active for extended development work.

**When Phase 5 is complete:** Run /user:req-continue [filename] again
```

## Error Handling

**File not found:**
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Available requirements files:**
[List any requirements-*.md files in common locations]

📝 **Usage:** /user:req-continue [filename]
```

**Progress tracking corrupted:**
```
⚠️ **Progress tracking section appears corrupted**

I can try to reconstruct it from the specification phases. Continue anyway? (yes/no)
```

**Invalid user response:**
```
❌ **Please respond with a valid option**

**For phase transitions:** 'yes' or 'no'  
**For completion:** 'done', 'continue', or 'phase5'
```

**IMPORTANT REMINDERS:**
- NEVER skip user confirmation steps
- NEVER automatically declare completion without user consent
- ALWAYS wait for explicit user responses
- Load AI guidance based on user's choice and intent
- Support extending work beyond original 4 phases when needed