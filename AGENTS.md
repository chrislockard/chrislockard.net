# Repository Guidelines

## Project Structure & Module Organization
This is a Hugo-based personal blog. Key paths:
- `content/` holds site content. Blog posts live flat in `content/post/` (no year/month folders). Projects are in `content/project/`.
- `static/` contains images, JS, and deploy assets. Security headers for Cloudflare Pages are in `static/_headers`.
- `layouts/` and `layouts/shortcodes/` define custom templates and shortcodes.
- `archetypes/` provides content templates for new posts.
- `themes/PaperMod/` is a git submodule for the theme.
- `public/` is the generated build output (do not edit by hand).

## Build, Test, and Development Commands
Run from the repo root:
- `hugo server -D` starts a local dev server and includes drafts.
- `hugo` builds the production site into `public/`.
- `git submodule update --remote --merge` updates the PaperMod theme.
Hugo version used: v0.155.x extended (Homebrew).

## Coding Style & Naming Conventions
- Posts use YAML frontmatter and live in `content/post/`.
- Filenames follow `yyyy-mm-dd-post-title.md` (example: `content/post/2026-02-06-lockd-loaded.md`).
- Weekly link roundups are titled “Lockd & Loaded” with filename pattern `yyyy-mm-dd-lockd-loaded.md`.
- Cross-post links must use Hugo shortcodes with percent syntax:

```markdown
[link text]({{% relref "/post/2025-04-02-dont-fear-delegation.md" %}})
```

## Testing Guidelines
There is no automated test suite. Validate changes by:
- Running `hugo server -D` and spot-checking pages.
- Running `hugo` and confirming the `public/` output renders correctly.

## Commit & Pull Request Guidelines
Recent commits use short, descriptive messages like “New post: …” or “New L&L: YYYY-MM-DD.” Follow that style for content updates.
For PRs, include:
- A clear summary of the change (content vs. layout vs. config).
- Any related issue or context.
- Screenshots for layout/theme changes.

## Security & Configuration Notes
- Site configuration is centralized in `config.yml`.
- Cloudflare Pages headers are managed in `static/_headers`.
