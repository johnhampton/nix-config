# File: .claude/commands/req-review.md

Review and validate requirements against current implementation: $ARGUMENTS

Compares the specification with actual codebase to identify gaps, mismatches, and needed updates based on implementation discoveries.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories.

## Process

### 1. Load Requirements and Implementation Status
- Read the requirements specification
- Check implementation progress section
- Identify current phase and completed work
- Analyze codebase changes since implementation started

If file not found:
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Available requirements files:**
[List any requirements-*.md files found]

📝 **Usage:** /user:req-review [filename]
```

### 2. Spec vs Reality Analysis
**Compare planned vs actual implementation:**

**Database & Schema:**
- Check if implemented schema matches spec requirements
- Identify additional tables/columns added during implementation
- Note any schema decisions that differ from original plan

**API & Integration:**
- Compare implemented endpoints with spec design
- Check if authentication/authorization matches plan
- Identify integration patterns that evolved during development

**Business Logic:**
- Validate core functionality against spec requirements
- Note complexity discoveries that weren't anticipated
- Check if error handling matches spec assumptions

**Dependencies & Architecture:**
- Compare actual dependencies with spec recommendations
- Note architectural decisions made during implementation
- Identify performance considerations discovered

### 3. Implementation Discovery Analysis
**Identify what you've learned during development:**

```
🔍 **Implementation Reality Check: [Feature Name]**

**File:** [filename]
**Current Phase:** [Phase N: Phase Name]
**Review Date:** [current date]

### 📊 Spec vs Implementation Alignment

**✅ Matches Specification:**
- [List areas where implementation follows spec exactly]
- [Database design as planned]
- [API structure as specified]

**⚠️ Implementation Differs from Spec:**
- [Specific differences found]
- [Architectural decisions that changed]
- [Dependencies that were swapped/added]
- [Error handling that became more complex]

**🆕 Discovered During Implementation:**
- [Edge cases not in original spec]
- [Performance considerations not anticipated]
- [Integration challenges not foreseen]
- [Security requirements that emerged]

### 🔧 Gap Analysis

**Missing from Spec:**
- [Features you built but weren't specified]
- [Error scenarios you had to handle]
- [Performance optimizations you added]
- [Configuration options you needed]

**Spec Items Not Yet Implemented:**
- [Requirements still pending]
- [Features that may no longer be needed]
- [Designs that need updating based on learnings]

**Changed Priorities:**
- [Things that turned out easier/harder than expected]
- [Features that became more/less important]
- [Technical debt that needs addressing]
```

### 4. Impact on Remaining Phases
**Analyze how discoveries affect future work:**

**Phase Impact Assessment:**
- Review remaining phase tasks against implementation learnings
- Identify tasks that are no longer needed
- Suggest new tasks based on discoveries
- Assess if phase scope needs adjustment

**Updated Effort Estimates:**
- Note areas that are more/less complex than anticipated
- Identify new risks discovered during implementation
- Suggest timeline adjustments based on actual complexity

### 5. Recommendations and Next Steps
```
💡 **Recommendations Based on Implementation Learnings**

### 🎯 High Priority Updates
**Spec Changes Needed:**
- [Critical updates to requirements based on reality]
- [New error handling scenarios to document]
- [Performance requirements that emerged]

**Remaining Phase Adjustments:**
- [Tasks to add to current phase]
- [Tasks to remove from future phases]
- [New phases needed for discovered work]

### 📋 Medium Priority Considerations
**Documentation Updates:**
- [API documentation that needs updating]
- [Architecture decisions to document]
- [Configuration guides needed]

**Technical Debt:**
- [Code quality issues to address]
- [Refactoring opportunities identified]
- [Performance optimizations to consider]

### 🔮 Future Considerations
**Lessons for Next Time:**
- [Assumptions that proved wrong]
- [Areas to investigate more thoroughly upfront]
- [Patterns that worked well]
```

### 6. Auto-Update Option
If significant learnings are identified:

```
🔄 **Update Requirements with Implementation Learnings?**

I can update the requirements file to reflect:
- Implementation differences discovered
- New error handling scenarios
- Performance considerations learned
- Additional tasks needed for remaining phases

This will help keep the spec aligned with reality for future reference.

**Update specification file with learnings?** (yes/no)
```

If user confirms, update the requirements file with:
- New sections for discovered requirements
- Updated phase tasks based on learnings
- Implementation notes section
- Revised risk assessments

### 7. Next Steps Guidance
```
🚀 **Recommended Next Steps**

**If major gaps found:**
- Address critical spec misalignments first
- Update remaining phase plans before proceeding
- Consider adding tasks: `/user:req-add-task "task based on review findings"`

**If minor adjustments needed:**
- Continue current phase with noted considerations
- Plan to update documentation during polish phase
- Monitor for additional discoveries

**For ongoing development:**
- Run `/user:req-review [filename]` at end of each phase
- Update spec when making significant implementation decisions
- Use learnings to improve future project planning

**Phase Management:**
- Continue current phase: `/user:req-resume [filename]`
- Ready to advance: `/user:req-next [filename]`
- Add discovered tasks: `/user:req-add-task "description"`
```

## Advanced Implementation Analysis

### Code Pattern Recognition
- Identify coding patterns that emerged during implementation
- Note architectural decisions that proved effective
- Document integration approaches that worked well

### Performance Reality Check
- Compare assumed vs actual performance characteristics
- Identify bottlenecks discovered during implementation
- Note optimization opportunities found

### Security Implementation Review
- Validate security measures against spec assumptions
- Note additional security considerations discovered
- Check if threat model assumptions proved accurate

### User Experience Learnings
- Compare planned vs actual user interaction patterns
- Note usability insights gained during implementation
- Identify UX improvements needed

## Error Handling

**No implementation progress found:**
```
⚠️ **No implementation progress detected**

This appears to be a fresh specification. Use `/user:req-review` after:
- Starting implementation with `/user:req-start [filename]`
- Making progress through at least Phase 1
- Discovering differences between plan and reality
```

**Codebase analysis issues:**
```
⚠️ **Cannot analyze current codebase changes**
- Proceeding with specification-only review
- For full implementation comparison, ensure access to project files
- Manual comparison may be needed for some findings
```

## Usage Examples

**Mid-implementation review:**
```bash
# After completing Phase 1, before starting Phase 2
/user:req-review scratch/requirements-csv-import.md

# After discovering complexity in Phase 2  
/user:req-review

# Before final phase to validate remaining work
/user:req-review scratch/requirements-csv-import.md
```

**Important Notes:**
- Most valuable when called mid-implementation, not immediately after req-gather
- Helps evolve specifications based on implementation discoveries
- Perfect for identifying scope creep and technical debt
- Use regularly to keep plans aligned with development reality