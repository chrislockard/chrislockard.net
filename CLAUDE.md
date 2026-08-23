# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A personal blog ("Unl0ckd") built with Hugo and the PaperMod theme, hosted on Cloudflare Pages. Content covers security, privacy, faith, technology, and career topics. ~120 posts spanning 2012–2026.

## Build and Preview

```bash
# Local dev server with drafts
hugo server -D

# Production build
hugo

# Output goes to public/
```

Hugo version: v0.164.x extended (installed via Homebrew).

## Creating Posts

```bash
hugo new content post/yyyy-mm-dd-postname.md
```

Posts live flat in `content/post/` (no year/month subdirectories). The archetype at `archetypes/post.md` provides the frontmatter template. Always set the `url` field in frontmatter to `"posts/slug-name"`.

## Categories

Every post gets **exactly one** category, from a closed set of five:

| Category | Use when the subject is | Accent |
|---|---|---|
| Cyber | an attack, a defense, or a risk | security (blue-purple) |
| Technology | a tool, a workflow, or a platform | build (teal) |
| Reflection | faith, family, health, money, or self | reflection (gold) |
| Career | managing, being managed, or the work itself | personal (rose) |
| Other | none of the above | other (slate) |

The Cyber/Technology line is the one that comes up: a browser's fingerprinting
defenses are Cyber, a browser review is Technology. When a post is genuinely
both, pick the one the post is *about*, not the one that motivated it.

`Other` is an escape hatch, not a parking spot. Use it rather than forcing a bad
fit, but when it accumulates ~5 posts on one recurring theme, promote that theme
to its own category and empty `Other` back out. The predecessor category
`Content` was allowed to accumulate 44 posts and became meaningless.

Cross-cutting concerns are tags, not categories. `Privacy` is the worked example:
it spans Cyber and Technology, so it is a tag applied across both. A candidate
category whose posts would split across two existing categories is a tag.

## Tags

Consolidated from 159 to 30 on 2026-08-05. **A tag must carry at least 3 posts.**
Tags do not feed the search index — `fuseOpts.keys` in `config.yml` is title,
permalink, summary, and content only — so a tag's entire value is its own term
page, and a one-post page is a dead end. Before this pass, 101 of 159 tags were
single-use.

Tag the *thread a reader would follow*, not every proper noun in the post. The
AWS service names are the cautionary example: `CloudTrail`, `CloudWatch`,
`SecurityHub`, `WAF`, `API Gateway`, and `CloudFront` were six separate one-post
tags that all now roll up into `AWS`. Prefer an existing tag over a new one; a
genuinely new tag is only worth creating once a third post would carry it.

The canonical list lives in `tools/tag-names.tsv`. Nine terms were deleted rather
than merged and are deliberately absent from that file, so the normalizer flags
them instead of rewriting them.

Categories map to accent palettes through `data/postthemes.yaml`. That mapping is
many-to-one and independent of the category list, so the number of categories is
not constrained by the number of palettes.

## Retired: the roundup section

`content/roundup/` holds 33 retired "Lockd & Loaded" link posts. They keep their
original `/posts/...` URLs (each pins its own `url`), stay in search and the
sitemap, and are excluded from the homepage (`params.mainSections`), from RSS
(`hiddenInRss` cascaded from `content/roundup/_index.md`), and from the taxonomy
pages (they carry no categories or tags). Do not publish new posts here.

## Critical Hugo Shortcode Syntax

Cross-references to other posts **must** use `{{% %}}` (not `{{< >}}`):

```markdown
# Correct
[link text]({{% relref "/post/2025-04-02-dont-fear-delegation.md" %}})

# Wrong - will break
[link text]({{< relref "/post/2025-04-02-dont-fear-delegation.md" >}})
```

## Theme

PaperMod is a git submodule at `themes/PaperMod`. Update with:

```bash
git submodule update --remote --merge
```

## Custom Shortcodes (layouts/shortcodes/)

