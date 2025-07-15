# Blog Hero - Comprehensive Manual Guide

## Project Overview

Blog Hero is a modern blog platform that combines the power of Hugo static site generator with seamless Obsidian integration for content creation. The project features automated deployment through GitHub Actions and a complete development workflow optimized for technical writers and developers.

### Technology Stack

- **Hugo**: Go-based static site generator with `hugo-blog-awesome` theme
- **Obsidian**: Markdown-based note-taking app for content creation
- **GitHub Actions**: Automated CI/CD pipeline for deployment
- **GitHub Pages**: Static site hosting
- **Git Hooks**: Pre-commit validation for build integrity
- **Hugo Modules**: Content mounting and theme management

### Key Features

- ✅ Obsidian vault integration with Hugo content mounting
- ✅ YAML front matter compatibility between Obsidian and Hugo
- ✅ Automated GitHub Actions deployment pipeline
- ✅ Pre-commit hooks for build verification
- ✅ Modern responsive theme with dark/light mode
- ✅ SEO optimization and performance features

## Setup Instructions

### Prerequisites

Before setting up the project, ensure you have the following software installed:

#### Required Software

1. **Git** (version 2.0+)
   ```bash
   # Verify installation
   git --version
   ```

2. **Hugo Extended** (version 0.110.0+)
   ```bash
   # Ubuntu/Debian
   sudo apt install hugo
   
   # macOS with Homebrew
   brew install hugo
   
   # Verify installation
   hugo version
   ```

3. **Node.js** (for some theme features, optional)
   ```bash
   # Verify installation
   node --version
   npm --version
   ```

4. **Obsidian** (for content creation)
   - Download from: https://obsidian.md/

#### Optional Software

- **GitHub CLI** (for repository management)
  ```bash
  # macOS
  brew install gh
  
  # Ubuntu
  sudo apt install gh
  ```

