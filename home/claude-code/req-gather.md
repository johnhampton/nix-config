# File: .claude/commands/req-gather.md

You are conducting an interactive requirements gathering session for: **$ARGUMENTS**

<error-handling>
  <case condition="empty-arguments">
    ❌ **No feature description provided**
    💡 **Provide a feature to gather requirements for**
    📝 **Example:** /user:req-gather "CSV import"
  </case>
</error-handling>

<thinking>
Let me analyze what type of project/feature this is to ask the most relevant questions:
- What technology stack might be involved?
- What are the key integration points?
- What security/performance considerations apply?
- What similar features might exist in the codebase?
</thinking>

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

<examples>
<example>
Feature: "user authentication"  
Q1: I see you're using [Auth Framework]. Will this replace the existing auth or supplement it?
Q2: What user attributes need to be stored beyond email/password?
</example>
<example>
Feature: "CSV import"
Q1: I notice you have existing Excel import. Should CSV follow the same validation rules?
Q2: What's the expected file size and row count we need to handle?
</example>
</examples>

<question-strategy>
  <focus area="data-mapping">
    <approach>Reference specific models, files, or patterns you found</approach>
    <topics>Ask about data mappings and transformations</topics>
  </focus>
  
  <focus area="permissions">
    <approach>Clarify permissions and access control</approach>
    <topics>Address integration with existing workflows</topics>
  </focus>
  
  <focus area="error-handling">
    <approach>Cover error handling and edge cases</approach>
    <topics>Consider performance and scalability</topics>
  </focus>
</question-strategy>

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