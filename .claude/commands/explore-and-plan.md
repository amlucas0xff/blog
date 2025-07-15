---
description: "A workflow for complex problems that emphasizes understanding before action and structured development."
arguments: "One or more development tasks"
---

# Explore and Plan

A workflow for complex problems that emphasizes understanding before action and structured development.
Execute this workflow for the following: $ARGUMENTS

## Overview
This workflow is ideal for complex development tasks where requirements are not immediately clear or when working with unfamiliar codebases. It promotes thorough analysis and planning before implementation.

## Workflow Phases

### Phase 1: EXPLORE 🔍
**Objective:** Understand the problem, codebase, and context without making changes.

#### Key Activities:
- **Read relevant files** to understand current implementation
- **Analyze codebase structure** and patterns
- **Review existing documentation** and comments
- **Understand dependencies** and integration points
- **Identify similar implementations** for reference
- **Research external requirements** or constraints

#### Commands to Use:
```bash
# Read files for understanding
claude read /path/to/relevant/files

# Search codebase for patterns
claude grep "search_pattern" --type js

# Explore directory structure
claude ls /path/to/project --recursive

# Fetch external documentation
claude fetch https://docs.example.com/api
```

#### Exploration Checklist:
- [ ] Problem requirements clearly understood
- [ ] Existing codebase patterns identified
- [ ] Dependencies and constraints documented
- [ ] Similar implementations found and analyzed
- [ ] Potential challenges identified
- [ ] Architecture decisions understood

#### Use Subagents:
Consider using the Task tool for focused investigation:
```bash
# Let subagent investigate specific areas
claude task "Analyze the authentication system implementation"
claude task "Research best practices for this type of feature"
```

#### Important Notes:
- **Do NOT write any code yet**
- **Do NOT make any file changes**
- **Focus entirely on understanding**
- **Document your findings for the planning phase**

### Phase 2: PLAN 📋
**Objective:** Create a comprehensive implementation strategy based on exploration findings.

#### Key Activities:
- **Use thinking allocation:** Keywords like 'think', 'think hard', 'think harder', or 'ultrathink'
- **Break down the problem** into manageable components
- **Design the solution architecture** at a high level
- **Identify implementation phases** and their dependencies
- **Plan testing strategy** and validation approach
- **Document potential risks** and mitigation strategies

#### Planning Process:
```markdown
## Implementation Plan

### Problem Analysis
[Summary of problem from exploration phase]

### Solution Approach
[High-level strategy and methodology]

### Implementation Phases
1. **Phase 1:** [Description] - [Estimated effort]
2. **Phase 2:** [Description] - [Estimated effort]  
3. **Phase 3:** [Description] - [Estimated effort]

### Technical Decisions
- [Decision 1] - [Rationale]
- [Decision 2] - [Rationale]

### Dependencies
- [External dependency 1]
- [Internal dependency 2]

### Risk Assessment
- [Risk 1] - [Likelihood: High/Medium/Low] - [Mitigation strategy]
- [Risk 2] - [Likelihood: High/Medium/Low] - [Mitigation strategy]

### Testing Strategy
- [Unit testing approach]
- [Integration testing plan]
- [Manual testing requirements]

### Success Criteria
- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]
```

#### Planning Enhancement:
- **Use multiple thinking rounds** for complex problems
- **Consider alternative approaches** and compare trade-offs
- **Think through edge cases** and error conditions
- **Plan for maintainability** and future extensibility