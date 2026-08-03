---
title: "Standalone Example"
url: "/posts/standalone-example"
date: 2026-07-25T00:00:00-05:00
layout: "standalone"
customCSS: "css/posts/example.css"
customJS: "js/posts/example.js"
description: "A post that owns its whole page, and how to make another one."
draft: true
categories:
- Content
tags:
- Blog
---

<section class="hero">
  <h1>Own the page</h1>
  <p>No header, no footer, no theme stylesheet — just this document.</p>
</section>

<div class="prose">

This page is its own template. Copy it as the starting point for any post that
needs to look nothing like the rest of the site. Everything below explains how.

## Where each piece lives

| Piece | Goes in | Referenced by |
| --- | --- | --- |
| HTML | this file, `content/post/<name>.md` | nothing — it's the post body |
| CSS | `assets/css/posts/<name>.css` | `customCSS` in frontmatter |
| JS | `assets/js/posts/<name>.js` | `customJS` in frontmatter |

Both asset paths are relative to `assets/`, so `assets/css/posts/thing.css` is
written as `css/posts/thing.css`.

## 1. Create the post

Copy this file to `content/post/YYYY-MM-DD-yourname.md` and edit the
frontmatter. The two lines that matter are `layout` and `url`:

```yaml
---
title: "Your Title"
url: "/posts/your-slug"
date: 2026-07-25T00:00:00-05:00
layout: "standalone"
customCSS: "css/posts/your-slug.css"
draft: true
---
```

`layout: "standalone"` is what strips the theme. Drop it and the post renders
normally, so you can always fall back.

## 2. Add your CSS

Create `assets/css/posts/your-slug.css` and point `customCSS` at it. It gets
minified and fingerprinted automatically, and served with an integrity hash.

Use a directory under `assets/css/posts/`, not `assets/css/extended/`. Anything
in `extended/` is bundled into the site-wide stylesheet and would leak onto
every other page. Nothing in `posts/` does.

You are starting from a blank page — no reset, no theme variables, no fonts.
That is the point, but it means `body { margin: 0 }` is on you.

## 3. Add JavaScript, if you need it

Create `assets/js/posts/your-slug.js` and point `customJS` at it. It is loaded
with `defer`, fingerprinted, and given an integrity hash, which satisfies the
site's Content-Security-Policy without needing an inline script.

To prove it runs: <span id="js-check">this sentence was written by HTML</span>

## 4. Write the HTML

The post body is the page body. Write whatever markup you want:

```html
<section class="hero">
  <h1>A headline</h1>
</section>
```

The useful part is that **markdown still works inside your HTML**, as long as
there is a blank line after the opening tag:

```html
<div class="prose">

A *markdown* paragraph, inside a raw div.

</div>
```

That renders as a real `<p>` with `<em>` inside it. Remove the blank line and
the block is passed through literally instead — that is the escape hatch when
you want byte-exact control.

## 5. Link back to the rest of the site

Cross-post links work exactly as they do in a normal post:

```markdown
[a post about delegation]({{%/* relref "/post/2025-04-02-dont-fear-delegation.md" */%}})
```

Live example: [a post about delegation]({{% relref "/post/2025-04-02-dont-fear-delegation.md" %}}),
and a plain internal link to [Topics](/topics).

Inside an HTML attribute, use the angle-bracket form instead, because the
percent form emits rendered markdown:

```html
<a href="{{</* relref "/post/2025-04-02-dont-fear-delegation.md" */>}}">Read this</a>
```

The layout also appends a link home at the bottom of every standalone page.
Restyle it with `.standalone-back`, or switch it off with `hideBackLink: true`.

## Frontmatter reference

| Key | Effect |
| --- | --- |
| `layout: "standalone"` | Required. Removes all theme chrome. |
| `customCSS` | Path under `assets/`. Optional. |
| `customJS` | Path under `assets/`. Optional. |
| `hideBackLink: true` | Removes the automatic link home. |
| `searchHidden: true` | Keeps the post out of site search. |
| `draft: true` | Excluded from production builds. |

## Worth knowing

Standalone posts still behave like posts everywhere else: they appear in list
pages, in the RSS feed, and in search. Use `searchHidden` or `hideSummary` if a
particular one shouldn't.

You keep the canonical URL, favicon, and OpenGraph tags — the layout pulls those
in so shared links still preview correctly. What you lose is the header, footer,
menu, theme stylesheet, dark-mode toggle, and reading-progress bar. Rebuild any
of those yourself if the post needs them.

Preview with `hugo server -D`, since this file is a draft.

</div>
