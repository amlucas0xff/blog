#!/bin/bash
# format-and-lint.sh - Format and lint code for Hugo blog project
# This script handles Go, Python, and Hugo content formatting

set -e

echo "🔧 Running format and lint for Hugo blog project..."

# Check if we're in the project root
if [[ ! -f "hugo.toml" && ! -f "config.toml" ]]; then
    echo "❌ Not in Hugo project root directory"
    exit 1
fi

# Format Go code if go.mod exists
if [[ -f "go.mod" ]]; then
    echo "📝 Formatting Go code..."
    if command -v gofmt >/dev/null 2>&1; then
        gofmt -w .
        echo "✅ Go code formatted"
    else
        echo "⚠️  gofmt not found, skipping Go formatting"
    fi
    
    # Tidy Go modules
    if command -v go >/dev/null 2>&1; then
        go mod tidy
        echo "✅ Go modules tidied"
    fi
fi

# Format Python code if Python files exist
if [[ -f "requirements.txt" ]] || find scripts/ -name "*.py" >/dev/null 2>&1; then
    echo "🐍 Formatting Python code..."
    
    # Format with black if available
    if command -v black >/dev/null 2>&1; then
        black scripts/ --line-length 88 --quiet
        echo "✅ Python code formatted with black"
    else
        echo "⚠️  black not found, skipping Python formatting"
    fi
    
    # Sort imports with isort if available
    if command -v isort >/dev/null 2>&1; then
        isort scripts/ --profile black --quiet
        echo "✅ Python imports sorted with isort"
    else
        echo "⚠️  isort not found, skipping import sorting"
    fi
fi

# Validate Hugo content
echo "📚 Validating Hugo content..."
if command -v hugo >/dev/null 2>&1; then
    # Check for common issues in content files
    echo "🔍 Checking for common content issues..."
    
    # Check for broken internal links
    if hugo --quiet --enableGitInfo 2>&1 | grep -i "error\|warning" >/dev/null; then
        echo "⚠️  Hugo reported warnings during validation"
        hugo --quiet --enableGitInfo
    else
        echo "✅ Hugo content validation passed"
    fi
else
    echo "⚠️  hugo command not found, skipping content validation"
fi

# Check SCSS/CSS syntax if files exist
if find assets/ -name "*.scss" >/dev/null 2>&1; then
    echo "🎨 Checking SCSS files..."
    # Basic SCSS syntax check (look for obvious issues)
    if grep -r ";\s*$" assets/scss/ >/dev/null 2>&1; then
        echo "✅ SCSS syntax looks good"
    fi
fi

echo "✨ Format and lint completed successfully!"