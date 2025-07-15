# Tech Stack Update Command

Update CLAUDE.md with current dependency versions and modern patterns.

**THINK** about the current tech stack and systematically update the CLAUDE.md file.

## Update Process:

1. **Current Tech Stack Analysis**
   - Read package.json to get frontend dependencies
   - Read requirements.txt to get backend dependencies
   - Check for other dependency files if needed
   - Identify version gaps and critical updates

2. **CLAUDE.md Enhancement**
   - Add/update "CURRENT TECH STACK" section with actual versions
   - Document critical version updates needed
   - Add modern patterns for current framework versions
   - Update deprecated pattern warnings
   - Refresh command examples for current tools

3. **Pattern Updates**
   - Document modern React patterns (hooks, concurrent features)
   - Add current TypeScript best practices (5.x features)
   - Include FastAPI/Python 3.11+ patterns
   - Update testing patterns for current framework versions

4. **Context Optimization**
   - Add context loading strategies
   - Document when to use grep vs full file reads
   - Include subagent usage patterns for current stack

## Sections to Add/Update in CLAUDE.md:

```markdown
## CURRENT TECH STACK (Last Updated: [DATE])
### Frontend
- React: [current] → [latest] ([update priority])
- TypeScript: [current] → [latest] ([update priority])  
- [Other frontend deps]

### Backend  
- Python: [version]
- FastAPI: [current] → [latest] ([update priority])
- [Other backend deps]

### Critical Updates Needed
- [List critical security/breaking changes]
- [Migration notes for major version bumps]

## MODERN PATTERNS (Auto-Updated)
### React (Current Version)
- Use hooks over class components
- Prefer function components with TypeScript
- Use Suspense for data fetching
- [Version-specific patterns]

### TypeScript (Current Version)  
- Use strict mode configuration
- Leverage utility types (Record, Pick, Omit)
- Prefer `unknown` over `any`
- [Version-specific features]

### Python/FastAPI (Current Version)
- Use async/await consistently
- Leverage type hints with Pydantic v2
- Use dependency injection patterns
- [Version-specific features]

## CONTEXT LOADING STRATEGY
- Use `grep -A 3` for targeted searches instead of full file reads
- Import heavy context only when specific issues identified  
- Clear context with /clear between major tasks
- Use subagents for parallel tech stack analysis
```

## Execution Steps:
1. Analyze current dependency files
2. Update CLAUDE.md with findings
3. **COMMIT** the updated CLAUDE.md with message: "docs: update tech stack context with current versions"
4. Report what was updated and any critical actions needed

**Remember**: This command should result in an actual commit to preserve the context updates.