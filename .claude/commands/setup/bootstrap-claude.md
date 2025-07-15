---
description: "Analyze existing project and generate Claude Code best practices artifacts"
arguments: "project-path (optional, defaults to current directory)"
---

# Bootstrap Claude Code Setup

You are tasked with analyzing an existing project and generating appropriate Claude Code artifacts following Anthropic best practices using KISS (Keep It Simple) and SOLID principles.

## Project Analysis Target
**Project Directory:** $ARGUMENTS (or current directory if not provided)

## ULTRATHINK Analysis & Generation

Think deeply about the project structure, technology stack, and appropriate Claude Code configuration before proceeding.

## Instructions

### Step 1: Quick Project Analysis
Analyze the target directory and identify:

**Technology Indicators:**
!ls -la $ARGUMENTS 2>/dev/null || ls -la .

**Package Files Check:**
!find ${ARGUMENTS:-.} -maxdepth 2 -name "package.json" -o -name "requirements.txt" -o -name "go.mod" -o -name "Cargo.toml" -o -name "pom.xml" -o -name "build.gradle" 2>/dev/null

**Directory Structure:**
!find ${ARGUMENTS:-.} -maxdepth 2 -type d | head -20

Based on the analysis:
1. Identify main programming languages and frameworks
2. Determine appropriate development tools and workflows
3. Note any existing Claude Code configuration to avoid conflicts

### Step 2: Generate Core Artifacts

Following the **Single Responsibility Principle**, create each artifact with one clear purpose:

#### 2.1 Create .claude/settings.json
Generate a settings.json file appropriate for the detected technology stack with:
- Safe hooks for identified languages (Python: black/pytest, Node.js: prettier/jest, Go: gofmt, etc.)
- Reasonable permissions for detected tools
- Simple pre/post automation that won't break workflows

#### 2.2 Create CLAUDE.md
Generate a CLAUDE.md file containing:
- Technology-specific recommendations based on findings
- Appropriate thinking modes guidance for the project type
- Workflow patterns relevant to the detected stack
- Quality standards for identified languages
- Development commands for found tools

#### 2.3 Create Essential Command Templates
Generate simplified versions of:
- `ultraplan.md` - Strategic planning with sub-agents for detected architecture
- `tdd-cycle.md` - Test-driven development for identified testing frameworks
- `parallel-implement.md` - Parallel development tailored to project structure

### Step 3: Create Essential Automation Scripts

Generate practical scripts in a `scripts/` directory:

#### 3.1 format-and-lint.sh
Create a script that formats and lints code for detected languages:
- Python: black, isort, flake8 (if requirements.txt found)
- TypeScript/JavaScript: prettier, eslint (if package.json found)
- Go: gofmt, golangci-lint (if go.mod found)
- Rust: rustfmt, clippy (if Cargo.toml found)

#### 3.2 generate-docs.sh
Create documentation generation script with intelligent fallbacks:
- Sphinx/MkDocs for Python projects
- TypeDoc/JSDoc for JavaScript/TypeScript
- godoc for Go projects
- cargo doc for Rust projects

#### 3.3 pre-validation.sh
Create basic pre-commit validation:
- File permission checks
- Basic syntax validation for detected languages
- Security scan reminders

### Step 4: Implement SOLID Principles

**Open/Closed Principle:** Generate extensible configurations that can be enhanced without modification
**Interface Segregation:** Create small, focused scripts and commands
**Dependency Inversion:** Make scripts work with abstractions (check for tool existence before running)

## Generation Guidelines

**KISS Principles:**
- Generate only what's immediately useful
- Use working defaults, not complex configurations
- Prefer simple, readable configurations
- Avoid over-engineering

**Safety First:**
- Never overwrite existing .claude/ configurations
- Check for existing files before creation
- Provide clear feedback about what was created
- Generate executable scripts with proper permissions

**Technology-Aware Generation:**
- Python projects: Focus on pytest, black, FastAPI/Django patterns
- Node.js projects: Emphasize npm scripts, jest, React/Vue patterns  
- Go projects: Include go mod, testing, clean architecture patterns
- Rust projects: Cargo workflows, ownership patterns, safety practices

## Output Format

Provide a summary of:
1. **Detected Technology Stack**
2. **Generated Files** (with brief description of each)
3. **Next Steps** (how to use the generated artifacts)
4. **Customization Suggestions** (project-specific improvements)

Remember: The goal is to create a **working, immediately useful** Claude Code setup that follows best practices while remaining simple and maintainable.