### Initial Project Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/USERNAME/blog-hero.git
   cd blog-hero
   ```

2. **Install Dependencies**
   ```bash
   # Initialize Hugo modules
   hugo mod init blog-hero
   hugo mod tidy
   ```

3. **Configure Obsidian Vault**
   ```bash
   # Create Obsidian vault directory (adjust path as needed)
   mkdir -p /path/to/your/obsidian-vault/blog
   
   # Update hugo.toml with your vault path
   # Edit the source path in module.mounts section
   ```

4. **Test Local Build**
   ```bash
   hugo server -D
   # Visit http://localhost:1313/blog-hero/
   ```

### GitHub Repository Configuration

1. **Update Repository Settings**
   - Replace `USERNAME` in `hugo.toml` with your GitHub username
   - Update `baseURL` to match your GitHub Pages URL

2. **Enable GitHub Pages**
   - Go to repository Settings → Pages
   - Set source to "GitHub Actions"

3. **Verify Deployment**
   - Push changes to trigger the workflow
   - Check Actions tab for build status

## Content Workflow

### Creating New Blog Posts

#### Method 1: Direct in Obsidian Vault (Recommended)

1. **Navigate to Blog Directory**
   - Open your Obsidian vault
   - Go to the `/blog` directory

2. **Create New Post**
   - Create a new markdown file
   - Use the following front matter template:

   ```yaml
   ---
   date: '2024-08-10T00:00:00+03:00'
   title: 'Your Post Title'
   draft: false
   author: 'Your Name'
   tags: ['tag1', 'tag2']
   categories: ['category']
   description: 'Brief post description for SEO'
   ---
   
   # Your Post Title
   
   Your content here...
   ```

3. **Write Content**
   - Use standard Markdown syntax
   - Add images to `static/images/` directory
   - Reference images: `![Alt text](/blog-hero/images/image.png)`

4. **Publish Post**
   ```bash
   # Navigate to project directory
   cd /path/to/blog-hero
   
   # Stage changes
   git add .
   
   # Commit (pre-commit hook will run automatically)
   git commit -m "Add new blog post: Your Post Title"
   
   # Push to trigger deployment
   git push origin main
   ```

#### Method 2: Using Hugo CLI

1. **Create Post**
   ```bash
   hugo new content posts/your-post-title.md
   ```

2. **Edit Content**
   - Open the generated file in your editor
   - Update front matter and add content

3. **Test Locally**
   ```bash
   hugo server -D
   ```

4. **Publish**
   - Set `draft: false` in front matter
   - Commit and push changes

### Content Management Best Practices

- **File Naming**: Use lowercase with hyphens (e.g., `my-awesome-post.md`)
- **Images**: Store in `static/images/` and reference with full path
- **SEO**: Always include `description` and relevant `tags`
- **Drafts**: Use `draft: true` for work-in-progress posts
- **Dates**: Use ISO 8601 format for consistency

## Theme Management Guide

### Current Theme: hugo-blog-awesome

The project currently uses the `hugo-blog-awesome` theme, installed as a Hugo module.

### Changing Themes

#### Step 1: Find a New Theme

1. **Browse Hugo Themes**
   - Visit: https://themes.gohugo.io/
   - Filter by features you need
   - Check theme documentation and demo

2. **Popular Theme Options**
   - `hugo-blog-awesome` (current)
   - `ananke` (simple, official)
   - `paper` (minimal)
   - `loveit` (feature-rich)

#### Step 2: Install New Theme

**Option A: As Hugo Module (Recommended)**

1. **Update hugo.toml**
   ```toml
   [module]
     [[module.imports]]
       path = "github.com/theme-author/theme-name"
   ```

2. **Get the module**
   ```bash
   hugo mod get github.com/theme-author/theme-name
   hugo mod tidy
   ```

**Option B: As Git Submodule**

1. **Add submodule**
   ```bash
   git submodule add https://github.com/theme-author/theme-name.git themes/theme-name
   ```

2. **Update hugo.toml**
   ```toml
   theme = "theme-name"
   ```

#### Step 3: Configure Theme

1. **Review Theme Documentation**
   - Check theme's README for required configuration
   - Look for example `hugo.toml` or `config.yaml`

2. **Update Configuration**
   ```toml
   # Example theme-specific settings
   [params]
     author = "Your Name"
     description = "Your blog description"
     # Add theme-specific parameters here
   ```

3. **Copy Assets (if needed)**
   - Some themes require copying example content
   - Follow theme's installation instructions

#### Step 4: Test and Deploy

1. **Test Locally**
   ```bash
   hugo server -D
   ```

2. **Verify Features**
   - Check homepage layout
   - Test post rendering
   - Verify navigation and search
   - Test responsive design

3. **Deploy Changes**
   ```bash
   git add .
   git commit -m "Switch to new theme: theme-name"
   git push origin main
   ```

### Theme Customization

#### Custom CSS

1. **Create Custom Styles**
   ```bash
   mkdir -p assets/css
   echo "/* Custom styles */" > assets/css/custom.css
   ```

2. **Override Theme Styles**
   - Check theme documentation for customization options
   - Use theme-specific configuration parameters

#### Custom Layouts

1. **Override Templates**
   ```bash
   mkdir -p layouts
   # Copy theme template to override
   cp themes/theme-name/layouts/index.html layouts/
   ```

2. **Create Partials**
   ```bash
   mkdir -p layouts/partials
   # Add custom header/footer
   ```

### Reverting Theme Changes

1. **Restore Configuration**
   ```bash
   git checkout HEAD~1 -- hugo.toml
   ```

2. **Remove Submodule (if applicable)**
   ```bash
   git submodule deinit themes/theme-name
   git rm themes/theme-name
   ```

3. **Clean Module Cache**
   ```bash
   hugo mod clean
   hugo mod tidy
   ```

## Advanced Workflows

### Obsidian Templater Integration (Future Enhancement)

When implementing Templater plugin:

1. **Install Templater Plugin**
   - In Obsidian: Settings → Community Plugins
   - Search for "Templater" and install

2. **Create Blog Template**
   ```yaml
   ---
   date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm:ss+03:00") %>
   title: <% tp.file.title %>
   draft: true
   author: 'Your Name'
   tags: []
   categories: []
   description: ''
   ---
   <% tp.file.move('/blog/' + tp.file.title) %>
   
   # <% tp.file.title %>
   
   Your content here...
   ```

3. **Configure Auto-movement**
   - Template automatically moves file to blog directory
   - Ensures proper integration with Hugo

### Batch Content Operations

#### Publishing Multiple Drafts

```bash
# Find all draft posts
grep -r "draft: true" /path/to/obsidian-vault/blog/

