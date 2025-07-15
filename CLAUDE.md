# Blog Hero - Agentic Development Instructions

## Project Overview

This project is a Hugo-based blog with Obsidian integration for content creation, hosted on GitHub Pages with automated deployment. The goal is to create a seamless workflow where blog posts can be written in Obsidian and automatically published through GitHub Actions.

## Core Directives

**CRITICAL RULE: Commit every relevant change.**

After any step that results in a file modification, creation, or deletion, you MUST perform a `git commit` with a clear, descriptive message related to the completed step. This ensures atomic changes and maintains a clean project history.

## Task Execution Plan

Execute the following tasks sequentially to complete the blog setup:

### **Task 1: Set Up GitHub Repository and Pages (Ref: Task #7)**
**Goal**: Create and configure the GitHub repository for hosting.
**Steps**: 
1. Create a new GitHub repository for the project
2. Push the local Hugo project to the remote repository using `git remote add origin <repo-url>` and `git push`
3. Navigate to the repository's Settings > Pages
4. Set the source to 'GitHub Actions' to enable automated deployment
5. Commit any configuration changes

### **Task 2: Automate Deployment with GitHub Actions (Ref: Task #8)**
**Goal**: Configure automated Hugo site building and deployment.
**Steps**:
1. Create the `.github/workflows/` directory in your project
2. In the GitHub repository, go to Actions > New workflow
3. Select the Hugo template from the available workflow templates
4. Create a `hugo.yml` file in `.github/workflows/` with the Hugo deployment workflow
5. Commit the new workflow file with message "Add Hugo deployment workflow"
6. Test the workflow by pushing a change and verifying deployment

### **Task 3: Implement Local Pre-commit Hook for Build Verification (Ref: Task #9)**
**Goal**: Ensure builds are validated before commits.
**Steps**:
1. Create an executable file at `.git/hooks/pre-commit`
2. Add the following script content:
   ```bash
   #!/bin/bash
   hugo
   if [ $? -ne 0 ]; then
       echo "Hugo build failed. Aborting commit."
       exit 1
   fi
   git add public resources
   ```
3. Make the file executable with `chmod +x .git/hooks/pre-commit`
4. Test by making a content change and attempting a commit
5. Commit the hook documentation or related changes

### **Task 4: Finalize and Publish First Post (Ref: Task #10)**
**Goal**: Complete the content creation and publishing workflow.
**Steps**:
1. Open the existing blog post content from INSTRUCTIONS.md
2. Apply proper Hugo front matter formatting using YAML:
   ```yaml
   ---
   date: "2024-08-10T00:00:00+03:00"
   title: "Creating My Blog: A Developer's Tale of Over-Engineering"
   draft: false
   ---
   ```
3. Create the content file in the appropriate Hugo content directory
4. Test locally with `hugo server` to verify the post displays correctly
5. Commit the new blog post with message "Add first blog post"
6. Push to GitHub to trigger automated deployment
7. Verify the post is live on GitHub Pages

### **Task 5: Create Comprehensive Project Documentation (Ref: Task #11)**
**Goal**: Document the complete project setup and maintenance procedures.
**Steps**:
1. Create a `MANUAL_GUIDE.md` file in the project root
2. Document the following sections:
   - **Project Overview**: Hugo + Obsidian + GitHub Actions tech stack
   - **Setup Instructions**: Required software (Git, Hugo, Obsidian) and configuration
   - **Content Workflow**: Step-by-step guide for creating and publishing posts
   - **Theme Management Guide**: Instructions for changing Hugo themes including:
     * Finding themes on Hugo's official website
     * Adding themes as Git submodules: `git submodule add <theme_url> themes/<theme_name>`
     * Updating `hugo.toml` to set the new theme
     * Testing theme changes locally with `hugo server`
   - **Troubleshooting**: Common issues and solutions for failed builds or deployments
3. Test the documentation by following the theme change procedure
4. Commit the documentation with message "Add comprehensive project documentation"

### **Task 6: Create Agentic Coding Instructions (Ref: Task #12)**
**Goal**: Generate this CLAUDE.md file for future AI agent development work.
**Steps**:
1. Create this `CLAUDE.md` file in the project root
2. Synthesize all project tasks into clear, sequential instructions
3. Emphasize the commit-after-every-change directive
4. Include task references for traceability
5. Commit this file with message "Add agentic development instructions"

## Implementation Notes

- **Hugo Configuration**: The project uses Hugo with a custom theme and content mounting
- **Obsidian Integration**: Content is written in Obsidian and moved to Hugo's content directory
- **Automated Workflow**: GitHub Actions handles building and deployment
- **Quality Assurance**: Pre-commit hooks ensure builds succeed before commits
- **Documentation**: Comprehensive guides support future maintenance and theme changes

## Success Criteria

1. ✅ GitHub repository is created and configured for Pages
2. ✅ GitHub Actions workflow successfully builds and deploys Hugo site
3. ✅ Pre-commit hook validates builds before allowing commits
4. ✅ First blog post is published and accessible on GitHub Pages
5. ✅ Complete documentation exists for project maintenance
6. ✅ This CLAUDE.md file provides clear instructions for future development

**Remember**: After completing each task, commit your changes with a descriptive message and verify the next task's dependencies are met before proceeding.