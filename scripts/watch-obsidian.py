#!/usr/bin/env python3
"""
File watcher for Obsidian vault to automatically sync changes to Hugo blog.
Uses inotify to monitor file changes and triggers sync when blog posts are modified.
"""

import os
import sys
import time
import argparse
from pathlib import Path
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import subprocess


class ObsidianFileHandler(FileSystemEventHandler):
    def __init__(self, sync_script_path, hugo_content_path, auto_commit=False):
        self.sync_script = Path(sync_script_path)
        self.hugo_content = Path(hugo_content_path)
        self.auto_commit = auto_commit
        self.last_sync = {}  # Track last sync times to prevent rapid re-syncing
        self.cooldown = 2  # seconds

    def should_sync(self, file_path):
        """Check if file should trigger a sync."""
        file_path = Path(file_path)

        # Only process markdown files
        if file_path.suffix != ".md":
            return False

        # Check cooldown to prevent rapid re-syncing
        now = time.time()
        if file_path in self.last_sync:
            if now - self.last_sync[file_path] < self.cooldown:
                return False

        self.last_sync[file_path] = now
        return True

    def sync_file(self, file_path):
        """Sync a specific file using the sync script."""
        try:
            cmd = ["python3", str(self.sync_script), "--single-file", str(file_path)]

            if self.auto_commit:
                cmd.append("--auto-commit")

            result = subprocess.run(
                cmd, capture_output=True, text=True, cwd=self.sync_script.parent.parent
            )

            if result.returncode == 0:
                print(f"✅ Synced: {file_path}")
                if result.stdout:
                    print(f"   {result.stdout.strip()}")
            else:
                print(f"❌ Sync failed for {file_path}: {result.stderr}")

        except Exception as e:
            print(f"❌ Error syncing {file_path}: {e}")

    def on_modified(self, event):
        if event.is_directory:
            return

        if self.should_sync(event.src_path):
            print(f"📝 File modified: {event.src_path}")
            self.sync_file(event.src_path)

    def on_created(self, event):
        if event.is_directory:
            return

        if self.should_sync(event.src_path):
            print(f"📄 New file created: {event.src_path}")
            self.sync_file(event.src_path)


class ObsidianWatcher:
    def __init__(
        self,
        obsidian_vault_path,
        sync_script_path,
        hugo_content_path,
        auto_commit=False,
    ):
        self.obsidian_vault = Path(obsidian_vault_path)
        self.sync_script = Path(sync_script_path)
        self.hugo_content = Path(hugo_content_path)
        self.auto_commit = auto_commit

        if not self.obsidian_vault.exists():
            raise FileNotFoundError(f"Obsidian vault not found: {self.obsidian_vault}")

        if not self.sync_script.exists():
            raise FileNotFoundError(f"Sync script not found: {self.sync_script}")

        self.observer = Observer()
        self.handler = ObsidianFileHandler(
            sync_script_path=self.sync_script,
            hugo_content_path=self.hugo_content,
            auto_commit=self.auto_commit,
        )

    def start_watching(self):
        """Start watching the Obsidian vault for changes."""
        self.observer.schedule(self.handler, str(self.obsidian_vault), recursive=True)

        self.observer.start()

        print(f"🔍 Watching Obsidian vault: {self.obsidian_vault}")
        print(f"📝 Auto-commit: {'enabled' if self.auto_commit else 'disabled'}")
        print("🚀 Press Ctrl+C to stop")

        try:
            while True:
                time.sleep(1)
        except KeyboardInterrupt:
            self.stop_watching()

    def stop_watching(self):
        """Stop watching and cleanup."""
        self.observer.stop()
        self.observer.join()
        print("\n🛑 Stopped watching Obsidian vault")


def main():
    parser = argparse.ArgumentParser(
        description="Watch Obsidian vault for changes and auto-sync to Hugo"
    )
    parser.add_argument(
        "--obsidian-vault",
        default="/tmp/obsidian-vault/blog",
        help="Path to Obsidian vault blog folder",
    )
    parser.add_argument(
        "--sync-script",
        default="./scripts/obsidian-sync.py",
        help="Path to the sync script",
    )
    parser.add_argument(
        "--hugo-content", default="./content", help="Path to Hugo content directory"
    )
    parser.add_argument(
        "--auto-commit", action="store_true", help="Automatically commit changes to git"
    )

    args = parser.parse_args()

    try:
        watcher = ObsidianWatcher(
            obsidian_vault_path=args.obsidian_vault,
            sync_script_path=args.sync_script,
            hugo_content_path=args.hugo_content,
            auto_commit=args.auto_commit,
        )

        watcher.start_watching()

    except FileNotFoundError as e:
        print(f"❌ {e}")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
