---
description: "Validate Claude Code configuration and artifacts"
arguments: "project-path (optional, defaults to current directory)"
---

# Validate Claude Code Setup

Validate the Claude Code configuration in the specified project directory following the **Single Responsibility Principle** - this command has one job: verify everything is working correctly.

## Target Directory
**Project Path:** $ARGUMENTS (or current directory if not provided)

## Validation Checklist

### Step 1: Configuration File Validation

#### 1.1 Check .claude/settings.json
!cd ${ARGUMENTS:-.} && if [ -f .claude/settings.json ]; then echo "✅ settings.json exists"; python3 -m json.tool .claude/settings.json > /dev/null 2>&1 && echo "✅ settings.json is valid JSON" || echo "❌ settings.json has invalid JSON syntax"; else echo "❌ settings.json not found"; fi

#### 1.2 Check CLAUDE.md
!cd ${ARGUMENTS:-.} && if [ -f CLAUDE.md ]; then echo "✅ CLAUDE.md exists"; grep -q "TODO\|PLACEHOLDER\|FIXME" CLAUDE.md && echo "⚠️  CLAUDE.md contains template placeholders" || echo "✅ CLAUDE.md appears complete"; else echo "❌ CLAUDE.md not found"; fi

### Step 2: Command Templates Validation

#### 2.1 Check Command Directory
!cd ${ARGUMENTS:-.} && if [ -d .claude/commands ]; then echo "✅ Commands directory exists"; ls -la .claude/commands/; else echo "❌ Commands directory not found"; fi

#### 2.2 Validate Command Files
!cd ${ARGUMENTS:-.} && find .claude/commands -name "*.md" -type f 2>/dev/null | while read cmd; do echo "📝 Found command: $cmd"; grep -q "---" "$cmd" && echo "  ✅ Has YAML frontmatter" || echo "  ⚠️  Missing YAML frontmatter"; done

### Step 3: Script Validation

#### 3.1 Check Scripts Directory
!cd ${ARGUMENTS:-.} && if [ -d scripts ]; then echo "✅ Scripts directory exists"; ls -la scripts/; else echo "❌ Scripts directory not found"; fi

#### 3.2 Validate Script Executability
!cd ${ARGUMENTS:-.} && find scripts -name "*.sh" -type f 2>/dev/null | while read script; do echo "📜 Checking script: $script"; if [ -x "$script" ]; then echo "  ✅ Executable"; else echo "  ❌ Not executable"; fi; head -1 "$script" | grep -q "#!/" && echo "  ✅ Has shebang" || echo "  ⚠️  Missing shebang"; done

### Step 4: Tool Compatibility Check

#### 4.1 Validate Detected Tools Match Configuration
Analyze what tools are referenced in the configuration vs what's actually available:

**Python Tools Check:**
!cd ${ARGUMENTS:-.} && if [ -f requirements.txt ] || [ -f pyproject.toml ]; then echo "🐍 Python project detected"; for tool in black isort flake8 pytest; do command -v $tool >/dev/null 2>&1 && echo "  ✅ $tool available" || echo "  ⚠️  $tool not installed"; done; fi

**Node.js Tools Check:**
!cd ${ARGUMENTS:-.} && if [ -f package.json ]; then echo "📦 Node.js project detected"; for tool in prettier eslint jest npm; do command -v $tool >/dev/null 2>&1 && echo "  ✅ $tool available" || echo "  ⚠️  $tool not installed"; done; fi

**Go Tools Check:**
!cd ${ARGUMENTS:-.} && if [ -f go.mod ]; then echo "🐹 Go project detected"; for tool in gofmt go; do command -v $tool >/dev/null 2>&1 && echo "  ✅ $tool available" || echo "  ⚠️  $tool not installed"; done; fi

**Rust Tools Check:**
!cd ${ARGUMENTS:-.} && if [ -f Cargo.toml ]; then echo "🦀 Rust project detected"; for tool in rustfmt cargo; do command -v $tool >/dev/null 2>&1 && echo "  ✅ $tool available" || echo "  ⚠️  $tool not installed"; done; fi

### Step 5: Hook Integration Test

#### 5.1 Test Hook Scripts
!cd ${ARGUMENTS:-.} && if [ -f .claude/settings.json ]; then echo "🪝 Testing hook script references..."; grep -o '"command":[^"]*"[^"]*"' .claude/settings.json | while read hook; do echo "Hook found: $hook"; done; fi

#### 5.2 Verify Script Dependencies
Check if scripts reference tools that are actually available in the environment.

## Validation Summary

Provide a final assessment with:

### ✅ Passing Validations
List what's working correctly

### ⚠️ Warnings
List non-critical issues that should be addressed

### ❌ Critical Issues
List problems that prevent Claude Code from working properly

### 🔧 Recommended Actions
Provide specific steps to fix identified issues

## Quick Fix Suggestions

Based on validation results, suggest:
1. **Missing Dependencies:** Commands to install required tools
2. **Permission Issues:** chmod commands to fix script permissions
3. **Configuration Errors:** Specific fixes for JSON/YAML syntax
4. **Missing Files:** Commands to generate missing artifacts

Remember: This validation follows **KISS principles** - simple checks that provide clear, actionable feedback.