#!/usr/bin/env python3
"""
Obsidian to Hugo Blog Sync Script with GitHub Integration
Syncs blog posts from Obsidian vault to Hugo content directory and pushes to GitHub
"""

import os
import re
import shutil
import argparse
import subprocess
from pathlib import Path
from datetime import datetime
import yaml
import time


class ObsidianHugoSync:
    def __init__(self, obsidian_blog_path, hugo_content_path, hugo_static_path):
        self.obsidian_blog = Path(obsidian_blog_path)
        self.hugo_content = Path(hugo_content_path)
        self.hugo_static = Path(hugo_static_path)
        self.hugo_images = self.hugo_static / "images"

        # Ensure directories exist
        self.hugo_content.mkdir(parents=True, exist_ok=True)
        self.hugo_images.mkdir(parents=True, exist_ok=True)

    def find_blog_posts(self):
        """Find all markdown files in the Obsidian blog posts directory."""
        blog_posts = []

        posts_dir = self.obsidian_blog / "posts"
        if posts_dir.exists():
            for md_file in posts_dir.glob("*.md"):
                # Skip index files
                if not md_file.name.startswith("_"):
                    blog_posts.append(md_file)

        return blog_posts

    def process_images(self, content, source_file):
        """Process and copy images, updating markdown links."""
        source_dir = source_file.parent
        
        # Pattern to match markdown images: ![alt](path) or ![[path]]
        image_patterns = [
            r"!\[([^\]]*)\]\(([^)]+)\)",  # ![alt](path)
            r"!\[\[([^\]]+)\]\]",  # ![[path]]
        ]

        processed_content = content

        for pattern in image_patterns:
            matches = re.finditer(pattern, content)
            for match in matches:
                if pattern.endswith(r"\]\]"):  # Obsidian style ![[image]]
                    image_path = match.group(1)
                    alt_text = Path(image_path).stem
                else:  # Standard markdown ![alt](path)
                    alt_text = match.group(1)
                    image_path = match.group(2)

                # Skip if it's already a web URL
                if image_path.startswith(("http://", "https://", "/")):
                    continue

                # Try to find the image in attaches folder
                possible_paths = [
                    source_dir / image_path,
                    source_dir.parent.parent / "attaches" / image_path,
                    source_dir.parent.parent / "attaches" / Path(image_path).name,
                ]

                source_image = None
                for path in possible_paths:
                    if path.exists():
                        source_image = path
                        break

                if source_image:
                    # Create a unique image name
                    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                    image_name = f"{source_file.stem}_{timestamp}_{source_image.name}"
                    dest_image = self.hugo_images / image_name

                    shutil.copy2(source_image, dest_image)

                    # Update content with new path
                    hugo_image_path = f"/images/{image_name}"
                    new_markdown = f"![{alt_text}]({hugo_image_path})"

                    processed_content = processed_content.replace(
                        match.group(0), new_markdown
                    )
                    print(f"  ✓ Copied image: {source_image.name}")

        return processed_content

    def sync_post(self, source_file):
        """Sync a single blog post from Obsidian to Hugo."""
        try:
            content = source_file.read_text(encoding="utf-8")

            # Process images
            content = self.process_images(content, source_file)

            # Create post bundle directory
            post_dir = self.hugo_content / "posts" / source_file.stem
            post_dir.mkdir(parents=True, exist_ok=True)
            
            # Write as index.md in the bundle
            dest_file = post_dir / "index.md"
            dest_file.write_text(content, encoding="utf-8")

            print(f"✓ Synced: {source_file.name} -> {dest_file}")
            return dest_file

        except Exception as e:
            print(f"✗ Error syncing {source_file.name}: {e}")
            return None

    def sync_all(self):
        """Sync all blog posts from Obsidian to Hugo."""
        blog_posts = self.find_blog_posts()
        synced_files = []

        if not blog_posts:
            print("No blog posts found in Obsidian blog folder")
            return synced_files

        print(f"\nFound {len(blog_posts)} blog posts to sync:")
        for post in blog_posts:
            print(f"  - {post.name}")

        print("\nSyncing posts...")
        for post in blog_posts:
            result = self.sync_post(post)
            if result:
                synced_files.append(result)

        return synced_files

    def git_push(self, synced_files, commit_message=None):
        """Commit and push changes to GitHub."""
        if not synced_files:
            print("\nNo files to push")
            return False

        try:
            # Check if we're in a git repository
            subprocess.run(["git", "rev-parse", "--git-dir"], 
                         check=True, capture_output=True)

            # Add all changes
            subprocess.run(["git", "add", "."], check=True)

            # Check if there are changes to commit
            result = subprocess.run(
                ["git", "status", "--porcelain"], 
                capture_output=True, text=True
            )
            
            if not result.stdout.strip():
                print("\nNo changes to commit")
                return False

            # Create commit message
            if not commit_message:
                file_names = [f.parent.name for f in synced_files]
                if len(file_names) == 1:
                    commit_message = f"Sync blog post: {file_names[0]}"
                else:
                    commit_message = f"Sync {len(file_names)} blog posts from Obsidian"

            # Commit
            subprocess.run(
                ["git", "commit", "-m", commit_message], 
                check=True
            )
            print(f"\n✓ Committed: {commit_message}")

            # Push to remote
            subprocess.run(["git", "push", "origin", "master"], check=True)
            print("✓ Pushed to GitHub")

            return True

        except subprocess.CalledProcessError as e:
            print(f"\n✗ Git operation failed: {e}")
            return False


