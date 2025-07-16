# Blog Hero - Cleanup Proposal

Analysis of unused and redundant files/directories that can be safely removed to clean up the project.

## 🗂️ Files & Directories Recommended for Removal

### **🎯 HIGH PRIORITY - Safe to Remove**

#### **1. Legacy Content Files**
```
📁 content/posts/
├── creating-my-blog.md
├── first-post.md  
├── hello-world.md
├── obsidian-test-post.md
└── test-sync-post.md
```
**Reason**: These are old format markdown files. Content now comes from `/tmp/obsidian-vault/blog-bundles/` as page bundles. These files create duplicate content and confusion.

#### **2. Empty Content Directory**
```
📁 content/post/
```
**Reason**: Empty directory. Content is mounted from Obsidian vault via module configuration.

#### **3. Unused Theme Directories**
```
📁 themes/blowfish/           (~50MB, 1000+ files)
📁 themes/congo/             (~30MB, 800+ files)  
📁 themes/hextra/            (~20MB, 500+ files)
📁 themes/papermod/          (~10MB, 300+ files)
📁 themes/stack-starter/     (~2MB, 50+ files)
```
**Reason**: Only `themes/stack/` is being used (via Hugo modules). These downloaded themes are taking up significant disk space and are not needed.

#### **4. Deprecated Scripts**
```
📁 scripts/
├── obsidian-sync.py
├── setup-obsidian-sync.sh
└── watch-obsidian.py
```
**Reason**: These were early automation attempts. Current workflow uses Hugo modules with automatic mounting. Scripts are no longer used.

#### **5. Legacy Configuration Files**
```
📄 requirements.txt
```
**Reason**: Python requirements file not needed since scripts are removed and current workflow is pure Hugo/Git.

### **🔍 MEDIUM PRIORITY - Consider Removing**

#### **6. Generated Public Directory** (Optional)
```
📁 public/                   (~5MB, 200+ files)
```
**Reason**: Auto-generated on each build. Can be safely removed and will be recreated. However, useful for local testing.

#### **7. Hugo Resources Cache** (Optional)  
```
📁 resources/_gen/
```
**Reason**: Hugo's generated resources cache. Will be recreated as needed, but speeds up subsequent builds if kept.

### **🚫 DO NOT REMOVE - Essential Files**

#### **Core Hugo Configuration**
- `config/_default/` - All TOML files (essential configuration)
- `hugo.toml` - Main Hugo config
- `go.mod`, `go.sum` - Hugo modules dependencies

#### **Content Sources**
- `content/page/` - Static pages (About, Search, Archives)
- `/tmp/obsidian-vault/blog-bundles/` - Active content source (external)

#### **Theme and Assets**
- `themes/stack/` - Current active theme (via modules)
- `assets/` - Custom icons and avatar
- `static/` - Static files (favicon, images)

#### **Project Documentation**
- `CLAUDE.md` - Project instructions
- `CONTENT_CREATION_MANUAL.md` - User manual
- `README.md` - Project documentation

#### **Build Artifacts** (Keep for now)
- `archetypes/` - Content templates
- `layouts/`, `data/`, `i18n/` - Custom overrides (if any)

---

## 📊 Cleanup Impact Summary

| Category | Files | Size | Impact |
|----------|-------|------|---------|
| **Legacy Content** | 5 files | ~20KB | ✅ Removes duplicate content |
| **Unused Themes** | 2500+ files | ~110MB | ✅ Major disk space savings |
| **Deprecated Scripts** | 3 files | ~15KB | ✅ Removes unused automation |
| **Empty Directories** | 1 dir | 0KB | ✅ Cleaner structure |
| **Generated Files** | 200+ files | ~5MB | 🔄 Optional, regenerated |

**Total Savings**: ~110MB, 2500+ files removed

---

## 🛠️ Cleanup Commands

### **Safe Removal Commands**

```bash
# Navigate to project root
cd /home/amlucas/Desktop/blog-hero

# Remove legacy content files
rm -rf content/posts/
rm -rf content/post/

# Remove unused themes (MAJOR space savings)
rm -rf themes/blowfish/
rm -rf themes/congo/
rm -rf themes/hextra/
rm -rf themes/papermod/
rm -rf themes/stack-starter/

# Remove deprecated scripts
rm -rf scripts/
rm -f requirements.txt

# Optional: Clear generated files (will be recreated)
rm -rf public/
rm -rf resources/_gen/

# Commit cleanup
git add -A
git commit -m "Clean up unused files and themes

- Remove legacy content/posts/ files (now use Obsidian bundles)
- Remove unused Hugo themes (blowfish, congo, hextra, papermod, stack-starter)  
- Remove deprecated Python scripts and requirements.txt
- Clear generated public/ and resources/ directories

Saves ~110MB and 2500+ files"
```

### **Verification Commands**

```bash
# Test that site still builds correctly
hugo --cleanDestinationDir

# Test local server
hugo server --port 1313

# Check that all pages work:
# - http://localhost:1313/blog/
# - http://localhost:1313/blog/about/
# - http://localhost:1313/blog/search/
# - http://localhost:1313/blog/archives/
```

---

## ⚠️ Pre-Cleanup Checklist

Before running cleanup commands:

- [ ] **Backup current state**: `git add -A && git commit -m "Pre-cleanup backup"`
- [ ] **Verify current functionality**: Test all pages and navigation
- [ ] **Confirm content source**: Ensure `/tmp/obsidian-vault/blog-bundles/` has all posts
- [ ] **Check theme dependency**: Confirm Stack theme works via Hugo modules

---

## 🔄 Post-Cleanup Verification

After cleanup:

- [ ] **Build succeeds**: `hugo --cleanDestinationDir` runs without errors
- [ ] **All pages accessible**: Home, About, Search, Archives work
- [ ] **Navigation functional**: Menu items appear correctly
- [ ] **Content displays**: Blog posts from Obsidian bundles show properly
- [ ] **Assets load**: Avatar, favicon, custom icons work
- [ ] **Search works**: Search functionality operational

---

## 📈 Benefits of Cleanup

### **Immediate Benefits**
- **110MB disk space** saved
- **2500+ fewer files** in repository
- **Cleaner project structure**
- **Faster git operations** (fewer files to track)
- **Reduced confusion** from legacy files

### **Long-term Benefits**
- **Easier maintenance** with fewer files
- **Faster deployments** (smaller repository)
- **Clear content flow** (only Obsidian → Hugo)
- **Simplified debugging** (no duplicate content)

### **Development Benefits**
- **Faster IDE indexing** 
- **Cleaner file explorer**
- **Focus on active files only**
- **Reduced cognitive load**

---

## 🚨 Rollback Plan

If issues arise after cleanup:

```bash
# Restore from git if needed
git log --oneline -5
git reset --hard <commit-before-cleanup>

# Or restore specific directories
git checkout HEAD~1 -- themes/
git checkout HEAD~1 -- content/posts/
git checkout HEAD~1 -- scripts/
```

---

## 📝 Notes

- **Theme modules**: Using Hugo modules for Stack theme is more efficient than local themes
- **Content strategy**: Obsidian bundles in `/tmp/obsidian-vault/blog-bundles/` are the single source of truth
- **Build process**: Hugo automatically handles module downloads and content mounting
- **Future additions**: New themes should be added via Hugo modules, not local directories

---

**Recommendation**: Execute HIGH PRIORITY removals immediately for significant benefits with minimal risk. MEDIUM PRIORITY removals are optional but provide additional cleanup benefits.