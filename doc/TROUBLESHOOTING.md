# Troubleshooting Jekyll Site

## CSS Not Loading

If you see the page but CSS is missing, try these solutions:

### Solution 1: Verify baseurl Configuration

The `baseurl` in `_config.yml` should match your GitHub Pages URL structure:

```yaml
# For https://username.github.io/repository-name/
baseurl: "/repository-name"

# For custom domain or username.github.io
baseurl: ""
```

**For this project:**
- Repository: `supa_architecture`
- Expected URL: `https://supavn.github.io/supa_architecture/`
- Correct baseurl: `"/supa_architecture"`

### Solution 2: Clear Jekyll Cache

If running locally:

```bash
cd docs
rm -rf _site .jekyll-cache .jekyll-metadata
bundle exec jekyll serve
```

### Solution 3: Check GitHub Pages Settings

1. Go to **Settings** → **Pages**
2. Ensure **Source** is set to **GitHub Actions** (not "Deploy from a branch")
3. Wait for the workflow to complete (check the **Actions** tab)

### Solution 4: Verify Workflow Build

1. Go to the **Actions** tab in your repository
2. Check the latest "Deploy Jekyll site to Pages" workflow run
3. Look for any errors in the build or deploy steps
4. Common issues:
   - Gemfile.lock conflicts
   - Ruby version mismatches
   - Missing permissions

### Solution 5: Test Locally First

Before pushing to GitHub, test locally:

```bash
cd docs

# Install dependencies
bundle install

# Serve locally (this will use the baseurl)
bundle exec jekyll serve

# Or serve without baseurl for easier local testing
bundle exec jekyll serve --baseurl ""
```

Then visit:
- With baseurl: `http://localhost:4000/supa_architecture/`
- Without baseurl: `http://localhost:4000/`

### Solution 6: Check Theme Installation

Ensure the just-the-docs theme is properly installed:

```bash
cd docs
bundle list | grep just-the-docs
```

Should show: `just-the-docs (0.10.x)`

If missing, run:

```bash
bundle install
```

### Solution 7: Verify Repository Name

The baseurl must match your GitHub repository name exactly:

1. Check your repository URL: `https://github.com/USERNAME/REPO-NAME`
2. Update `_config.yml`:
   ```yaml
   baseurl: "/REPO-NAME"
   ```

### Solution 8: Force Rebuild

If CSS loads locally but not on GitHub Pages:

1. Make a small change to `_config.yml` (add a comment)
2. Commit and push
3. Wait for the workflow to complete
4. Hard refresh the page (Ctrl+Shift+R or Cmd+Shift+R)

### Solution 9: Check Browser Console

Open browser developer tools (F12) and check the Console tab:

- Look for 404 errors on CSS files
- Check the CSS file URLs - they should include the baseurl
- Expected: `https://supavn.github.io/supa_architecture/assets/css/...`
- If seeing: `https://supavn.github.io/assets/css/...` → baseurl is missing

### Solution 10: Gemfile.lock Issues

If you see bundler errors:

```bash
cd docs
rm Gemfile.lock
bundle install
```

Then commit the new `Gemfile.lock`.

## Still Having Issues?

### Quick Diagnosis

Run this command to check your setup:

```bash
cd docs
echo "Ruby version: $(ruby --version)"
echo "Bundler version: $(bundle --version)"
echo "Jekyll version: $(bundle exec jekyll --version)"
echo "Theme installed: $(bundle list | grep just-the-docs)"
```

### Common Error Messages

#### "Could not find gem 'just-the-docs'"

```bash
cd docs
bundle install
```

#### "GitHub Metadata: No GitHub API authentication"

This is a warning, not an error. You can ignore it or set a GitHub token:

```bash
export JEKYLL_GITHUB_TOKEN=your_token_here
```

#### "Liquid Exception: ... in /_layouts/default.html"

The theme isn't properly installed. Try:

```bash
cd docs
rm -rf _site .jekyll-cache
bundle install
bundle exec jekyll serve
```

### Test the Setup

Create a minimal test page:

```bash
cat > docs/test.md << 'EOF'
---
title: Test Page
layout: default
---

# Test Page

If you can see styled text, CSS is working!
EOF
```

Then visit `/test/` on your site.

## Need More Help?

1. Check the [Jekyll documentation](https://jekyllrb.com/docs/troubleshooting/)
2. Check the [just-the-docs issues](https://github.com/just-the-docs/just-the-docs/issues)
3. Review the GitHub Actions workflow logs for specific errors
