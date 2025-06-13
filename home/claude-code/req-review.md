# File: .claude/commands/req-review.md

Review and validate the requirements document: $ARGUMENTS

Analyzes the specification against current codebase for completeness, feasibility, and potential issues.

If $ARGUMENTS is empty, look for the most recent requirements-*.md file in common directories.

## Process

### 1. Load Requirements File
- Verify the file exists and is readable
- Parse the specification content
- Check for implementation progress if available

If file not found:
```
❌ **Requirements file not found:** $ARGUMENTS

🔍 **Available requirements files:**
[List any requirements-*.md files found]

📝 **Usage:** /user:req-review [filename]
```

### 2. Codebase Compatibility Analysis
Analyze the requirements against current project state:
- Check if referenced models/entities exist
- Validate proposed API endpoints don't conflict
- Assess database schema changes for compatibility
- Review authentication/permission assumptions
- Identify potential integration conflicts

### 3. Completeness Assessment
Review specification sections for completeness:

**Technical Implementation:**
- [ ] Data flow clearly defined
- [ ] Integration points specified
- [ ] Database changes documented
- [ ] API design included (if applicable)
- [ ] Security requirements addressed
- [ ] Error handling strategy defined

**Implementation Planning:**
- [ ] Phases are appropriately scoped
- [ ] Dependencies between phases identified
- [ ] Success criteria are measurable
- [ ] Known risks documented
- [ ] Resource estimates realistic

### 4. Review Report
```
📋 **Requirements Review: [Feature Name]**

**File:** [filename]
**Reviewed:** [current date]
**Specification Quality:** [Excellent/Good/Needs Work]

### ✅ **Strengths**
- [List well-defined aspects]
- [Clear technical specifications]
- [Comprehensive error handling]

### ⚠️ **Needs Clarification**
- [Specific items needing more detail]
- [Ambiguous requirements]
- [Missing technical specifications]

### 🚨 **Potential Issues**
- [Technical conflicts with existing code]
- [Performance concerns]
- [Security gaps]
- [Integration challenges]

### 💡 **Recommendations**

**High Priority:**
- [Critical improvements to make]
- [Missing requirements to add]

**Medium Priority:**
- [Enhancements to consider]
- [Additional documentation needs]

**Low Priority:**
- [Nice-to-have improvements]
- [Future iteration considerations]
```

### 5. Codebase Specific Analysis
```
🔍 **Codebase Integration Analysis**

**Compatibility Check:**
- [✅/⚠️/❌] Existing models support proposed changes
- [✅/⚠️/❌] API patterns align with project conventions  
- [✅/⚠️/❌] Database changes are migration-safe
- [✅/⚠️/❌] Authentication approach matches current system
- [✅/⚠️/❌] No conflicts with existing endpoints/routes

**Implementation Feasibility:**
- **Complexity:** [Low/Medium/High]
- **Risk Level:** [Low/Medium/High]  
- **Estimated Effort:** [Small/Medium/Large/Epic]
- **Dependencies:** [List external dependencies or prerequisites]
```

### 6. Actionable Improvements
Based on the review, suggest specific improvements:

```
📝 **Suggested Specification Updates**

**Add Missing Sections:**
```markdown
### [Section Name]
[Specific content to add]
```

**Clarify Ambiguous Requirements:**
- Change "[vague requirement]" to "[specific requirement]"
- Add concrete examples for "[abstract concept]"

**Address Technical Gaps:**
- Specify error codes and handling for [scenario]
- Define data validation rules for [field/entity]
- Add performance requirements for [operation]
```

### 7. Auto-Update Option
If significant improvements are needed:

```
🔄 **Auto-Update Specification?**

I can update the requirements file with the recommended improvements.
This will:
- Add missing technical details
- Clarify ambiguous requirements  
- Include additional error handling scenarios
- Update implementation phases based on complexity analysis

Update specification file? (yes/no)
```

If user confirms, update the requirements file with improvements and show a diff of changes made.

### 8. Next Steps Guidance
```
🚀 **Recommended Next Steps**

**If specification is ready:**
- Start implementation: `/user:req-start [filename]`
- Check current status: `/user:req-status [filename]`

**If needs refinement:**
- Refine requirements: `/user:req-gather "[feature]" --refine`
- Address specific issues: [list priority items]

**For ongoing work:**
- Regular reviews: Run `/user:req-review [filename]` weekly during implementation
- Update based on learnings: Add new insights as you discover them
```

## Advanced Analysis Options

### Deep Technical Review
For complex features, provide additional analysis:
- Performance impact assessment
- Security vulnerability analysis  
- Scalability considerations
- Maintenance burden evaluation

### Team Collaboration Support
- Generate review checklist for team discussions
- Create GitHub issue templates from specification
- Suggest code review focus areas
- Identify knowledge sharing opportunities

### Quality Metrics
Track specification quality over time:
- Completeness score (% of sections filled)
- Implementation alignment (how well spec matches reality)
- Change frequency (stability of requirements)
- Success rate (features delivered as specified)