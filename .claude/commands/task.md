---
description: "Task manager tool via tasks.md"
arguments: "One or more development tasks"
---

# Task Manager

Execute Task Creation for the following request: $ARGUMENTS

## Mandatory Structure
- `tasks.md` - **Single source of truth** for all tasks
- `activeContext.md` - Current focus and active work
- `progress.md` - Implementation status tracking

### tasks.md Template
```markdown
# Tasks - Single Source of Truth

## Active Tasks
- [ ] [Task description] (Priority: High/Medium/Low)

## Completed Tasks
- [x] [Completed task]

## Blocked Tasks
- [ ] [Blocked task] - BLOCKED: [reason]

## Notes
[Additional context or notes]
```
### Progress Tracking
- Update tasks.md regularly as well progress.md
- Mark completed items
- Note any blockers or issues
- Maintain clear status

## Next Steps for Tasks Management
1. Create tasks.md if it doesnt not exist
2. Determine complexity level
3. Update tasks.md with initial task breakdown
4. Provide clear next mode recommendation

### Validation Checkpoints
- All planned changes were proposed
- Code quality standards met
- Testing completed successfully
- tasks.md reflects current status