#!/usr/bin/env python3
"""
Obsidian to Hugo Blog Sync Script
Automatically syncs blog posts from Obsidian vault to Hugo content directory
with image processing and path resolution.
"""

import os
import re
import shutil
import argparse
from pathlib import Path
from datetime import datetime
import yaml
import subprocess

class ObsidianHugoSync:
    def __init__(self, obsidian_vault_path, hugo_content_path, hugo_static_path):
        self.obsidian_vault = Path(obsidian_vault_path)
        self.hugo_content = Path(hugo_content_path)
        self.hugo_static = Path(hugo_static_path)
        self.hugo_images = self.hugo_static / "images"
        
        # Ensure directories exist
        self.hugo_content.mkdir(parents=True, exist_ok=True)
        self.hugo_images.mkdir(parents=True, exist_ok=True)
    
    def find_blog_posts(self):
        """Find all markdown files in the Obsidian vault that should be blog posts."""
        blog_posts = []
        
        # Look for files with blog-related tags or in blog folder
        for md_file in self.obsidian_vault.rglob("*.md"):
            if self.is_blog_post(md_file):
                blog_posts.append(md_file)
        
        return blog_posts
    
    def is_blog_post(self, file_path):
        """Determine if a markdown file should be treated as a blog post."""
        try:
            content = file_path.read_text(encoding='utf-8')
            
            # Check for Hugo front matter
            if content.startswith('---') or content.startswith('+++'):
                return True
            
            # Check for blog-related tags
            if re.search(r'#blog|#post|#publish', content, re.IGNORECASE):
                return True
            
            # Check if in blog folder
            if 'blog' in str(file_path).lower():
                return True
                
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
        
        return False
    
    def process_images(self, content, source_file):
        """Process and copy images, updating markdown links."""
        source_dir = source_file.parent
        
        # Pattern to match markdown images: ![alt](path) or ![[path]]
        image_patterns = [
            r'!\[([^\]]*)\]\(([^)]+)\)',  # ![alt](path)
            r'!\[\[([^\]]+)\]\]'          # ![[path]]
        ]
        
        processed_content = content
        
        for pattern in image_patterns:
            matches = re.finditer(pattern, content)
            for match in matches:
                if pattern.endswith(r'\]\]'):  # Obsidian style ![[image]]
                    image_path = match.group(1)
                    alt_text = Path(image_path).stem
                else:  # Standard markdown ![alt](path)
                    alt_text = match.group(1)
                    image_path = match.group(2)
                
                # Skip if it's already a web URL
                if image_path.startswith(('http://', 'https://')):
                    continue
                
                # Resolve image path
                if os.path.isabs(image_path):
                    source_image = Path(image_path)
                else:
                    source_image = source_dir / image_path
                
                if source_image.exists():
                    # Copy image to Hugo static/images
                    image_name = f"{source_file.stem}_{source_image.name}"
                    dest_image = self.hugo_images / image_name
                    
                    shutil.copy2(source_image, dest_image)
                    
                    # Update content with new path
                    hugo_image_path = f"/images/{image_name}"
                    new_markdown = f"![{alt_text}]({hugo_image_path})"
                    
                    processed_content = processed_content.replace(match.group(0), new_markdown)
                    print(f"Copied image: {source_image} -> {dest_image}")
        
        return processed_content
    
    def process_front_matter(self, content, source_file):
        """Process and ensure proper Hugo front matter."""
        lines = content.split('\n')
        
        # Check if front matter exists
        if not content.startswith(('---', '+++')):
            # Create new front matter
            front_matter = {
                'title': source_file.stem.replace('-', ' ').replace('_', ' ').title(),
                'date': datetime.now().isoformat(),
                'draft': False,
                'author': 'amlucas0xff',
                'categories': ['general'],
                'tags': []
            }
            
            yaml_front_matter = "---\n" + yaml.dump(front_matter, default_flow_style=False) + "---\n\n"
            return yaml_front_matter + content
        
        return content
    
    def sync_post(self, source_file):
        """Sync a single blog post from Obsidian to Hugo."""
        try:
            content = source_file.read_text(encoding='utf-8')
            
            # Process images
            content = self.process_images(content, source_file)
            
            # Process front matter
            content = self.process_front_matter(content, source_file)
            
            # Determine destination
            dest_file = self.hugo_content / "posts" / source_file.name
            dest_file.parent.mkdir(parents=True, exist_ok=True)
            
            # Write processed content
            dest_file.write_text(content, encoding='utf-8')
            
            print(f"Synced: {source_file} -> {dest_file}")
            return dest_file
            
        except Exception as e:
            print(f"Error syncing {source_file}: {e}")
            return None
    
    def sync_all(self):
        """Sync all blog posts from Obsidian to Hugo."""
        blog_posts = self.find_blog_posts()
        synced_files = []
        
        print(f"Found {len(blog_posts)} blog posts to sync")
        
        for post in blog_posts:
            result = self.sync_post(post)
            if result:
                synced_files.append(result)
        
        return synced_files
    
    def auto_commit(self, synced_files):
        """Automatically commit synced files to git."""
        if not synced_files:
            print("No files to commit")
            return
        
        try:
            # Add files to git
            subprocess.run(['git', 'add', '.'], cwd=Path.cwd(), check=True)
            
            # Create commit message
            file_names = [f.name for f in synced_files]
            if len(file_names) == 1:
                commit_msg = f"Sync blog post: {file_names[0]}"
            else:
                commit_msg = f"Sync {len(file_names)} blog posts from Obsidian"
            
            commit_msg += "\n\n🤖 Generated with [Claude Code](https://claude.ai/code)\n\nCo-Authored-By: Claude <noreply@anthropic.com>"
            
            # Commit
            subprocess.run(['git', 'commit', '-m', commit_msg], cwd=Path.cwd(), check=True)
            
            print(f"Auto-committed {len(synced_files)} files")
            
        except subprocess.CalledProcessError as e:
            print(f"Git commit failed: {e}")

def main():
    parser = argparse.ArgumentParser(description='Sync Obsidian blog posts to Hugo')
    parser.add_argument('--obsidian-vault', 
                       default='/tmp/obsidian-vault/blog',
                       help='Path to Obsidian vault blog folder')
    parser.add_argument('--hugo-content',
                       default='./content',
                       help='Path to Hugo content directory')
    parser.add_argument('--hugo-static',
                       default='./static',
                       help='Path to Hugo static directory')
    parser.add_argument('--auto-commit',
                       action='store_true',
                       help='Automatically commit changes to git')
    parser.add_argument('--single-file',
                       help='Sync only a specific file')
    
    args = parser.parse_args()
    
    sync = ObsidianHugoSync(
        obsidian_vault_path=args.obsidian_vault,
        hugo_content_path=args.hugo_content,
        hugo_static_path=args.hugo_static
    )
    
    if args.single_file:
        source_file = Path(args.single_file)
        if source_file.exists():
            synced = [sync.sync_post(source_file)]
        else:
            print(f"File not found: {args.single_file}")
            return
    else:
        synced = sync.sync_all()
    
    if args.auto_commit:
        sync.auto_commit([f for f in synced if f])
    
    print(f"Sync completed. {len([f for f in synced if f])} files processed.")

if __name__ == '__main__':
    main()