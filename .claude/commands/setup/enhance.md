---
description: "Enhance existing Claude Code setup with advanced features"
arguments: "feature-type (optional: hooks|commands|scripts|docs|all)"
---

# Enhance Claude Code Setup

Add advanced features to existing Claude Code configuration following the **Open/Closed Principle** - extend functionality without modifying existing configurations.

## Enhancement Target
**Feature Type:** $ARGUMENTS (hooks, commands, scripts, docs, or all)

## Current Configuration Check

### Step 1: Verify Existing Setup
!cd . && echo "🔍 Checking current Claude Code setup..." && ls -la .claude/ 2>/dev/null || echo "❌ No .claude directory found. Run /setup:minimal first."

!cd . && if [ -f .claude/settings.json ]; then echo "✅ Found existing settings.json"; else echo "❌ No settings.json found"; fi

!cd . && if [ -f CLAUDE.md ]; then echo "✅ Found existing CLAUDE.md"; else echo "❌ No CLAUDE.md found"; fi

### Step 2: Detect Project Technology
!echo "🔍 Detecting project technology stack..."

!find . -maxdepth 2 -name "package.json" 2>/dev/null && echo "📦 Node.js project detected"
!find . -maxdepth 2 -name "requirements.txt" -o -name "pyproject.toml" 2>/dev/null && echo "🐍 Python project detected"  
!find . -maxdepth 2 -name "go.mod" 2>/dev/null && echo "🐹 Go project detected"
!find . -maxdepth 2 -name "Cargo.toml" 2>/dev/null && echo "🦀 Rust project detected"

## Enhancement Options

Based on the **Open/Closed Principle**, select enhancements to add without modifying existing configuration:

### Option 1: Enhanced Hooks (if $ARGUMENTS contains "hooks" or "all")

Add advanced automation hooks that complement existing setup:

#### Advanced Pre-Tool Hooks
Create enhanced pre-validation that checks for:
- File permissions and ownership
- Basic security patterns (no hardcoded secrets)
- Code style compliance

#### Advanced Post-Tool Hooks  
Add intelligent post-processing:
- Auto-formatting for detected languages
- Test running for modified code
- Documentation updates

#### Implementation
!cd . && if [[ "$ARGUMENTS" == *"hooks"* ]] || [[ "$ARGUMENTS" == *"all"* ]] || [[ -z "$ARGUMENTS" ]]; then echo "🔧 Adding enhanced hooks..."; cp .claude/settings.json .claude/settings.json.backup; echo "✅ Backed up existing settings"; fi

### Option 2: Advanced Commands (if $ARGUMENTS contains "commands" or "all")

Add sophisticated command templates:

#### Technology-Specific Commands
- `/dev:test` - Smart test runner for detected frameworks
- `/dev:build` - Build command for detected project type  
- `/dev:deploy` - Deployment helper with safety checks
- `/git:sync` - Advanced git workflow automation

#### Project Management Commands
- `/project:analysis` - Codebase analysis and metrics
- `/project:refactor` - Systematic refactoring workflows
- `/project:security` - Security audit helpers

#### Implementation
!cd . && if [[ "$ARGUMENTS" == *"commands"* ]] || [[ "$ARGUMENTS" == *"all"* ]] || [[ -z "$ARGUMENTS" ]]; then echo "🔧 Adding advanced commands..."; mkdir -p .claude/commands/{dev,git,project}; echo "✅ Created command namespaces"; fi

### Option 3: Advanced Scripts (if $ARGUMENTS contains "scripts" or "all")

Enhance automation with intelligent scripts:

#### Multi-Language Formatter
Detect and format all supported languages in project:
- Python: black, isort, autoflake
- JavaScript/TypeScript: prettier, eslint --fix
- Go: gofmt, goimports
- Rust: rustfmt

#### Smart Documentation Generator
Auto-generate docs based on detected tools:
- API documentation for detected frameworks
- README generation from code comments
- Architecture diagrams from code structure

#### Implementation 
!cd . && if [[ "$ARGUMENTS" == *"scripts"* ]] || [[ "$ARGUMENTS" == *"all"* ]] || [[ -z "$ARGUMENTS" ]]; then echo "🔧 Adding advanced scripts..."; mkdir -p scripts/{format,docs,test}; echo "✅ Created script directories"; fi

### Option 4: Enhanced Documentation (if $ARGUMENTS contains "docs" or "all")

Extend CLAUDE.md with advanced sections:

#### Project-Specific Workflows
- Technology-specific best practices
- Framework-specific patterns
- Testing strategies for detected tools

#### Advanced Quality Standards
- Performance benchmarks
- Security guidelines
- Code review checklists

#### Implementation
!cd . && if [[ "$ARGUMENTS" == *"docs"* ]] || [[ "$ARGUMENTS" == *"all"* ]] || [[ -z "$ARGUMENTS" ]]; then echo "🔧 Enhancing documentation..."; cp CLAUDE.md CLAUDE.md.backup; echo "✅ Backed up existing CLAUDE.md"; fi

## Safe Enhancement Process

### Dependency Inversion Principle Application
All enhancements check for tool availability before execution:

```bash
# Example enhancement pattern
if command -v prettier >/dev/null 2>&1; then
    # Add prettier integration
else
    # Provide fallback or skip
fi
```

### Liskov Substitution Principle
Enhanced commands maintain same interface as basic ones:
- Same argument patterns
- Same output formats  
- Same error handling

## Enhancement Examples

### Enhanced Python Project
If Python detected, add:
- Black/isort/flake8 integration
- pytest with coverage reporting
- FastAPI/Django specific workflows
- Virtual environment helpers

### Enhanced Node.js Project  
If Node.js detected, add:
- Prettier/ESLint automation
- Jest/Vitest test workflows
- React/Vue component generators
- Package.json script integration

### Enhanced Go Project
If Go detected, add:
- gofmt/goimports automation
- Go test with race detection
- Module management helpers
- Cross-compilation scripts

## Rollback Safety

All enhancements create backups:
- `.claude/settings.json.backup`
- `CLAUDE.md.backup`
- `scripts/backup/` directory

Rollback command provided:
!cd . && echo "🔄 To rollback enhancements, run: cp .claude/settings.json.backup .claude/settings.json && cp CLAUDE.md.backup CLAUDE.md"

## Enhancement Summary

Provide summary of:
1. **Added Features** - List new capabilities
2. **Modified Files** - Show what was enhanced (with backups)
3. **New Commands** - Available slash commands added
4. **Next Steps** - How to use new features

**Validation Recommendation:**
Run `/setup:validate` after enhancements to ensure everything works correctly.

Remember: These enhancements follow **SOLID principles** by extending functionality without breaking existing features, making the system more capable while maintaining stability.