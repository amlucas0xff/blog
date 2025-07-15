# Pattern Scanner Command

Scan for deprecated patterns and suggest modern alternatives.

**Usage**: `/pattern-scan [technology]` or `/pattern-scan [specific-pattern]`

**THINK** about the specific technology or pattern to analyze, then perform targeted scans.

## Scan Strategies by Technology:

### React Patterns
```bash
# Search for deprecated React patterns
grep -A 3 -r "componentWillMount\|componentWillReceiveProps\|componentWillUpdate" frontend/src/
grep -A 3 -r "UNSAFE_componentWill\|ReactDOM.render\|findDOMNode" frontend/src/
grep -A 3 -r "defaultProps\|PropTypes" frontend/src/
```

**Modern Alternatives:**
- `componentWillMount` → `useEffect(() => {}, [])`
- `ReactDOM.render` → `ReactDOM.createRoot().render()`
- `defaultProps` → Default parameters in function components
- Class components → Function components with hooks

### TypeScript Patterns  
```bash
# Search for outdated TypeScript patterns
grep -A 3 -r "any\|object\|Function" frontend/src/ --include="*.ts" --include="*.tsx"
grep -A 3 -r "namespace\|module" frontend/src/
grep -A 3 -r "as any\|<any>" frontend/src/
```

**Modern Alternatives:**
- `any` → `unknown` or specific types
- `object` → `Record<string, unknown>` or specific interface
- `namespace` → ES modules with `export`
- Type assertions → Type guards or proper typing

### Python Patterns
```bash
# Search for deprecated Python patterns  
grep -A 3 -r "asyncio.coroutine\|@asyncio.coroutine" backend/
grep -A 3 -r "format()\|%s\|%" backend/ --include="*.py"
grep -A 3 -r "from collections import" backend/
```

**Modern Alternatives:**
- `@asyncio.coroutine` → `async def`
- `"{}".format()` → f-strings `f"{}"`
- `from collections import abc` → `from collections.abc import`

### FastAPI Patterns
```bash
# Search for outdated FastAPI patterns
grep -A 3 -r "Body()\|Query()\|Path()" backend/ --include="*.py"
grep -A 3 -r "Depends()" backend/
grep -A 3 -r "BaseModel" backend/
```

**Modern Alternatives:**
- Review Pydantic v2 patterns
- Check dependency injection best practices
- Validate async endpoint patterns

## General Scanning Process:

1. **Target Search**: Use grep with -A 3 for context
2. **Pattern Analysis**: Identify why pattern is deprecated  
3. **Modern Alternative**: Suggest current best practice
4. **Impact Assessment**: Evaluate breaking change risk
5. **Action Plan**: Provide step-by-step migration

## Output Format:

```
🔍 Pattern Scan Results for: [TECHNOLOGY/PATTERN]

📍 Found deprecated pattern: [PATTERN] 
   📁 File: [filepath:line]
   📄 Context: [3 lines of context]
   ✅ Modern alternative: [replacement pattern]
   ⚠️  Breaking change risk: [HIGH/MEDIUM/LOW]

🛠️  Migration Steps:
   1. [Step 1]
   2. [Step 2] 
   3. [Step 3]

📚 Resources:
   - [Official migration guide]
   - [Community examples]
```

## Arguments Handling:

- **No args**: Scan all supported technologies
- **Technology name**: `react`, `typescript`, `python`, `fastapi`
- **Specific pattern**: `componentWillMount`, `asyncio.coroutine`, etc.
- **File path**: Scan specific file or directory

## Efficiency Notes:
- Always use targeted grep searches instead of reading entire files
- Use file type filters (--include) to avoid binary files
- Limit search scope to relevant directories (frontend/, backend/)
- Report findings concisely to preserve context window