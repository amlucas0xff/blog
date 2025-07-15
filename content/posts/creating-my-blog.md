---
date: '2024-08-10T00:00:00+03:00'
title: "Creating My Blog: A Developer's Tale of Over-Engineering"
draft: false
author: 'Blog Hero Developer'
tags: ['Hugo', 'Obsidian', 'GitHub Pages', 'Development', 'Blogging']
categories: ['Development']
description: 'A walkthrough of creating a blog with Hugo, Obsidian integration, and automated GitHub Pages deployment'
---

# Creating My Blog: A Developer's Tale of Over-Engineering

*Using Obsidian, Hugo and GitHub Pages*

**Estimated Reading time: 15 minutes**

## Intro

**TL;DR**: If you just wanna know how to do this, and don't care about the actual post, skip to the [Dead-eyed tutorial](#dead-eyed-tutorial) at the bottom.

I've wanted to start a blog for quite a while now, and never got around to it because of various nonsense excuses. When I finally decided to start, I struggled to choose the content for the first post. And so I did what every decent software developer would do when they begin: over-engineered the shit out of the blog itself rather than focus on what matters - the content. But this over-engineering was quick, integrated smoothly with my workflow, was relatively isolated and not super opinionated, and presented an integration issue that, once solved, ended up being pretty damn convenient.

Lightbulb - this would be the topic of my first post! Instead of just a tutorial, it will be a walkthrough on how an actual development process of something pretty simple actually goes and how I personally approach things (I'll save the obligatory 'what I think about all this AI shenanigans' post for later. This is not LinkedIn after all.)

P.S.: I'm well aware that there are probably more blog creation platforms available out there than the amount of stars in the visible universe. And I guess that with some research I would probably find something pretty damn fantastic. But I wanted do it myself because of reasons. So there.

## What I want

I want a blog that will blend seamlessly with my daily driver for note taking, and feel seamless and smooth.

My requirements:

- Use Obsidian exclusively for writing, editing, and managing posts. No extra vaults. The blog should integrate smoothly with my existing workflow (because I have automatic backups and versioning, and because I said so.)
- Nice looking blog - plain HTML with won't cut it because of my Obsidian requirement, so I need a markdown parser of some sort.

## How I chose the tools

- **Obsidian** - My go-to for all note-taking. I use a Zettlekasten-esque method, dumping all notes into one directory with timestamps and links. It's markdown-based and has vim-mode, plugins, internal linking and searching capabilities. This made it a no-brainer for me.
- **GitHub Pages** - I've been using GitHub for years, so it was the obvious choice for hosting and publishing. Static pages fit my needs perfectly, avoiding unnecessary complexity. I was thinking about hosting it on one of my Raspberry PIs I have lying around but then I figured… nah.
- **Hugo** - This Go-based website framework won out after some research (Googling "Github static blog serving" and then "Jekyll vs. "). I considered Jekyll, 11ty, and Astro, and since this is a website building framework, I was pretty sure Hugo's use of Go will use its native templating language. Plus, Go > Ruby, tsx, and JavaScript in my book.

## Hello blorgd (nailed it) - initial setup

Nice, We've got the tools. Let's put them to use.

A quick intro to Hugo yielded the following to get started:

```bash
hugo new site quickstart
cd quickstart
git init
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.git themes/ananke
echo "theme = 'ananke'" >> hugo.toml
hugo server
```

But hold on a minute, we can't have just any old regular theme. A quick search got led me to this lovely gallery to choose from. hugo-blog-awesome looks nice, scrolling down the page a bit we get how to install it instead of that ananke theme (which I didn't even look at once, because fuck default values). Nice.

```bash
hugo mod get github.com/hugo-sid/hugo-blog-awesome # good old Go
```

and also adding this to the hugo.toml file:

```toml
[module]
  [[module.imports]]
    path = "github.com/hugo-sid/hugo-blog-awesome"
```

Now that I've set this up, I wandered around the directory to understand the file structure and learned how Hugo organizes its files and gave me a head start on integrating it with Obsidian.

## Accumulating experience

There's a reason I examined the directory structure, even though it wasn't immediately necessary.

