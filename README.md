# Blog Hero

A Hugo-based blog with Obsidian integration, automated deployment via GitHub Actions.

## Features

- ✅ Hugo static site generator with hugo-blog-awesome theme
- ✅ Obsidian vault integration for content creation
- ✅ YAML front matter for metadata compatibility
- ✅ Module-based content mounting from Obsidian vault
- 🚧 GitHub Actions deployment pipeline (in progress)
- 🚧 Pre-commit hooks for build verification (planned)

## Project Structure

```
blog-hero/
├── archetypes/          # Hugo content templates
├── assets/              # Hugo assets
├── content/             # Blog content (mounted from Obsidian vault)
├── data/                # Hugo data files
├── layouts/             # Custom Hugo layouts
├── static/              # Static files
├── themes/              # Hugo themes
├── hugo.toml           # Hugo configuration
├── CLAUDE.md           # AI agent instructions
└── INSTRUCTIONS.md     # Project documentation
```

## Local Development

1. Install Hugo:
   ```bash
   # Ubuntu/Debian
   sudo apt install hugo
   
   # macOS
   brew install hugo
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/USERNAME/blog-hero.git
   cd blog-hero
   ```

3. Install theme dependencies:
   ```bash
   hugo mod tidy
   ```

4. Run development server:
   ```bash
   hugo server -D
   ```

## Obsidian Integration

Content is managed through an Obsidian vault mounted as the content directory. Posts should be created in the `/blog` directory of your Obsidian vault with YAML front matter:

```yaml
---
date: '2024-07-14T22:00:00-03:00'
draft: false
title: 'Your Post Title'
---

# Your content here
```

## Deployment

This site is automatically deployed to GitHub Pages using GitHub Actions when changes are pushed to the main branch.

## Manual GitHub Repository Setup Instructions

To set up this repository on GitHub:

1. Create a new repository on GitHub named 'blog-hero'
2. Update the baseURL in hugo.toml with your GitHub username
3. Add the remote and push:
   ```bash
   git remote add origin https://github.com/USERNAME/blog-hero.git
   git branch -M main
   git push -u origin main
   ```
4. In GitHub repository settings, go to Pages
5. Set source to 'GitHub Actions'
6. The site will be available at: https://USERNAME.github.io/blog-hero/

## Development Tasks

This project uses Task Master AI for development workflow management. See CLAUDE.md for AI agent instructions.

## License

MIT License - feel free to use this as a template for your own blog!