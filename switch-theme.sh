#!/bin/bash

# Theme switcher script for Hugo blog testing
# Usage: ./switch-theme.sh <theme-name>

if [ $# -eq 0 ]; then
    echo "Available themes:"
    echo "  papermod  - PaperMod: Fast, clean, responsive blog theme"
    echo "  stack     - Stack: Card-based blog theme with modern design"
    echo "  hextra    - Hextra: Documentation and blog theme with dark mode"
    echo "  blowfish  - Blowfish: Feature-rich personal website theme"
    echo "  congo     - Congo: Flexible blog and documentation theme"
    echo ""
    echo "Usage: ./switch-theme.sh <theme-name>"
    echo "Example: ./switch-theme.sh papermod"
    exit 1
fi

THEME_NAME=$1
THEME_PATH=".claude/themes-testing/$THEME_NAME"

# Check if theme exists
if [ ! -d "$THEME_PATH" ]; then
    echo "Error: Theme '$THEME_NAME' not found in themes-testing directory"
    echo "Available themes: papermod, stack, hextra, blowfish, congo"
    exit 1
fi

# Backup current theme in hugo.toml
if [ -f "hugo.toml" ]; then
    cp hugo.toml hugo.toml.backup
fi

# Update hugo.toml with new theme
if [ -f "hugo.toml" ]; then
    sed -i "s/theme = .*/theme = \"$THEME_NAME\"/" hugo.toml
    echo "Updated hugo.toml with theme: $THEME_NAME"
else
    echo "Error: hugo.toml not found"
    exit 1
fi

# Copy theme from testing directory to themes directory
if [ ! -d "themes" ]; then
    mkdir themes
fi

if [ -d "themes/$THEME_NAME" ]; then
    rm -rf "themes/$THEME_NAME"
fi

cp -r "$THEME_PATH" "themes/$THEME_NAME"
echo "Copied theme to themes/$THEME_NAME"

# Test the theme
echo "Testing theme with Hugo server..."
echo "You can now run: hugo server -D"
echo "Press Ctrl+C to stop the server when done testing"