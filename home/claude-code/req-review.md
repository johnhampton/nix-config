# File: .claude/commands/req-review.md

Quick implementation reality check: $ARGUMENTS

Provides a concise assessment of how implementation differs from spec and what to do next.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories.

## Process

### 1. Load Requirements and Current State
- Read the requirements specification
- Check implementation progress section
- Analyze current codebase against spec assumptions

If file not found:
```
❌ **Requirements file not found**
💡 **Check available files or filename**
📝 **Usage:** /user:req-review [filename]
```

### 2. Quick Reality Check Analysis
**Focus on the most important insights only:**

- What's working as planned vs what changed?
- Are you ahead/behind schedule?
- Any major discoveries that change the plan?
- What should happen next?

### 3. Concise Report Format
```
🔍 **Reality Check: [Feature Name]**

**Bottom Line:** [One sentence summary of the key insight]

**Key Findings:**
✅ [One major thing going well]
⚠️ [One key difference/challenge if any]
📈 [One insight about progress/schedule]

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

### 6. Auto-Update Spec (Only for Major Changes)
Only offer to update spec if there are **significant** changes:

```
🔄 **Update spec with major learnings?** (yes/no)

This will update the requirements file to reflect:
- [Only list significant changes worth documenting]
```

**Don't offer update for minor implementation details.**

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