---
name: changelog-generator
description: "Generate comprehensive changelogs and release notes from git history. Identifies undocumented versions, extracts commit history between tags, creates structured release files, and maintains project release documentation. Actions: generate, create, update, document, extract git history. Features: tag comparison, commit range analysis, automated file generation, human-readable commit messages, chronological ordering."
---

# Changelog Generator - Git History Documentation

Automates the generation of release notes and changelog documentation from git tag history, creating structured markdown files with human-readable commit messages.

## How to Use This Skill

When user requests changelog generation ("generate changelog", "update release notes", "create release docs"):

### Step 1: Analyze Git History

Get all git tags and identify undocumented versions:

```bash
# Get all git tags sorted by version
git tag --list --sort=-v:refname

# Check existing release documentation
ls -1 releases/ | sort -V | tail -n 1
```

### Step 2: Identify Missing Documentation

Compare git tags with existing release files to find gaps in documentation.

### Step 3: Generate Release Files

For each undocumented tag, create structured release notes:

#### 3.1: Find Previous Tag
```bash
git describe --abbrev=0 --tags <current-tag>^
```

#### 3.2: Extract Commit History
```bash
git log <previous-tag>..<current-tag> --pretty=format:"- %s" --reverse
```

#### 3.3: Create Release File
Generate `releases/<tag>.md` with format:
```markdown
# Release Notes - <tag>

<commit-list>
```

### Step 4: Update Main Documentation

Copy latest version content to `RELEASE_NOTES.md`.

---

## Implementation Workflow

### Prerequisites Check
```bash
# Verify git repository
git status

# Check if releases directory exists
ls -la releases/ 2>/dev/null || echo "releases/ directory not found"
```

### Execution Steps

1. **Get All Tags**
   ```bash
   git tag --list --sort=-v:refname
   ```

2. **Find Last Documented Version**
   ```bash
   ls -1 releases/ | sort -V | tail -n 1
   ```

3. **Process Each Undocumented Tag**
   - Find previous tag: `git describe --abbrev=0 --tags <tag>^`
   - Get commit range: `git log <prev>..<curr> --pretty=format:"- %s" --reverse`
   - Create release file: `releases/<tag>.md`

4. **Update Main Release Notes**
   - Get latest tag: `git describe --tags --abbrev=0`
   - Copy content from latest release file to `RELEASE_NOTES.md`

---

## File Format Standards

### Release File Naming
- Pattern: `v<version>+<build>.md`
- Example: `v1.24.0+1240006.md`

### File Content Structure
```markdown
# Release Notes - v<version>+<build>

- <commit-message>
- <commit-message>
```


---

## Best Practices

### Git Commands
- Use `--reverse` flag for chronological order (oldest to newest)
- Handle edge cases: first tag, no previous tags
- Verify tag format matches project conventions

### File Management
- Never delete existing release files
- Create missing directories if needed
- Preserve existing file formatting

### Error Handling
- Check for valid git repository
- Verify tag existence before processing
- Handle empty commit ranges gracefully

---

## Example Usage

**User request:** "Generate changelog for recent releases"

**Execution flow:**
1. Run `git tag --list --sort=-v:refname` to get all tags
2. Check `releases/` directory for last documented version
3. Identify undocumented tags (e.g., v1.23.0+1230007 through v1.23.0+1230014)
4. For each tag:
   - Find previous tag
   - Extract commits with commit messages only
   - Create release file with standard format
5. Update `RELEASE_NOTES.md` with latest version only

**Output:**
- Individual release files in `releases/` directory
- Updated main `RELEASE_NOTES.md`
- Structured commit history with human-readable messages

---

## Quality Checklist

Before completing changelog generation:

### Content Verification
- [ ] All undocumented tags have release files
- [ ] Commits show only messages (no IDs or links)
- [ ] Chronological order maintained (oldest to newest)
- [ ] No duplicate entries or missing commits

### File Structure
- [ ] Release files follow naming convention
- [ ] Headers use consistent format
- [ ] Main RELEASE_NOTES.md contains only latest version
- [ ] All files are valid markdown

### Repository Integration
- [ ] No git errors during tag/commit extraction
- [ ] Commit messages are complete and readable
- [ ] Version format matches project standards
- [ ] All commits between tags are included

---

## Troubleshooting

### Common Issues
- **No tags found**: Verify git repository and tag creation
- **Missing previous tag**: Handle first release case
- **Empty commit range**: Check tag sequence and branching
- **Malformed commit messages**: Verify git log formatting

### Recovery Actions
- Use `git log --oneline` for manual verification
- Check `git describe` output for tag relationships
- Verify commit message completeness before finalizing