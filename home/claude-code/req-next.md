# File: .claude/commands/req-next.md

Advance to the next implementation phase: $ARGUMENTS

Confirms readiness and moves to the next phase with appropriate AI guidance.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file with progress tracking.

## Process

### 1. Load Requirements File
- Read the requirements file
- Parse the "Implementation Progress" section
- Identify current phase and status

<error-handling>
  <case condition="file-not-found">
    ❌ **Requirements file not found**
    💡 **Check filename or find in scratch/, tmp/, docs/**
    📝 **Usage:** /user:req-next [filename]
  </case>
  
  <case condition="no-progress-section">
    ❌ **No implementation started**
    💡 **Start implementation first**
    📝 **Run:** /user:req-start [filename]
  </case>
</error-handling>

### 2. Check Phase Progression

<phase-routing>
  <route condition="phase-1-3">
    <description>Current phase is Phase 1-3 (normal advancement)</description>
    <action>Go to Section 3: Normal Phase Advancement</action>
  </route>
  
  <route condition="phase-4">
    <description>Current phase is Phase 4 (final phase check)</description>
    <action>Go to Section 4: Final Phase Completion</action>
  </route>
  
  <route condition="phase-5+">
    <description>Current phase is Phase 5+ (extended phases)</description>
    <action>Go to Section 5: Extended Phase Management</action>
  </route>
</phase-routing>

### 3. Normal Phase Advancement (Phases 1-3)

**MANDATORY USER CONFIRMATION:**

```
📊 **Ready to Advance?**

**Current Phase:** [current phase name]
**Next Phase:** [next phase name]

**Before advancing, confirm:**
- [ ] Current phase tasks are complete
- [ ] No blocking issues remain
- [ ] Ready to focus on next phase

**Type 'yes' to advance to next phase**
**Type 'no' to stay in current phase**

⚠️ **Note:** Use /user:req-resume to reload current phase guidance without advancing.
```

**STOP HERE** - Wait for explicit 'yes' or 'no'.

<user-response-handler>
  <response value="no">
    <output>
      ✅ **Staying in current phase**
      💡 **To reload current phase guidance:** /user:req-resume [filename]
    </output>
    <action>STOP - Do not proceed</action>
  </response>
  
  <response value="yes">
    <action>Continue to Section 6: Execute Phase Advancement</action>
  </response>
</user-response-handler>

### 4. Final Phase Completion (Phase 4)

**FINAL COMPLETION CHECK:**

```
📊 **Phase 4 Complete - Final Check**

**Completed Phases:**
- [x] Phase 1: Foundation
- [x] Phase 2: Core Logic
- [x] Phase 3: API & Integration  
- [x] Phase 4: Testing & Polish

**What's next?**

**Type 'done' if implementation is complete and ready for production**
**Type 'continue' to add more tasks to Phase 4 (bugs, fixes, improvements)**
**Type 'phase5' to create a new phase for additional work**

⚠️ **Important:** Only choose 'done' if you're confident the feature is production-ready.
```

**STOP HERE** - Wait for 'done', 'continue', or 'phase5'.

<user-response-handler>
  <response value="done">
    <action>Continue to Section 7: Mark Implementation Complete</action>
  </response>
  
  <response value="continue">
    <output>
      ✅ **Continuing Phase 4 Work**
      💡 **To reload Phase 4 guidance and add tasks:** /user:req-resume [filename]
      💡 **Then add tasks with:** /user:req-add-task "task description"
    </output>
    <action>STOP - Do not proceed</action>
  </response>
  
  <response value="phase5">
    <action>Continue to Section 8: Create Extended Phase</action>
  </response>
</user-response-handler>

### 5. Extended Phase Management (Phase 5+)

**EXTENDED PHASE ADVANCEMENT:**

```
📊 **Ready to Advance Extended Phase?**

**Current Phase:** [Phase N: Phase Name]
**Next Phase:** Phase [N+1]: Extended Development

**Type 'yes' to create next extended phase**
**Type 'no' to stay in current phase**  
**Type 'done' to mark implementation complete**

⚠️ **Note:** Extended phases are for work beyond the original scope.
```

**STOP HERE** - Wait for 'yes', 'no', or 'done'.

<user-response-handler>
  <response value="yes">
    <action>Continue to Section 8: Create Extended Phase</action>
  </response>
  
  <response value="no">
    <output>
      ✅ **Staying in current phase**
      💡 **To reload current phase guidance:** /user:req-resume [filename]
    </output>
    <action>STOP - Do not proceed</action>
  </response>
  
  <response value="done">
    <action>Continue to Section 7: Mark Implementation Complete</action>
  </response>
</user-response-handler>

### 6. Execute Phase Advancement

**Before advancing**: Verify all completed tasks show as `- [x]` in requirements file.

**Normal phase advancement process:**

```
✅ **Advancing to Next Phase**

📋 **Phase [N]: [Phase Name]**
```

**Load Next Phase AI Guidance:**

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

**Update Progress Tracking:**

**When advancing**: Update requirements file:
- Mark previous phase as completed: `- [x]`
- Ensure all completed tasks show `- [x]`
- Add new phase tasks as `- [ ]`
- Update "Last Updated" timestamp

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

**Phase Overview:**
```
🚀 **Phase [N]: [Phase Name] Started**

**Focus:** [Brief description of this phase's goals]
**AI Guidance Loaded:** Sub-agent suggestions are now active for Phase [N] tasks.

**When this phase is complete:** /user:req-next [filename]
```

### 7. Mark Implementation Complete

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

### 8. Create Extended Phase

```
✅ **Creating Phase 5: Extended Development**

📋 **Phase 5: Extended Development**

Adding Phase 5 for additional work beyond the original scope.
```

Load Phase 5+ AI guidance and update progress tracking with new phase.

## Error Handling

<error-handling>
  <case condition="file-not-found">
    ❌ **Requirements file not found**
    💡 **Check filename or location**
    📝 **Usage:** /user:req-next [filename]
  </case>
  
  <case condition="invalid-response">
    ❌ **Invalid response**
    💡 **Valid options: yes, no, done, continue, phase5**
    📝 **Type one of the valid options**
  </case>
</error-handling>

## Important Reminders
- This command only advances phases - never use it to reload current phase guidance
- Use /user:req-resume to reload AI guidance for current phase
- Always wait for explicit user confirmation before advancing
- Support extended phases beyond the original 4-phase structure