# Supa Architecture Documentation

This directory contains the documentation for the Supa Architecture framework, built with Jekyll and the just-the-docs theme.

## Local Development

### Prerequisites

- Ruby 3.2 or higher
- Bundler

### Setup

1. Install dependencies:

```bash
cd docs
bundle install
```

2. Run the Jekyll server:

```bash
bundle exec jekyll serve
```

3. Open your browser to `http://localhost:4000/supa_architecture/`

### Building

To build the site without running the server:

```bash
bundle exec jekyll build
```

The built site will be in the `_site` directory.

## Deployment

The documentation is automatically deployed to GitHub Pages when changes are pushed to the `main` branch. The workflow is defined in `.github/workflows/jekyll-gh-pages.yml`.

### Troubleshooting Deployment

If the site loads but CSS is missing:

1. **Check GitHub Pages Settings**: Settings → Pages → Source should be "GitHub Actions"
2. **Verify baseurl**: In `_config.yml`, baseurl should be `/supa_architecture`
3. **Clear cache and rebuild**:
   ```bash
   cd docs
   rm -rf _site .jekyll-cache
   bundle install
   bundle exec jekyll serve
   ```
4. **Check workflow logs**: Go to Actions tab and review the latest workflow run

See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for detailed solutions.

## Documentation Structure

- `index.md` - Home page
- `overview.md` - Framework overview
- `architecture.md` - Architectural design
- `core-concepts.md` - Core concepts and patterns
- `authentication.md` - Authentication system
- `state-management.md` - State management with BLoC
- `error-handling.md` - Error handling system

## Adding New Pages

1. Create a new markdown file in the `docs/` directory
2. Add front matter with appropriate metadata:

```yaml
---
title: Page Title
layout: default
nav_order: 8
description: "Page description"
permalink: /page-url/
---
```

3. Add content using standard markdown
4. Update navigation links in related pages

## Theme

The documentation uses the [just-the-docs](https://just-the-docs.github.io/just-the-docs/) theme, which provides:

- Responsive design
- Built-in search
- Navigation sidebar
- Code syntax highlighting
- Dark mode support

## Configuration

The site configuration is in `_config.yml`. Key settings include:

- `title`: Site title
- `description`: Site description
- `baseurl`: Base URL path (for GitHub Pages)
- `url`: Site URL
- Theme settings and plugins

## License

The documentation content is part of the Supa Architecture framework.