# Use sed to change all drafts to published
find /path/to/obsidian-vault/blog/ -name "*.md" -exec sed -i 's/draft: true/draft: false/g' {} \;
```

#### Bulk Tag Management

```bash
# Add tag to multiple posts
find /path/to/obsidian-vault/blog/ -name "*.md" -exec sed -i '/tags:/s/\]/", "new-tag"]/g' {} \;
```

## Troubleshooting

### Common Issues and Solutions

#### Build Failures

**Problem**: Hugo build fails during pre-commit hook

**Solutions**:
1. **Check Hugo version**
   ```bash
   hugo version
   # Ensure version is 0.110.0+
   ```

2. **Validate front matter**
   ```bash
   # Check for YAML syntax errors
   hugo --debug
   ```

3. **Fix common front matter issues**
   - Ensure dates are in quotes
   - Check for unescaped special characters
   - Verify array syntax for tags/categories

**Problem**: Module not found errors

**Solutions**:
```bash
# Clean and reinstall modules
hugo mod clean
hugo mod get -u
hugo mod tidy
```

#### GitHub Actions Failures

**Problem**: Deployment workflow fails

**Solutions**:
1. **Check workflow permissions**
   - Repository Settings → Actions → General
   - Ensure "Read and write permissions" are enabled

2. **Verify Hugo version in workflow**
   ```yaml
   # In .github/workflows/hugo.yml
   env:
     HUGO_VERSION: 0.147.8  # Match your local version
   ```

3. **Check build logs**
   - Go to Actions tab
   - Click on failed workflow
   - Review error messages

#### Pre-commit Hook Issues

**Problem**: Pre-commit hook prevents commits

**Solutions**:
1. **Bypass hook temporarily** (not recommended)
   ```bash
   git commit --no-verify -m "Emergency commit"
   ```

2. **Fix build issues first**
   ```bash
   # Test build manually
   hugo --gc --minify
   
   # Fix any errors shown
   # Then retry commit
   ```

3. **Check hook permissions**
   ```bash
   ls -la .git/hooks/pre-commit
   # Should show executable permissions (-rwxr-xr-x)
   
   # If not executable:
   chmod +x .git/hooks/pre-commit
   ```

#### Obsidian Integration Issues

**Problem**: Content not appearing in Hugo

**Solutions**:
1. **Verify mount configuration**
   ```toml
   # In hugo.toml
   [[module.mounts]]
     source = "/correct/path/to/obsidian-vault/blog"
     target = "content"
   ```

2. **Check file permissions**
   ```bash
   ls -la /path/to/obsidian-vault/blog/
   # Ensure Hugo can read the files
   ```

3. **Test mount manually**
   ```bash
   # Create symlink to test
   ln -s /path/to/obsidian-vault/blog content-test
   hugo server -D --source content-test
   ```

#### Theme Issues

**Problem**: Theme not displaying correctly

**Solutions**:
1. **Clear browser cache**
   - Hard refresh (Ctrl+F5 or Cmd+Shift+R)

2. **Check theme compatibility**
   ```bash
   # Verify theme supports your Hugo version
   hugo mod graph
   ```

3. **Reset theme configuration**
   ```bash
   # Remove theme-specific config
   # Start with minimal configuration
   ```

### Performance Optimization

#### Build Speed

1. **Enable build cache**
   ```bash
   # Set environment variable
   export HUGO_CACHEDIR=/tmp/hugo_cache
   ```

2. **Optimize images**
   - Use WebP format when possible
   - Compress images before adding to static/
   - Consider image processing with Hugo

#### Site Performance

1. **Enable minification**
   ```toml
   # In hugo.toml
   [minify]
     disableXML = false
     minifyOutput = true
   ```

2. **Optimize fonts**
   - Use font-display: swap
   - Subset fonts to include only needed characters

### Backup and Recovery

#### Content Backup

1. **Automated backups with git**
   ```bash
   # Setup automated push
   git config --global push.autoSetupRemote true
   ```

2. **Export content**
   ```bash
   # Backup all markdown files
   tar -czf blog-backup-$(date +%Y%m%d).tar.gz /path/to/obsidian-vault/blog/
   ```

#### Site Recovery

1. **Restore from backup**
   ```bash
   # Extract backup
   tar -xzf blog-backup-YYYYMMDD.tar.gz
   
   # Restore git state
   git reset --hard HEAD~1  # Go back one commit
   ```

2. **Emergency deployment**
   ```bash
   # Force rebuild all pages
   hugo --gc --cleanDestinationDir
   git add .
   git commit -m "Emergency rebuild"
   git push origin main
   ```

## Support and Resources

### Documentation Links

- **Hugo Documentation**: https://gohugo.io/documentation/
- **Hugo Themes**: https://themes.gohugo.io/
- **GitHub Actions**: https://docs.github.com/en/actions
- **GitHub Pages**: https://docs.github.com/en/pages
- **Obsidian**: https://obsidian.md/

### Community Resources

- **Hugo Discourse**: https://discourse.gohugo.io/
- **Hugo GitHub**: https://github.com/gohugoio/hugo
- **Theme Issues**: Check individual theme repositories

### Development Tools

- **Hugo Debug Mode**: `hugo server --debug`
- **Live Reload**: `hugo server --disableFastRender`
- **Build Performance**: `hugo --templateMetrics`
- **Content Analysis**: `hugo list all`

---

*This manual was generated as part of the Blog Hero project development workflow. For updates and contributions, please refer to the project repository.*