- `picture.html` — **the only way to insert an image.** Do not use PaperMod's
  own `{{< figure >}}` shortcode — it still technically works (it isn't
  shadowed; see below) but it skips all processing, so an accidental use will
  silently regress an image back to an unoptimized, non-responsive `<img>`. If
  you're pattern-matching off an old post and see `{{< figure`, that post
  predates this shortcode and hasn't been touched since — copy the parameters
  into `{{< picture` instead, don't copy the shortcode name.

  Params: `src` (required), `alt`, `caption`, `title`, `attr`/`attrlink`
  (photo attribution line), `align` (`center`), `float` (`left`/`right`),
  `link`/`target`/`rel` (wrap the image in an anchor), `width`/`height`
  (explicit display-size cap; otherwise the source image's own dimensions are
  the cap — never upscaled beyond either), `loading` (default `lazy`; `eager`
  also sets `fetchpriority="high"`).

  jpeg/png sources are resized to a capped width ladder and re-encoded to AVIF
  and WebP, emitted as a `<picture>` with the original format as the final
  `<img>` fallback. Anything `resources.Get` can't resolve (external URLs) or
  can't safely process (svg, gif — resizing would destroy animation) falls
  back to a plain `<img>` instead.

  This relies on a `module.mounts` entry in `config.yml` that mounts
  `static/images` a second time under `assets/images`, so `resources.Get` can
  see the same files `static/`'s passthrough already serves — nothing moves or
  is duplicated on disk. Float positioning is styled by
  `assets/css/extended/images.css`; `align=center` relies on PaperMod's own
  global `.md-content figure.align-center` rule, not project CSS.

- `callout.html` — styled callout box. Params: `emoji`, `title` (both optional), inner content. There is one kind; its color is inherited from the post's accent (`--pt-accent`), so callouts match the post theme automatically.
- `paragame.html` — embeds the p5.js Paratrooper game.
- `badge-table.html` — renders the badge collection on the About page (no params).

## Static Assets

- Images: `static/images/{year}/MM-DD-N.{png,jpg}` (e.g., `static/images/2020/01-31-1.png`) — write new images here exactly as before; the `picture.html` shortcode processing pipeline reads them through the `assets/images` mount described above, not by moving them.
- Security headers: `static/_headers` (Cloudflare Pages format)
- JavaScript: `static/js/` (p5.js and paratrooper game)
- Cloudflare functions: `functions/_middleware.js` (Middleware for CloudFlare
  Workers and Functions support e.g., rewrite visits to the blog's origin)

## Configuration

`config.yml` — single Hugo config file. Key settings:
- `buildDrafts: false`, `buildFuture: false`
- Custom output formats: HTML, JSON, RSS, and `humanstxt`
- Goldmark renderer `unsafe: true` (allows raw HTML in markdown)
- Search via Fuse.js (JSON output enables client-side search)

## Content Style

- Author does not use AI to generate post content (stated on About page). AI is used only for ideation/research assistance.
- Weekly link roundup posts are titled "Lockd & Loaded" with filename pattern `yyyy-mm-dd-lockd-loaded.md`.
- Posts use YAML frontmatter (not TOML).

## Writing Assistance Guidelines

### My voice
Direct and plainspoken. 
I don't pad sentences. I write for technically literate readers who don't 
need jargon explained but aren't specialists in every domain I cover.
Do not start sentences with adverbial phrasing or conjunctive adverbs.

### What I want from writing help
- Ideation and structure feedback: yes
- Editing for clarity: yes
- Drafting full posts in my voice: no (see About page note)
- Suggesting sources or angles I may have missed: yes

### Things to avoid
- Do not write in listicle format unless I explicitly ask
- Do not add motivational or affirming filler ("Great question!", 
  transitional phrases like "In conclusion...")
- Do not suggest changing post structure unless something is 
  genuinely broken
- Assume the reader is technical; do not over-explain concepts

### Tone by category
- Security/privacy posts: precise, some dry humor is fine
- Faith posts: sincere, not preachy, personal not prescriptive
- Career posts: practical, no hustle-culture framing

### Proofreading

When asked to proofread a post, follow Chicago Manual of Style (17th ed.)
conventions:
- Serial (Oxford) comma
- Em dashes with no surrounding spaces, not spaced en dashes or hyphens
- Numbers zero through one hundred spelled out; numerals above that, except
  for units, dates, percentages, and other conventional numeric contexts
- Title case for headings, sentence case for frontmatter titles if that's
  already the post's convention — match existing usage rather than
  overriding it
- Double quotation marks, with punctuation inside closing quotes (American
  style)
- One space after a period

Flag deviations rather than silently rewriting the author's voice choices
(e.g., sentence fragments used for effect, intentional informality). Chicago
governs mechanics — punctuation, capitalization, number style — not the
voice rules above, which take precedence when the two conflict.
