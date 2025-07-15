---
description: "Create minimal Claude Code setup with safe defaults"
arguments: "project-path (optional, defaults to current directory)"
---

# Minimal Claude Code Setup

Create the absolute essentials for Claude Code following **KISS principles** - generate only what's needed for basic functionality, nothing more.

## Target Directory
**Project Path:** $ARGUMENTS (or current directory if not provided)

## Minimal Setup Strategy

This command implements the **Interface Segregation Principle** by providing only the core interfaces needed for Claude Code functionality.

### Step 1: Verify Target Directory
!cd ${ARGUMENTS:-.} && pwd && echo "Setting up minimal Claude Code configuration in: $(pwd)"

### Step 2: Create Basic Directory Structure

#### 2.1 Create .claude Directory
!cd ${ARGUMENTS:-.} && mkdir -p .claude/commands && echo "✅ Created .claude/ directory structure"

#### 2.2 Create Scripts Directory  
!cd ${ARGUMENTS:-.} && mkdir -p scripts && echo "✅ Created scripts/ directory"

### Step 3: Generate Minimal settings.json

Create the simplest possible settings.json that works:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '📝 Claude Code session complete. Consider committing your changes: git add -A && git commit -m \"Your message\"'"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Edit",
      "Write", 
      "MultiEdit",
      "Read",
      "Bash(git:*)",
      "Task"
    ]
  }
}
```

#### Write Minimal Settings
!cd ${ARGUMENTS:-.} && cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "echo '📝 Claude Code session complete. Consider committing your changes: git add -A && git commit -m \"Your descriptive message here\"'"
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Edit",
      "Write", 
      "MultiEdit",
      "Read",
      "Bash(git:*)",
      "Task"
    ]
  }
}
EOF

!cd ${ARGUMENTS:-.} && echo "✅ Created minimal settings.json"

### Step 4: Generate Basic CLAUDE.md

Create a minimal CLAUDE.md with core principles only:

!cd ${ARGUMENTS:-.} && cat > CLAUDE.md << 'EOF'
# Claude Code Configuration

## Core Principles
1. **Iteration is Key**: First version is good, 2-3 iterations make it excellent
2. **Clear Communication**: Be concise and direct in all interactions  
3. **Quality Focus**: Write clean, well-tested, maintainable code
4. **Documentation**: Keep docs close to the code they describe

## Thinking Modes
- Use **"think"** for simple modifications
- Use **"think hard"** for debugging and complex changes
- Use **"think harder"** for architectural decisions

## Basic Workflow
1. **Read** relevant files to understand context
2. **Plan** your approach before implementing
3. **Code** with continuous verification
4. **Test** your changes
5. **Commit** with clear, descriptive messages

## Development Commands
- `git status` - Check repository status
- `git add .` - Stage changes
- `git commit -m "message"` - Commit with message

## Quality Standards
- Write clear, readable code
- Add comments for complex logic
- Test your changes before committing
- Use meaningful variable and function names

This is a minimal setup. Customize based on your project's specific needs.
EOF

!cd ${ARGUMENTS:-.} && echo "✅ Created basic CLAUDE.md"

### Step 5: Create Essential Command Template

Generate one simple, useful command:

!cd ${ARGUMENTS:-.} && cat > .claude/commands/commit.md << 'EOF'
---
description: "Review changes and create a commit"
---

# Review and Commit Changes

## Current Repository Status
!git status

## Recent Changes
!git diff --stat

## Instructions
Based on the changes shown above:

1. Review all modifications carefully
2. Ensure changes are logically grouped
3. Write a clear, descriptive commit message
4. Create the commit with: `git add -A && git commit -m "Your descriptive message"`

Focus on explaining WHY the changes were made, not just WHAT was changed.
EOF

!cd ${ARGUMENTS:-.} && echo "✅ Created basic commit command"

### Step 6: Create Simple Scripts

#### 6.1 Basic Status Script
!cd ${ARGUMENTS:-.} && cat > scripts/status.sh << 'EOF'
#!/bin/bash
echo "📊 Project Status Check"
echo "======================="

echo "📁 Current Directory: $(pwd)"
echo "🌿 Git Branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repository')"
echo "📝 Git Status:"
git status --short 2>/dev/null || echo "  No git repository found"

echo ""
echo "📚 Available Claude Commands:"
find .claude/commands -name "*.md" 2>/dev/null | sed 's/.*commands\//  \//' | sed 's/\.md$//' || echo "  No commands found"
EOF

!cd ${ARGUMENTS:-.} && chmod +x scripts/status.sh && echo "✅ Created executable status.sh script"

### Step 7: Verification

#### 7.1 Validate JSON Syntax
!cd ${ARGUMENTS:-.} && python3 -m json.tool .claude/settings.json > /dev/null 2>&1 && echo "✅ settings.json syntax is valid" || echo "❌ settings.json has syntax errors"

#### 7.2 Check File Permissions
!cd ${ARGUMENTS:-.} && ls -la scripts/ && echo "✅ Script permissions verified"

## Minimal Setup Summary

**Generated Files:**
- `.claude/settings.json` - Basic hooks and permissions
- `CLAUDE.md` - Core principles and simple workflow
- `.claude/commands/commit.md` - Essential commit helper
- `scripts/status.sh` - Simple project status checker

**Key Features:**
- ✅ Safe defaults that won't break existing workflows
- ✅ Essential Claude Code functionality
- ✅ No complex dependencies or configurations
- ✅ Easy to understand and modify
- ✅ Follows SOLID principles with clear separation

**Next Steps:**
1. Test the setup: `/setup:validate`
2. Try the commit command: `/commit`
3. Run status check: `./scripts/status.sh`
4. Customize CLAUDE.md for your specific project needs

**Enhancement Options:**
- Use `/setup:enhance` to add advanced features
- Use `/setup:bootstrap-claude` for full technology-aware setup
- Manually add project-specific commands as needed

This minimal setup provides a solid foundation that you can build upon as your needs grow.