def main():
    parser = argparse.ArgumentParser(
        description="Sync Obsidian blog posts to Hugo and push to GitHub"
    )
    parser.add_argument(
        "--obsidian-blog",
        default="/home/amlucas/Documents/obsidian/blog",
        help="Path to Obsidian blog folder (default: ~/Documents/obsidian/blog)",
    )
    parser.add_argument(
        "--hugo-content",
        default="./content",
        help="Path to Hugo content directory (default: ./content)",
    )
    parser.add_argument(
        "--hugo-static",
        default="./static",
        help="Path to Hugo static directory (default: ./static)",
    )
    parser.add_argument(
        "--push",
        action="store_true",
        help="Automatically commit and push to GitHub",
    )
    parser.add_argument(
        "--watch",
        action="store_true",
        help="Watch for changes and sync automatically",
    )
    parser.add_argument(
        "--interval",
        type=int,
        default=60,
        help="Watch interval in seconds (default: 60)",
    )

    args = parser.parse_args()

    sync = ObsidianHugoSync(
        obsidian_blog_path=args.obsidian_blog,
        hugo_content_path=args.hugo_content,
        hugo_static_path=args.hugo_static,
    )

    if args.watch:
        print(f"Watching for changes every {args.interval} seconds...")
        print("Press Ctrl+C to stop\n")
        
        last_sync_time = {}
        
        try:
            while True:
                posts = sync.find_blog_posts()
                synced = []
                
                for post in posts:
                    # Check if file was modified since last sync
                    mtime = post.stat().st_mtime
                    if post not in last_sync_time or mtime > last_sync_time[post]:
                        result = sync.sync_post(post)
                        if result:
                            synced.append(result)
                            last_sync_time[post] = mtime
                
                if synced and args.push:
                    sync.git_push(synced)
                elif synced:
                    print(f"\n{len(synced)} files synced. Use --push to push to GitHub.")
                
                time.sleep(args.interval)
                
        except KeyboardInterrupt:
            print("\n\nStopped watching.")
    else:
        # One-time sync
        synced = sync.sync_all()
        
        if synced:
            print(f"\n✓ Sync completed. {len(synced)} files processed.")
            
            if args.push:
                sync.git_push(synced)
            else:
                print("\nTo push changes to GitHub, run with --push flag")
        else:
            print("\n✗ No files were synced.")


if __name__ == "__main__":
    main()