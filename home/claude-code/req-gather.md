# File: .claude/commands/req-gather.md

You are conducting an interactive requirements gathering session for: **$ARGUMENTS**

If $ARGUMENTS is empty, respond with:
```
❌ **Usage:** /user:req-gather "feature description"
📝 **Example:** /user:req-gather "CSV chapter import"
```

## Phase 1: Codebase Analysis

Quickly analyze the project structure to understand:
- Main domain models and data structures
- Authentication patterns (JWT, sessions, etc.)
- Database/ORM approach
- API framework and patterns
- File organization conventions

Present findings concisely:
```
🔍 **Project Context**
Domain: [Brief description]
Models: [Key entities found]
Auth: [Authentication approach]
Data: [Database/ORM type]
Framework: [Main framework/language]
```

## Phase 2: Interactive Interview

**IMPORTANT:** Ask ONE question at a time and wait for the user's response. Do not ask multiple questions in a single response.

Generate 4-6 targeted questions based on:
- The feature request "$ARGUMENTS"  
- Your codebase analysis findings
- Integration points with existing code
- Security and permissions requirements
- Data handling and validation needs
- Error scenarios and edge cases

**Question Format:**
```
> **Q[N]:** [Context from codebase] [Specific question]?
```

**Question Strategy:**
- Reference specific models, files, or patterns you found
- Ask about data mappings and transformations
- Clarify permissions and access control
- Address integration with existing workflows
- Cover error handling and edge cases
- Consider performance and scalability

**Example Questions:**
- "I see your User model has both email and username fields. Which should the CSV use for author lookups?"
- "Your API uses role-based permissions. Should this feature require admin access or specific roles?"
- "You have validation rules for X. Should imports follow the same validation or have relaxed rules?"

## Phase 3: Specification Generation

After gathering all responses, create a comprehensive technical specification:

**File Location Strategy:**
1. Read CLAUDE.md from the project root if it exists
2. Scan for lines containing "temporary", "temp", "scratch", or directory preferences
3. Look for directory patterns like:
   - "Use `directory/` for temporary files"
   - "Use directory/ for temp files" 
   - Any mention of scratch/, tmp/, temp/, docs/ in context of temporary/project files
4. Extract the directory name (including trailing slash)
5. Use: `[extracted-directory]requirements-[slugified-feature].md`
6. If no CLAUDE.md or no directory found, default to: `tmp/requirements-[slugified-feature].md`

**Parsing Logic:**
First try to read ./CLAUDE.md file. If it exists, scan each line for:
- Lines containing "scratch" or "temporary" or "temp" 
- Extract directory names from backticks: `scratch/`
- Extract directory names from quotes: "scratch/"
- Look for pattern "Use X for" where X contains a directory
If multiple directories found, prefer: scratch/ > tmp/ > temp/ > docs/

**Specification Template:**
```markdown
# Technical Specification: $ARGUMENTS

## Overview
[Brief summary of feature and purpose]

## Requirements Gathered
[Summary of user responses from interview]

## Technical Implementation

### Data Flow
1. [Step-by-step process description]
2. [Include validation, transformation, storage steps]  
3. [Error handling at each step]

### Integration Points
- [How it connects to existing models/services]
- [Dependencies on current code]
- [Potential conflicts or breaking changes]

### Database Changes
- [Schema modifications needed]
- [New tables, columns, relationships]
- [Migration considerations]

### API Design (if applicable)
```
[HTTP method] /api/[endpoint]
Headers: [authentication requirements]
Body: [request format]
Response: [success format]
Errors: [error codes and messages]
```

### Security & Permissions
- [Authentication requirements]
- [Authorization rules and checks]
- [Data validation requirements]
- [Input sanitization needs]

### Error Handling Strategy
- [Input validation errors]
- [Business logic failures]
- [System integration failures]
- [User-facing error messages]

## Implementation Phases

### Phase 1: Foundation (Start Here)
- [Database setup and dependencies]
- [Basic structure and scaffolding]
- [Authentication/permission framework]

### Phase 2: Core Logic
- [Main business logic implementation]
- [Data processing and validation]
- [Integration with existing systems]

### Phase 3: API & Integration
- [API endpoints and handlers]
- [Frontend integration points]
- [External service connections]

### Phase 4: Testing & Polish
- [Unit and integration tests]
- [Error handling and edge cases]
- [Performance optimization]
- [Documentation updates]

## Implementation Strategy

### Quality Assurance Approach
- Use sub-agents during implementation for specialized review and validation
- Spawn sub-agents to investigate alternative approaches for complex problems
- Consider multiple perspectives: security, performance, maintainability, testing

### Sub-Agent Integration Points
- **Phase 1:** Sub-agents for architecture and dependency validation
- **Phase 2:** Sub-agents for business logic verification and edge case analysis  
- **Phase 3:** Sub-agents for security review and API design validation
- **Phase 4:** Sub-agents for comprehensive testing strategy and deployment review

## Success Criteria
- [Specific, testable acceptance criteria]

## Known Risks
- [Technical risks and mitigation strategies]

## Notes
- Generated: [current date]
- Interview responses: [summary of key decisions]
```

## Completion Message

```
📄 **Specification Complete**
✅ Saved: [filename]

🚀 **Next Steps:**
1. Review the specification for completeness
2. Run: /user:req-start [filename]
3. Begin Phase 1 development

💡 **Pro tip:** The spec file will track your progress through the implementation phases.
```
