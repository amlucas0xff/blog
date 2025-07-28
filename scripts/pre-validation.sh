#!/bin/bash
# pre-validation.sh - Pre-edit validation for Hugo blog project
# Runs basic checks before file modifications to prevent common issues

set -e

echo "🔍 Running pre-validation checks..."

# Check if we're in the project root
if [[ ! -f "hugo.toml" && ! -f "config.toml" ]]; then
    echo "❌ Not in Hugo project root directory"
    exit 1
fi

# File permission checks
echo "📁 Checking file permissions..."

# Check that content directory is writable
if [[ ! -w "content/" ]]; then
    echo "❌ Content directory is not writable"
    exit 1
fi

# Check that scripts directory is writable
if [[ -d "scripts/" ]] && [[ ! -w "scripts/" ]]; then
    echo "❌ Scripts directory is not writable"
    exit 1
fi

# Ensure critical directories exist
for dir in "content/posts" "static/images" "assets/scss"; do
    if [[ ! -d "$dir" ]]; then
        echo "📂 Creating missing directory: $dir"
        mkdir -p "$dir"
    fi
done

# Hugo configuration validation
echo "⚙️  Validating Hugo configuration..."

# Check for critical Hugo config files
config_found=false
for config_file in "hugo.toml" "config.toml" "config/_default/config.toml"; do
    if [[ -f "$config_file" ]]; then
        config_found=true
        echo "✅ Found Hugo config: $config_file"
        break
    fi
done

if [[ "$config_found" == false ]]; then
    echo "❌ No Hugo configuration file found"
    exit 1
fi

# Basic Hugo syntax check if hugo is available
if command -v hugo >/dev/null 2>&1; then
    echo "🏗️  Testing Hugo build..."
    if hugo --quiet --dry-run >/dev/null 2>&1; then
        echo "✅ Hugo configuration is valid"
    else
        echo "⚠️  Hugo configuration may have issues"
        hugo --quiet --dry-run 2>&1 | head -5
    fi
else
    echo "⚠️  hugo command not found, skipping config validation"
fi

# Python environment check
if [[ -f "requirements.txt" ]]; then
    echo "🐍 Checking Python environment..."
    
    if command -v python3 >/dev/null 2>&1; then
        # Check if required Python packages are available
        missing_packages=()
        while IFS= read -r line; do
            package=$(echo "$line" | sed 's/[>=<].*//' | tr -d ' ')
            if [[ -n "$package" ]] && ! python3 -c "import $package" >/dev/null 2>&1; then
                missing_packages+=("$package")
            fi
        done < requirements.txt
        
        if [[ ${#missing_packages[@]} -gt 0 ]]; then
            echo "⚠️  Missing Python packages: ${missing_packages[*]}"
            echo "💡 Run: pip install -r requirements.txt"
        else
            echo "✅ Python environment is ready"
        fi
    else
        echo "⚠️  python3 not found, skipping Python checks"
    fi
fi

# Git repository check
if [[ -d ".git" ]]; then
    echo "📚 Checking git repository status..."
    
    # Check for large files that shouldn't be committed
    large_files=$(find . -type f -size +10M 2>/dev/null | grep -v ".git/" | head -5)
    if [[ -n "$large_files" ]]; then
        echo "⚠️  Found large files (>10MB):"
        echo "$large_files"
        echo "💡 Consider adding to .gitignore or using Git LFS"
    fi
    
    # Check for common sensitive files
    sensitive_patterns=("*.key" "*.pem" "*.env" "*secret*" "*password*")
    for pattern in "${sensitive_patterns[@]}"; do
        sensitive_files=$(find . -name "$pattern" -not -path "./.git/*" 2>/dev/null | head -3)
        if [[ -n "$sensitive_files" ]]; then
            echo "🔒 Found potentially sensitive files:"
            echo "$sensitive_files"
            echo "💡 Ensure these are in .gitignore"
        fi
    done
else
    echo "⚠️  Not a git repository"
fi

# Content validation
echo "📝 Validating content structure..."

# Check for posts without proper front matter
content_issues=()
if [[ -d "content/posts" ]]; then
    for post in content/posts/*/index.md; do
        if [[ -f "$post" ]]; then
            if ! head -10 "$post" | grep -q "^---$"; then
                content_issues+=("$post: Missing front matter")
            fi
            
            if ! grep -q "^title:" "$post"; then
                content_issues+=("$post: Missing title")
            fi
            
            if ! grep -q "^date:" "$post"; then
                content_issues+=("$post: Missing date")
            fi
        fi
    done
fi

if [[ ${#content_issues[@]} -gt 0 ]]; then
    echo "⚠️  Content issues found:"
    printf '%s\n' "${content_issues[@]}"
else
    echo "✅ Content structure looks good"
fi

# Theme validation
if [[ -d "themes" ]]; then
    echo "🎨 Checking theme structure..."
    
    theme_count=$(find themes/ -maxdepth 1 -type d | wc -l)
    if [[ $theme_count -gt 2 ]]; then
        echo "⚠️  Multiple themes found - ensure only one is active"
    fi
    
    # Check for theme.toml in active theme
    active_theme=$(find themes/ -maxdepth 1 -type d | tail -1)
    if [[ -d "$active_theme" ]] && [[ ! -f "$active_theme/theme.toml" ]]; then
        echo "⚠️  Active theme missing theme.toml"
    fi
else
    echo "⚠️  No themes directory found"
fi

# Security checks
echo "🔒 Running security checks..."

# Check for potential script injection in content
if grep -r "<script" content/ >/dev/null 2>&1; then
    echo "⚠️  Found <script> tags in content - review for security"
fi

# Check for hardcoded URLs that should be relative
if grep -r "http://localhost" content/ config/ >/dev/null 2>&1; then
    echo "⚠️  Found hardcoded localhost URLs - use relative URLs instead"
fi

echo "✅ Pre-validation completed successfully!"
echo "💡 Ready for file modifications"