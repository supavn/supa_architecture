# Documentation Site Setup Guide

This guide explains how to set up and configure the Jekyll documentation site for Supa Architecture.

## What Was Installed

### 1. Jekyll Site Structure

```
docs/
├── _config.yml          # Jekyll configuration
├── Gemfile              # Ruby dependencies
├── .gitignore           # Git ignore rules
├── index.md             # Home page
├── overview.md          # Overview page
├── architecture.md      # Architecture documentation
├── core-concepts.md     # Core concepts
├── authentication.md    # Authentication system
├── state-management.md  # State management
└── error-handling.md    # Error handling
```

### 2. GitHub Actions Workflow

Located at `.github/workflows/jekyll-gh-pages.yml`, this workflow:

- Triggers on pushes to the `main` branch (when docs/ files change)
- Builds the Jekyll site using Ruby 3.2
- Deploys to GitHub Pages automatically
- Requires GitHub Pages to be enabled in repository settings

### 3. Theme Configuration

The site uses the **just-the-docs** theme v0.10.0 with:

- Responsive design
- Built-in search functionality
- Navigation sidebar
- Code syntax highlighting
- Dark mode support
- Edit on GitHub links

## GitHub Pages Setup

To enable GitHub Pages for this repository:

1. Go to repository **Settings** → **Pages**
2. Under **Source**, select **GitHub Actions**
3. The site will be deployed automatically on the next push to `main`
4. Access the site at: `https://supavn.github.io/supa_architecture/`

## Local Development

### First-Time Setup

```bash
cd docs
bundle install
```

### Running Locally

```bash
bundle exec jekyll serve
```

Then open `http://localhost:4000/supa_architecture/` in your browser.

### Building for Production

```bash
bundle exec jekyll build
```

Output will be in `docs/_site/`.

## Adding New Documentation Pages

1. Create a new `.md` file in `docs/`
2. Add front matter:

```yaml
---
title: New Page Title
layout: default
nav_order: 10
description: "Brief description of the page"
permalink: /new-page/
---
```

3. Write content in Markdown
4. Update navigation links in related pages

## Customization

### Site Configuration

Edit `docs/_config.yml` to change:

- Site title and description
- Base URL and repository URL
- Color scheme
- Search settings
- Navigation structure

### Theme Settings

The just-the-docs theme provides many customization options:

- **Color schemes**: light (default) or dark
- **Navigation**: Configure sort order and structure
- **Search**: Customize search behavior
- **Callouts**: Warning, note, tip boxes
- **Footer**: Custom content and links

See [just-the-docs documentation](https://just-the-docs.github.io/just-the-docs/) for more options.

## Troubleshooting

### Build Fails

- Check Ruby version (should be 3.2+)
- Run `bundle update` to update dependencies
- Check Jekyll error messages in workflow logs

### Pages Not Deploying

- Ensure GitHub Pages is enabled (Settings → Pages)
- Check workflow status in Actions tab
- Verify `baseurl` in `_config.yml` matches repository name

### Local Server Issues

- Clear Jekyll cache: `rm -rf _site .jekyll-cache`
- Reinstall dependencies: `bundle install`
- Check for port conflicts (default: 4000)

## Best Practices

1. **Keep documentation up to date**: Update docs when code changes
2. **Use clear headings**: Help with navigation and search
3. **Add code examples**: Make concepts concrete
4. **Link between pages**: Create a connected documentation web
5. **Test locally**: Preview changes before committing

## Resources

- [Jekyll Documentation](https://jekyllrb.com/docs/)
- [just-the-docs Theme](https://just-the-docs.github.io/just-the-docs/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Markdown Guide](https://www.markdownguide.org/)
