#!/bin/bash
# Simple wrapper for blog syncing

cd "$(dirname "$0")"

# Default action: sync once
if [ "$1" == "watch" ]; then
    echo "Starting blog sync in watch mode..."
    python3 scripts/sync-obsidian-blog.py --watch --push --interval 60
elif [ "$1" == "push" ]; then
    echo "Syncing and pushing to GitHub..."
    python3 scripts/sync-obsidian-blog.py --push
else
    echo "Syncing blog posts..."
    python3 scripts/sync-obsidian-blog.py
    echo ""
    echo "Use './sync-blog.sh push' to sync and push to GitHub"
    echo "Use './sync-blog.sh watch' to watch for changes and auto-push"
fi