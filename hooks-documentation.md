# Git Hooks Documentation

## Pre-commit Hook

The pre-commit hook is located at `.git/hooks/pre-commit` and performs the following actions:

### What it does:
1. **Build Verification**: Runs `hugo --gc --minify` to ensure the site builds without errors
2. **Error Handling**: Aborts the commit if the Hugo build fails
3. **Resource Management**: Handles generated resources appropriately
4. **User Feedback**: Provides clear success/failure messages

### Features:
- ✅ Validates Hugo build before allowing commits
- ✅ Provides clear error messages if build fails
- ✅ Respects .gitignore settings for public directory
- ✅ Handles generated resources correctly
- ✅ User-friendly output with emojis and clear status

### How it works:
```bash
# Run Hugo build
hugo --gc --minify

# Check build status
if [ $? -ne 0 ]; then
    echo "❌ Hugo build failed. Aborting commit."
    exit 1
fi

# Handle resources if needed
git add resources/_gen (if not ignored)
```

### Benefits:
- Prevents broken builds from being committed
- Ensures code quality at commit time
- Provides immediate feedback to developers
- Maintains a clean commit history

### Installation:
The hook is automatically installed and made executable. To manually install:
```bash
chmod +x .git/hooks/pre-commit
```

### Testing:
To test the hook, make any change to content and run:
```bash
git add .
git commit -m "Test commit"
```

The hook will run automatically and show build verification status.

## Notes:
- The `public/` directory is excluded from Git (via .gitignore) as intended for GitHub Actions deployment
- Generated resources in `resources/_gen/` may be added if not ignored
- Hook respects Hugo's build process and error handling
- Compatible with the automated GitHub Actions deployment workflow