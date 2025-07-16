# Blog Hero - Content Creation Manual

A complete guide for creating and publishing blog posts from Obsidian to Hugo with GitHub Pages deployment.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Content Creation Workflow](#content-creation-workflow)
- [Post Structure and Format](#post-structure-and-format)
- [Publishing Process](#publishing-process)
- [Local Testing](#local-testing)
- [Troubleshooting](#troubleshooting)
- [Advanced Tips](#advanced-tips)

## Overview

**Blog Hero** uses a hybrid content creation system:
- **Obsidian**: For writing and organizing content
- **Hugo**: Static site generator with Stack theme
- **GitHub Pages**: Automated hosting and deployment
- **GitHub Actions**: CI/CD pipeline for automatic publishing

### Content Flow
```
Obsidian Vault → Hugo Processing → GitHub Repository → GitHub Pages
```

## Prerequisites

### Required Software
- **Obsidian**: Content creation and management
- **Hugo**: Local testing and development
- **Git**: Version control
- **GitHub Account**: Repository hosting and Pages deployment

### Project Structure
```
blog-hero/
├── content/
│   └── page/           # Static pages (About, Search, Archives)
├── config/_default/    # Hugo configuration
├── /tmp/obsidian-vault/blog-bundles/  # Obsidian content source
├── public/             # Generated site (auto-generated)
└── themes/             # Hugo themes
```

## Content Creation Workflow

### Step 1: Create New Post in Obsidian

1. **Open Obsidian** and navigate to your vault
2. **Create a new folder** in `/tmp/obsidian-vault/blog-bundles/`:
   ```
   /tmp/obsidian-vault/blog-bundles/my-new-post/
   ```
3. **Create `index.md`** inside the folder:
   ```
   /tmp/obsidian-vault/blog-bundles/my-new-post/index.md
   ```

### Step 2: Structure Your Post

Use this template for your `index.md`:

```yaml
---
title: "Your Compelling Post Title"
description: "A brief description that appears in previews and SEO"
slug: your-post-slug
date: 2025-07-16T10:00:00-03:00
image: cover-image.jpg  # Optional: place in same folder
categories:
    - Technology
    - Cybersecurity
tags:
    - Hugo
    - Tutorial
    - Security
weight: 1  # Lower = higher priority
draft: false  # Set to true for drafts
---

# Your Post Title

Your content goes here...

## Section Headers

Use proper markdown formatting:

- **Bold text**
- *Italic text*
- `Code snippets`
- [Links](https://example.com)

### Code Blocks

```bash
echo "Hello, World!"
```

### Lists and More

1. Numbered lists
2. Are great for steps

- Bullet points
- Work well too

> Blockquotes for emphasis

---

That's it! Happy blogging!
```

### Step 3: Write Your Content

1. **Use Markdown syntax** for formatting
2. **Add images** to the same folder as `index.md`
3. **Reference images** using relative paths: `![Alt text](image.jpg)`
4. **Preview in Obsidian** to check formatting

## Post Structure and Format

### Front Matter Fields

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `title` | ✅ | Post title | `"Getting Started with Hugo"` |
| `description` | ✅ | SEO description | `"A beginner's guide to..."` |
| `slug` | ✅ | URL slug | `getting-started-hugo` |
| `date` | ✅ | Publication date | `2025-07-16T10:00:00-03:00` |
| `image` | ❌ | Cover image | `cover.jpg` |
| `categories` | ❌ | Post categories | `["Technology", "Tutorial"]` |
| `tags` | ❌ | Post tags | `["Hugo", "Web", "Static"]` |
| `weight` | ❌ | Post priority | `1` (lower = higher) |
| `draft` | ❌ | Draft status | `false` |

### Categories and Tags

**Available Categories:**
- `Technology`
- `Cybersecurity`
- `Development`
- `Automation`
- `Meta`
- `General`

**Recommended Tags:**
- Technical: `Hugo`, `Docker`, `Linux`, `Python`, `Security`
- Topics: `Tutorial`, `Guide`, `Review`, `Analysis`
- Tools: `Obsidian`, `Git`, `GitHub`, `Homelab`

### Image Guidelines

1. **Place images** in the same folder as `index.md`
2. **Supported formats**: JPG, PNG, WebP, SVG
3. **Recommended sizes**:
   - Cover images: 1200x630px
   - Inline images: Max 800px width
4. **Reference syntax**: `![Description](filename.jpg)`

## Publishing Process

### Automatic Publishing (Recommended)

1. **Commit changes** to the repository:
   ```bash
   git add -A
   git commit -m "Add new post: Your Post Title"
   git push origin main
   ```

2. **GitHub Actions** automatically:
   - Builds the Hugo site
   - Deploys to GitHub Pages
   - Usually takes 2-3 minutes

3. **View published post** at:
   ```
   https://amlucas0xff.github.io/blog/p/your-post-slug/
   ```

### Manual Process (If Needed)

If automatic deployment fails:

1. **Build locally**:
   ```bash
   cd /home/amlucas/Desktop/blog-hero
   hugo --cleanDestinationDir
   ```

2. **Check for errors** in the build output

3. **Fix issues** and commit again

## Local Testing

### Start Development Server

```bash
cd /home/amlucas/Desktop/blog-hero
hugo server --port 1313 --bind 0.0.0.0
```

### View Local Site

- **Main site**: http://localhost:1313/blog/
- **Your post**: http://localhost:1313/blog/p/your-post-slug/

### Test Navigation

1. Click **"Toggle Menu"** in sidebar
2. Verify links work:
   - Home
   - Archives
   - Search
   - About Me

## Troubleshooting

### Common Issues

#### Post Not Appearing
- ✅ Check `draft: false` in front matter
- ✅ Verify correct folder structure: `blog-bundles/post-name/index.md`
- ✅ Ensure valid YAML front matter
- ✅ Check date isn't in the future

#### Build Errors
```bash
# Check Hugo build
hugo --verbose

# View detailed logs
hugo server --logLevel debug
```

#### Images Not Loading
- ✅ Images in same folder as `index.md`
- ✅ Correct file extensions (.jpg, .png, .webp)
- ✅ Proper reference syntax: `![Alt](image.jpg)`

#### Navigation Missing
- ✅ Click "Toggle Menu" button in sidebar
- ✅ Menu items are collapsible in Stack theme

### Error Messages

| Error | Solution |
|-------|----------|
| `hugo: command not found` | Install Hugo: `sudo snap install hugo` |
| `failed to extract shortcode` | Check markdown syntax |
| `template not found` | Verify theme installation |
| `404 page not found` | Check slug and URL structure |

## Advanced Tips

### Content Organization

**Use descriptive folder names:**
```
blog-bundles/
├── cybersecurity-fundamentals/
├── docker-homelab-setup/
├── python-automation-scripts/
└── weekly-security-roundup-01/
```

### SEO Optimization

1. **Write compelling titles** (50-60 characters)
2. **Craft good descriptions** (150-160 characters)
3. **Use relevant tags** and categories
4. **Add alt text** to images
5. **Use proper heading hierarchy** (H1 → H2 → H3)

### Performance Tips

1. **Optimize images** before uploading
2. **Use appropriate file formats**:
   - Photos: JPG
   - Graphics: PNG
   - Simple icons: SVG
3. **Compress large files**

### Automation Enhancements

**Create post templates** in Obsidian:
1. Templates → New template
2. Save common front matter structure
3. Use for consistent formatting

### Backup Strategy

**Important:** Your content lives in two places:
1. **Obsidian vault**: `/tmp/obsidian-vault/blog-bundles/`
2. **Git repository**: `/home/amlucas/Desktop/blog-hero/`

**Recommended backup:**
- Regular git commits
- Obsidian vault backup
- GitHub repository as remote backup

---

## Quick Reference

### New Post Checklist

- [ ] Create folder: `blog-bundles/post-name/`
- [ ] Create `index.md` with proper front matter
- [ ] Write content in Markdown
- [ ] Add images to same folder
- [ ] Test locally: `hugo server`
- [ ] Commit and push: `git add -A && git commit -m "..." && git push`
- [ ] Verify deployment at GitHub Pages

### Essential Commands

```bash
# Start local server
hugo server --port 1313

# Build site
hugo --cleanDestinationDir

# Git workflow
git add -A
git commit -m "Add post: Title"
git push origin main

# Check site status
curl -I https://amlucas0xff.github.io/blog/
```

### Useful Links

- **Live Site**: https://amlucas0xff.github.io/blog/
- **Repository**: https://github.com/amlucas0xff/blog/
- **Hugo Docs**: https://gohugo.io/documentation/
- **Stack Theme**: https://stack.jimmycai.com/
- **Markdown Guide**: https://www.markdownguide.org/

---

**Happy blogging!** 🚀

*Last updated: July 16, 2025*