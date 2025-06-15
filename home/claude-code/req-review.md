# File: .claude/commands/req-review.md

Quick implementation reality check: $ARGUMENTS

Provides a concise assessment of how implementation differs from spec and what to do next.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories.

<thinking>
Think deeply about implementation vs specification:
- What assumptions in the spec might prove incorrect?
- What complexity was likely underestimated?
- What integration challenges weren't addressed?
- What can be simplified in the implementation?
- Are there security or performance concerns not covered?
</thinking>

## Process

### 1. Load Requirements and Current State
- Read the requirements specification
- Check implementation progress section
- Analyze current codebase against spec assumptions

<error-handling>
  <case condition="file-not-found">
    ❌ **Requirements file not found**
    💡 **Check available files or filename**
    📝 **Usage:** /user:req-review [filename]
  </case>
</error-handling>

### 2. Quick Reality Check Analysis
**Focus on the most important insights only:**

- What's working as planned vs what changed?
- Are you ahead/behind schedule?
- Any major discoveries that change the plan?
- What should happen next?

<progress-accuracy-check>
Also check if TodoWrite completion status matches requirements file checkboxes.
Count mismatches as "progress tracking discrepancies" but only surface if 3+ found.
</progress-accuracy-check>

### 3. Concise Report Format
```
🔍 **Reality Check: [Feature Name]**

**Bottom Line:** [One sentence summary of the key insight]

**Key Findings:**
✅ [One major thing going well]
⚠️ [One key difference/challenge if any]
📈 [One insight about progress/schedule]
📊 [If 3+ checkbox mismatches: Progress tracking: X completed tasks not reflected in spec]

**Recommendation:** [Clear, specific action to take]

**Next Step:** [Exact command or action to run]

---
**📋 Details** (expand if needed):
- [Brief list of minor findings]
- [Implementation notes worth remembering]
- [Any tasks to add/remove from remaining phases]
```

### 4. Implementation Analysis Guidelines

**Focus Only On:**
- Major deviations from spec that affect remaining work
- Schedule impacts (ahead/behind/on track)
- Blocking issues that need immediate attention
- Key discoveries that change the approach

**Ignore:**
- Minor naming differences
- Implementation details that don't affect the plan
- Technical decisions that worked out fine
- Verbose comparisons of every small difference

### 5. Decision-Focused Recommendations

**Provide Clear Next Actions:**

**If ahead of schedule:**
```
**Recommendation:** Skip ahead - some future phase work is already done
**Next Step:** /user:req-next [filename] (will adjust phase tasks)
```

**If major issues found:**
```
**Recommendation:** Address critical gaps before continuing
**Next Step:** /user:req-add-task "[specific task to fix issue]"
```

**If on track:**
```
**Recommendation:** Continue as planned with minor adjustments
**Next Step:** Continue current phase work or /user:req-next when ready
```

**If scope has grown:**
```
**Recommendation:** Plan for additional phase or extended work
**Next Step:** /user:req-add-task "[new work needed]" or consider Phase 5
```

**If checkbox sync issues with other changes:**
```
**Recommendation:** Update spec to reflect learnings and fix task checkboxes
**Next Step:** Type 'yes' when prompted to update (will sync checkboxes and apply changes)
```

**If ONLY checkbox sync issues found:**
```
**Recommendation:** Quick sync needed - [X] tasks completed but not marked
**Next Step:** Run /user:req-status [filename] to verify and fix checkboxes
```

### 6. Auto-Update Spec (Only for Major Changes)
Only offer to update spec if there are **significant** changes OR checkbox sync issues:

```
🔄 **Update spec with major learnings?** (yes/no)

This will update the requirements file to reflect:
- [Only list significant changes worth documenting]
- [If applicable: Synchronize X task checkboxes to match completion status]
```

<spec-update-actions>
When user confirms update:
<action>Update requirements file with major learnings</action>
<action>If checkbox mismatches exist: Change all `- [ ]` to `- [x]` for completed tasks</action>
<action>Update "Last Updated" timestamp</action>
</spec-update-actions>

**Don't offer update for minor implementation details.**
**NEVER update phase status or progression - only /user:req-next can advance phases.**

### 7. Keep It Short
**Maximum length guidelines:**
- Bottom line: 1 sentence
- Key findings: 3 bullet points max
- Recommendation: 1 clear action
- Details section: 5 items max

**If analysis gets longer, prioritize and cut the less important parts.**

## Usage Examples

**Typical quick check:**
```bash
/user:req-review scratch/requirements-feature.md

# Output:
🔍 **Reality Check: CSV Import**
**Bottom Line:** Authentication approach changed but everything else on track.
**Key Findings:**
✅ Core import logic working as specified
⚠️ Switched from JWT to sessions (simpler)
📈 Phase 2 nearly complete, no delays
**Recommendation:** Continue with current approach
**Next Step:** Finish Phase 2 tasks, then /user:req-next
```

**When ahead of schedule:**
```bash
# Output:
🔍 **Reality Check: Migration Package**
**Bottom Line:** You're ahead - Phase 2 completed some Phase 3 work.
**Key Findings:**
✅ Effectful wrappers simpler than expected (already done)
✅ Core functionality working perfectly
📈 Can skip planned Phase 3 tasks
**Recommendation:** Move to Phase 3, skip "Create Effectful wrappers"
**Next Step:** /user:req-next (will load updated Phase 3 tasks)
```

**When checkbox sync issues found:**
```bash
# Output:
🔍 **Reality Check: API Integration**
**Bottom Line:** On track but progress tracking needs sync.
**Key Findings:**
✅ Authentication working as designed
⚠️ Rate limiting more complex than expected
📈 Phase 2 nearly complete
📊 Progress tracking: 5 completed tasks not reflected in spec
**Recommendation:** Update spec to reflect learnings and fix task checkboxes
**Next Step:** Type 'yes' when prompted to update (will sync checkboxes and apply changes)
```

## Error Handling

**No implementation started:**
```
⚠️ **No implementation detected**
Use after starting implementation and making some progress.
```

**No significant differences:**
```
✅ **Implementation matches spec closely**
**Bottom Line:** Everything proceeding as planned.
**Next Step:** Continue current phase work.
```

## Important Notes
- Designed for quick decision-making, not comprehensive documentation
- Focus on actionable insights, not detailed comparisons
- Use when you need to know "should I change course?"
- Keep output under 10 lines for main insights
- **NEVER modify phase status** - only /user:req-next can advance phases
- This command provides analysis only, not state changes