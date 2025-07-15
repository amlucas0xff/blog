#!/bin/bash
# Setup script for Obsidian-Hugo sync workflow
# This script installs dependencies and configures the sync environment

set -e

echo "🚀 Setting up Obsidian-Hugo sync workflow..."

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Check if Python 3 is installed
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 is not installed. Please install Python 3 and try again."
    exit 1
fi

echo "✅ Python 3 found: $(python3 --version)"

# Install Python dependencies
echo "📦 Installing Python dependencies..."
pip3 install -r "$PROJECT_ROOT/requirements.txt"

# Create Obsidian vault directory if it doesn't exist
OBSIDIAN_VAULT="/tmp/obsidian-vault/blog"
if [ ! -d "$OBSIDIAN_VAULT" ]; then
    echo "📁 Creating Obsidian vault directory: $OBSIDIAN_VAULT"
    mkdir -p "$OBSIDIAN_VAULT"
    
    # Create a sample blog post
    cat > "$OBSIDIAN_VAULT/sample-post.md" << 'EOF'
---
title: "Sample Blog Post from Obsidian"
date: 2025-07-15T00:00:00-03:00
draft: false
author: "amlucas0xff"
tags: ["obsidian", "automation", "blogging"]
categories: ["tech"]
---

# Welcome to Automated Blogging!

This is a sample blog post created in Obsidian and automatically synced to Hugo.

## Features

- ✅ Automatic image processing
- ✅ Front matter generation
- ✅ Real-time file watching
- ✅ Git integration

## How to Use

1. Write your blog post in Obsidian
2. Save the file
3. Watch as it automatically appears in your Hugo blog!

That's it! The sync script handles everything else.
EOF
    
    echo "📝 Created sample blog post: $OBSIDIAN_VAULT/sample-post.md"
fi

# Create systemd service for auto-starting the watcher (optional)
read -p "🔧 Create systemd service to auto-start the watcher? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    SERVICE_FILE="$HOME/.config/systemd/user/obsidian-blog-watcher.service"
    mkdir -p "$(dirname "$SERVICE_FILE")"
    
    cat > "$SERVICE_FILE" << EOF
[Unit]
Description=Obsidian Blog Watcher
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/python3 $SCRIPT_DIR/watch-obsidian.py --auto-commit
WorkingDirectory=$PROJECT_ROOT
Restart=always
RestartSec=5

[Install]
WantedBy=default.target
EOF
    
    # Enable and start the service
    systemctl --user daemon-reload
    systemctl --user enable obsidian-blog-watcher.service
    
    echo "✅ Systemd service created and enabled"
    echo "   To start: systemctl --user start obsidian-blog-watcher"
    echo "   To check status: systemctl --user status obsidian-blog-watcher"
fi

# Create convenient wrapper scripts
echo "📜 Creating convenience scripts..."

# Manual sync script
cat > "$PROJECT_ROOT/sync-now.sh" << EOF
#!/bin/bash
cd "$PROJECT_ROOT"
python3 scripts/obsidian-sync.py --auto-commit
EOF
chmod +x "$PROJECT_ROOT/sync-now.sh"

# Start watcher script
cat > "$PROJECT_ROOT/start-watcher.sh" << EOF
#!/bin/bash
cd "$PROJECT_ROOT"
python3 scripts/watch-obsidian.py --auto-commit
EOF
chmod +x "$PROJECT_ROOT/start-watcher.sh"

echo ""
echo "🎉 Setup complete! Here's how to use your new Obsidian-Hugo sync workflow:"
echo ""
echo "📝 Writing Blog Posts:"
echo "   1. Open Obsidian and navigate to: $OBSIDIAN_VAULT"
echo "   2. Create or edit .md files"
echo "   3. Add #blog tag or place in blog folder to mark as blog posts"
echo ""
echo "🔄 Syncing Options:"
echo "   Manual sync:     ./sync-now.sh"
echo "   Auto-watcher:    ./start-watcher.sh"
echo "   Single file:     python3 scripts/obsidian-sync.py --single-file /path/to/file.md"
echo ""
echo "🖼️  Image Handling:"
echo "   - Images are automatically copied to static/images/"
echo "   - Markdown links are updated to use Hugo paths"
echo "   - Supports both ![](path) and ![[path]] formats"
echo ""
echo "🚀 Publishing:"
echo "   - Changes are auto-committed to git (when using --auto-commit)"
echo "   - Push to GitHub triggers automatic deployment"
echo ""
echo "📁 Vault Location: $OBSIDIAN_VAULT"
echo "📝 Sample post created for testing"
echo ""
echo "Happy blogging! 🚀"