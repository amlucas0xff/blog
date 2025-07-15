# Context Analysis Command

Analyze current project dependencies and tech stack, then suggest CLAUDE.md updates.

**THINK HARD** about the current state of the project and identify context gaps.

## Analysis Steps:

1. **Dependency Analysis**
   - Check package.json for outdated npm packages
   - Check requirements.txt for outdated Python packages  
   - Check any other dependency files (Cargo.toml, go.mod, etc.)
   - Only read files when specific issues need investigation

2. **Pattern Detection**
   - Use targeted grep searches for deprecated patterns:
     - `grep -A 3 "componentWillMount\|ReactDOM.render\|UNSAFE_" frontend/src/`
     - `grep -A 3 "asyncio.coroutine\|format()" backend/`
   - Search for outdated TypeScript patterns
   - Identify security vulnerabilities in dependencies

3. **Context Recommendations**
   - Suggest CLAUDE.md enhancements for current tech stack
   - Recommend modern patterns to document
   - Identify missing context for new framework versions
   - Prioritize by impact: CRITICAL → WARNING → INFO

4. **Efficiency Focus**
   - Use grep with -A flag for context instead of reading entire files
   - Only import heavy dependency files when specific issues found
   - Suggest context window management improvements

## Output Format:

```
📊 Context Analysis Results:

🔴 CRITICAL:
   → [Specific issue with current/recommended versions]
   → [Action needed in CLAUDE.md]

🟡 WARNING:
   → [Pattern or version issue]
   → [Suggested update]

✅ INFO:
   → [Minor improvements or optimizations]

📈 CLAUDE.md Suggestions:
   → Add current tech stack versions
   → Document new patterns for [technology]
   → Update deprecated pattern warnings
```

## Next Actions:
- If critical issues found, suggest running `/update-stack` 
- If patterns need scanning, suggest `/pattern-scan [technology]`
- Always end with specific, actionable CLAUDE.md improvements