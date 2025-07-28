#!/bin/bash
# generate-docs.sh - Generate documentation for Hugo blog project
# Creates comprehensive documentation for content creators and developers

set -e

echo "📖 Generating documentation for Hugo blog project..."

# Check if we're in the project root
if [[ ! -f "hugo.toml" && ! -f "config.toml" ]]; then
    echo "❌ Not in Hugo project root directory"
    exit 1
fi

# Create docs directory if it doesn't exist
mkdir -p docs

echo "📝 Generating content creator documentation..."

# Generate content creation guide
cat > docs/CONTENT_CREATION.md << 'EOF'
# Content Creation Guide

## Creating New Blog Posts

### Using Hugo CLI
```bash
# Create a new post with proper bundle structure
hugo new posts/my-post-title/index.md

# Create a new page
hugo new page/about/index.md
```

### Post Structure
```
content/posts/my-post/
├── index.md          # Main content
├── featured.jpg      # Optional featured image
└── images/           # Post-specific images
    ├── screenshot.png
    └── diagram.jpg
```

### Front Matter Template
```yaml
---
title: "Your Post Title"
date: 2024-01-01T10:00:00Z
description: "Brief description for SEO"
categories: ["Technology", "Programming"]
tags: ["hugo", "blog", "tutorial"]
image: "featured.jpg"
math: false
toc: true
comments: true
---
```

## Content Best Practices

### Writing Guidelines
- Use semantic headings (H1 for title, H2-H6 for sections)
- Include alt text for all images
- Keep paragraphs concise (3-4 sentences max)
- Use code blocks with proper language highlighting

### Image Optimization
- Use WebP format when possible
- Optimize file sizes (aim for <500KB per image)
- Include descriptive filenames
- Use Hugo's image processing for responsive images

### SEO Optimization
- Write compelling meta descriptions
- Use relevant categories and tags
- Include internal links to related posts
- Optimize heading structure for readability

## Markdown Extensions

### Code Blocks
```python
def hello_world():
    print("Hello, Hugo!")
```

### Shortcodes
- `{{< youtube VIDEO_ID >}}` - Embed YouTube videos
- `{{< figure src="image.jpg" alt="Description" caption="Caption" >}}` - Enhanced images
- `{{< quote author="Name" >}}Quote text{{< /quote >}}` - Styled quotes

## Publishing Workflow

1. Write content in `content/posts/`
2. Test locally with `hugo server`
3. Build with `hugo --minify`
4. Deploy `public/` directory to hosting
EOF

echo "🔧 Generating developer documentation..."

# Generate developer guide
cat > docs/DEVELOPMENT.md << 'EOF'
# Developer Documentation

## Project Structure

```
blog-hero/
├── content/           # Blog content (Markdown)
├── layouts/           # Custom Hugo templates
├── static/            # Static assets
├── assets/            # Build-time assets (SCSS, etc.)
├── config/            # Hugo configuration
├── scripts/           # Python automation scripts
├── themes/stack/      # Hugo Stack theme
└── public/            # Generated site (not in git)
```

## Development Setup

### Prerequisites
- Hugo Extended (latest version)
- Go 1.24.1+
- Python 3.8+
- Node.js (for theme development)

### Local Development
```bash
# Install Python dependencies
pip install -r requirements.txt

# Start Hugo development server
hugo server --bind 0.0.0.0 --port 1313

# Run with drafts
hugo server -D --disableFastRender
```

## Theme Customization

### Layout Overrides
Copy theme layouts to `layouts/` directory:
```bash
cp themes/stack/layouts/partials/head/head.html layouts/partials/head/
```

### Custom Styling
Edit `assets/scss/custom.scss` for theme modifications.

### JavaScript Extensions
Add custom scripts to `assets/js/` directory.

## Python Automation

### Obsidian Integration
- `scripts/obsidian-sync.py` - Sync from Obsidian vault
- `scripts/watch-obsidian.py` - Real-time monitoring
- `scripts/setup-obsidian-sync.sh` - Initial setup

### Running Scripts
```bash
# Manual sync
python3 scripts/obsidian-sync.py

# Background monitoring
nohup python3 scripts/watch-obsidian.py &
```

## Build & Deployment

### Production Build
```bash
# Clean and build
hugo --gc --minify

# Build with environment
HUGO_ENV=production hugo --minify
```

### Performance Optimization
- Use Hugo's image processing
- Minimize custom CSS/JS
- Enable compression in hosting
- Use CDN for static assets

## Troubleshooting

### Common Issues
1. **Template not found**: Check layout lookup order
2. **Resources not found**: Run `hugo --gc` to clean cache
3. **Python script errors**: Check file permissions and paths
4. **Slow builds**: Use `hugo --templateMetrics` to identify bottlenecks

### Debug Commands
```bash
# Detailed Hugo output
hugo --debug --verbose

# Template performance
hugo --templateMetrics

# Git info (for lastmod dates)
hugo --enableGitInfo
```
EOF

echo "🎯 Generating API documentation..."

# Generate Python script documentation if possible
if command -v python3 >/dev/null 2>&1; then
    echo "🐍 Documenting Python scripts..."
    
    for script in scripts/*.py; do
        if [[ -f "$script" ]]; then
            echo "## $(basename "$script")" >> docs/SCRIPTS.md
            echo "" >> docs/SCRIPTS.md
            echo '```python' >> docs/SCRIPTS.md
            head -20 "$script" | grep -E "^(def |class |#)" >> docs/SCRIPTS.md
            echo '```' >> docs/SCRIPTS.md
            echo "" >> docs/SCRIPTS.md
        fi
    done
fi

# Generate Hugo configuration documentation
echo "⚙️  Documenting Hugo configuration..."
cat > docs/CONFIGURATION.md << 'EOF'
# Configuration Guide

## Hugo Configuration Files

### config/_default/config.toml
Main site configuration including:
- Site metadata (title, description, URL)
- Language settings
- Output formats
- Menu definitions

### config/_default/params.toml
Theme-specific parameters:
- Social media links
- Comment system settings
- Search configuration
- Custom theme options

### config/_default/markup.toml
Markdown rendering configuration:
- Code highlighting settings
- Table of contents options
- HTML rendering rules

## Environment-Specific Configs

Create environment-specific overrides:
- `config/development/` - Development settings
- `config/production/` - Production optimizations

## Module Configuration

### go.mod
Hugo theme dependencies and Go module settings.

### requirements.txt
Python dependencies for automation scripts.

## Customization Examples

### Adding Custom Menu Items
```toml
[[menu.main]]
    identifier = "custom-page"
    name = "Custom Page"
    url = "/custom/"
    weight = 30
```

### Enabling Comments
```toml
[params.comments]
    enabled = true
    provider = "disqus"
    disqusShortname = "your-shortname"
```

### Custom CSS/JS
```toml
[params.assets]
    customCSS = ["css/custom.css"]
    customJS = ["js/custom.js"]
```
EOF

echo "✅ Documentation generation completed!"
echo ""
echo "📋 Generated documentation files:"
echo "  - docs/CONTENT_CREATION.md - Guide for content creators"
echo "  - docs/DEVELOPMENT.md - Developer setup and customization"
echo "  - docs/CONFIGURATION.md - Hugo configuration reference"
echo "  - docs/SCRIPTS.md - Python scripts documentation"
echo ""
echo "💡 To view locally: hugo server and navigate to /docs/"