Throughout our careers we encounter many tools and frameworks, and we need to use, create and integrate with them. This process helps us develop a sense for how things work. That's raw experience right there, but it needs to be indexed. Ultimately, this is what helps us estimate better, break down tasks easier and be more confident.

Understanding a tool's structure before reading the documentation (notice how I didn't say instead?) helps me develop an intuition about how it works and what the developer's intentions were because at this point in time, the docs are just a bunch of words and terminology I don't know yet. The more I do this, the better I get at predicting how tools function and how to operate them.

I've seen many developers ask, "How would you know that? We've never seen this before." The (annoying) answer often is, "I just had a feeling." (or "I don't know.") This is why. It's not because they know everything but because they've developed an intuition from past experiences.

## Obsidian integration

OK we got something that looks like something. And I think that I have a rough understanding of how Hugo works (enough to get started). But before that - I formulate a rough plan in mind:

1. I'll create a dedicated directory for the blog in my Obsidian vault
2. Find some plugin/script that allows me to automatically move notes that are tagged (or something of that sort) to that directory automatically
3. I'll symlink ./content and my ./obsidian-vault/blog directory (remember this moment)
4. Find some way to inject the necessary metadata to each note (probably using Obsidian templates that I've been using for a long time)
5. Automate the publish process using GitHub Actions

Cool. Now it's time for the interesting part - integration.

## Solving the integration issue

This is why I wanted to write this blog post- and not just another dead-eyed tutorial. To me, this is the essence of programming: solving unexpected issues.

When I encounter these situations, it's important to:

1. Isolate the unknowns
2. Revisit plans and adjust

### Isolating unknowns

In those drawing tutorials, artists start with basic shapes and build from there. When you watch them work, they skip these steps because it's already ingrained in them. They see the whole picture.

When I broke down the steps of creating this blog, I kinda did the same thing. Notice the pattern:

1. Install Hugo
2. Learn just enough to serve it
3. Ensuring I actually like it (theme, folder structure)
4. Creating a first page with Hugo in the recommended and well documented way
5. Move that same first page to another (Obsidian) directory and symlink it

These steps might seem trivial, but many developers jump straight into coding without testing along the way. This leads to too many unknowns piling onto one another, making debugging a nightmare. When integrating tools, people often overlook the connection as a component of complexity. In this case, we have Hugo, Obsidian, and the connection between them—those are three points of failure, not just two!

My options turned out to be:

1. Using a builtin function - preferable if found
2. Automate copying files from Obsidian—not ideal due to more moving parts and potential sync issues.
3. Use gitmodules - this would require me to manage my blog posts in a separate git, and have an automation to update it. Lets leave this as an absolute last resort

The docs' side-panel showed (along many more items):

- Content management - Mainly about formatting.
- Hugo modules - Interesting!
- Hosting and deployment - remember for later.

> Hugo Modules are the core building blocks in Hugo. A module can be your main project or a smaller module providing one or more of the 7 component types defined in Hugo: static, content, layouts, data, assets, i18n, and archetypes.

Yep, that's it. Configuring a content module within hugo.toml:

```toml
[module]
  [[module.mounts]]
    source = '/path/to/source/content'
    target = '/path/to/target/content'
```

Got it.

### Revisit plans and adjust

1. ✅ I'll create a dedicated directory for the blog in my Obsidian vault
2. ✅ I'll ~~symlink ./content and my ./obsidian-vault/blog directory~~ Mount my blog source directory to Hugo
3. ✅ Find some way to inject the necessary metadata to each note (probably using Obsidian templates that I've been using for a long time)
4. ✅ Find some plugin/script that allows me to automatically move notes that are tagged (or something of that sort) to that directory automatically
5. ✅ Automate the publish process using GitHub Actions

## Automatically injecting the metadata

OK now that I know that this works, all I need to do is to make Obsidian create the files like Hugo wants it to. Since the files can be created within Obsidian I have 3 ways to go about it:

1. Make Hugo read Obsidian metadata—preferable.
2. Inject metadata automatically on push—possible but error-prone.
3. Make Obsidian behave like Hugo's metadata—last resort.

Now let's use some experience, and the docs again - this format that we've seen before

```toml
+++
date = '{{ .Date }}'
draft = true
title = '{{ replace .File.ContentBaseName `-` ` ` | title }}'
+++
```

Looks awful similar to the Obsidian format for metadata, isn't it?

```yaml
---
date: <date>
draft: true
title: Some title
---
```

What do you know? it appears that this is the default TOML format, clicking on the YAML format shows me exactly what I want to see. Nice.

OK. Now - either there's a flag to use TOML/YAML/JSON, or it just works. Let's try YAML just because its easy before trying to find it in the docs. What do you know x2? It works right off the bat.

Obsidian integration almost complete, all I have to do is massage the metadata like Hugo expects it to be, and we're done. gg ez.

## Automatic publish

So to recap - in order to create a post, I need to:

1. Create a new note/navigate to an existing note in Obsidian
2. CMD+T (my binding for templates) and choose Blog - this automatically moves the file to the blog directory, which is in turn mounted to Hugo's content

Nice. Simple.

Lets set up a pre-commit hook in git in .git/hooks/pre-commit:

```bash
hugo
if [ $? -ne 0 ]; then
	echo "Hugo build failed. Aborting commit."
	exit 1
fi
git add public resources
```

All I have to do it push the website whenever I want (using git) and for it to automatically publish it to the blog.

Enter GitHub Actions. Luckily, we saw earlier in the docs the exact thing we need - Hosting and deployment (in the side bar), and what do you know - Host on GitHub Pages.

Their tutorial is a bit out-dated, I had to switch to GitHub actions and select a Hugo template that is given there - a quick comparison between what was in their instructions and the actual template from GitHub showed the the template is fine and I just committed it using the GitHub UI.

## Summary

That does it. We've got a blog!

By isolating issues, revisiting plans, and leveraging existing tools, we've turned a potential roadblock into a learning experience. Now, creating and publishing a blog post is seamless and integrated into my daily workflow.

While I skipped some details like hooking automatic local build before push, add a "Sync Blog" command to Obsidian, implementing analytics, handling Obsidian inner links, customizing and making the blog look nicer and registering the domain name, but I invite you to customize and do things however the hell you wanna do them.

This felt like a great blog post to start my writing journey (which took WAY too long) because it was about the nature of programming and why I love it so much, using a very simple and isolated example. I went into each detail in-depth, and it might seem intimidating at first - but these things become second nature pretty quickly, and this is how experience is built!

If you've reached this far, thank you very much! I appreciate you very much, and hope to see you again in the next post!

## Dead-eyed tutorial

For all you people who just wanna follow the recipe, here it is:

### Tools Overview

- **Obsidian**: For writing and managing notes.
- **GitHub**: For hosting and publishing the blog.
- **Hugo**: For generating the static site.

### Step-by-Step Instructions

```bash
# install hugo
brew install hugo

# create new hugo website
hugo new site deadeye-tut
cd deadeye-tut
git init

#  install theme
git submodule add https://github.com/theNewDynamic/gohugo-theme-ananke.gitthemes/ananke
echo "theme = 'ananke'" >> hugo.toml

# serve
hugo server -D

# create dedicated blog directory in obsidian
mkdir /path/to/obsidian-vault/blog
```

Add the following to hugo.toml:

```toml
[module]
  [[module.mounts]]
    source = '/path/to/obsidian-vault/blog'
    target = 'content'
```

Install Templater in Obsidian:

1. Go to Obsidian Settings
2. Community Plugins
3. Browse
4. Search for "Templater"
5. Install and enable it

Create a Templater template:

```yaml
---
date: <% tp.file.creation_date("YYYY-MM-DDTHH:mm:ss+03:00") %>
draft: "true"
title: <% tp.file.title %>
---
<% tp.file.move('/blog/' + tp.file.title) %>
```

GitHub integration and automation:

1. Create a GitHub repo
2. Push the code from your local repo
3. In the repo's page, go to "Settings" and "Pages" in the side-bar
4. Change "Source" to GitHub actions and choose the Hugo template -> next next next until you're done and commit

Add pre-commit hook in .git/hooks/pre-commit

```bash
hugo
if [ $? -ne 0 ]; then
	echo "Hugo build failed. Aborting commit."
	exit 1
fi
git add public resources
```

Lastly:

```bash
git push -u origin main
```

---

*This post was created as part of the Blog Hero project - demonstrating a complete Hugo + Obsidian + GitHub Pages workflow.*