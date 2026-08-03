# Unl0ckd

This repo contains the content of my blog at <https://www.chrislockard.net>

## HWTO

Hugo and papermod have changed significantly in the past two years. These notes
capture how to manage this blog today.

### PaperMod Installation

Follow the [instructions here](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation).

### Update PaperMod Theme

From the root directory of this site, run `git submodule update --remote --merge`

Two things to know before updating:

`disableScrollToTop: true` in `config.yml` does **not** mean the scroll-to-top
button is off. That flag gates both the button markup and PaperMod's
`window.onscroll` handler, and only the handler was unwanted — it is
non-passive and fires on every scroll event. The button is rendered by
`layouts/_partials/extend_footer.html` and driven by `assets/js/scroll-ui.js`
instead, using the theme's own `.top-link` classes so it looks identical.

`layouts/_default/terms.html` is a full copy of the theme's `taxonomy.html`,
changed to sort terms by count instead of alphabetically and to print `.Name`
rather than `.LinkTitle` so `FOSS` is not re-cased. It will not pick up
upstream changes to that template. After a theme update, compare the two if
`/tags/` or `/categories/` looks wrong.

### Cloudflare build environment

`HUGO_VERSION` must be set to **0.164.0** (or anything 0.156+) in the Cloudflare
Pages dashboard under Settings → Environment variables, for both Production and
Preview. Hugo cannot be pinned from a file in the repo the way Node and Ruby
can, so this setting is invisible here.

Pages defaults to Hugo 0.147.7, which is new enough for PaperMod but too old for
`hugo.Data` in `layouts/_partials/pt-resolve.html` — that needs 0.156+. On the
default the build *fails*, and Pages responds by continuing to serve the last
successful deploy, so the site looks fine while new changes silently never
appear. Check the build log under Deployments if that ever happens again.

Keep the pinned version matched to local Hugo. When they drift, a build that is
clean locally can fail in production with no warning.

### Creating posts

>New posts used to be created in a year/month/day folder hierarchy. Now, they
 are
>all contained under /content/post/<yyyy-mm-dd-postname.md>

These can be created using

`hugo new content post/yyyy-mm-dd-postname`

### Linking to previous posts

This is the chief source of my frustration, as the `rel` and `relref` shortcodes
changed to requiring `{{% %}}` syntax instead of `{{< >}}` at some point
since 2022.

No: `[Nearly a year ago,]({{< relref
"/content/post/2017-10-20-lesson-for-bug-bounty-researchers.md" >}})`

Yes: `[Nearly a year ago,]({{% relref
"/post/2017-10-20-lesson-for-bug-bounty-researchers.md" %}})`

For more, see [the Hugo shortcode
reference](https://gohugo.io/content-management/shortcodes/)

## Post theming

Posts get an accent color based on their subject. Security posts read
blue-purple, reflection posts gold, and so on. The accent drives links, the
standfirst under the title, section-heading hairlines, the blockquote rule,
horizontal rules, the tag pills in the footer, and the reading-progress bar,
plus a faint radial wash behind the page.

Nothing needs to be added to a post to make this work. The accent comes from the
post's first `categories` entry.

### The four pieces

| File | Job |
| --- | --- |
| `data/postthemes.yaml` | The category-to-palette map and the palettes themselves |
| `layouts/_partials/pt-resolve.html` | Picks the palette name for a page |
| `layouts/_partials/extend_head.html` | Emits `--pt-accent-light` / `--pt-accent-dark` into `<head>` |
| `assets/css/extended/post-themes.css` | Applies the accent |

Current palettes: `reflection` (gold), `security` (blue-purple), `build` (teal),
`roundup` (warm neutral), `personal` (muted rose).

### Changing a palette's color

Edit the hexes in `data/postthemes.yaml`. `light` is used against the white
background, `dark` against the dark one. Both get used as link colors, so keep
each at 4.5:1 contrast or better against its background — that is the only
real constraint.

### Pointing a category at a different palette

Add or edit a line under `map:` in `data/postthemes.yaml`. Keys are lowercased
category names; values are palette names:

```yaml
map:
  gaming: personal
```

A post with several categories takes the first one that appears in the map.

### Overriding a single post

Set `postTheme` in frontmatter. It beats the category map:

```yaml
categories: [InfoSec]
postTheme: "reflection"
```

An unrecognized value logs a build warning and falls back to the category.

### Adding a new palette

Add an entry under `palettes:` with `light` and `dark`, then map at least one
category to it. No template or CSS changes needed.

### Archetypes

Alongside `post.md` there are five per-type archetypes that pre-fill the right
category and frontmatter:

`hugo new content --kind reflection post/yyyy-mm-dd-postname.md`

Use `--kind`, and keep `post/` as the path. Hugo also picks archetypes by
section name, so `hugo new reflection/postname.md` finds the same archetype but
files the post under `content/reflection/`, which creates a whole new section
with its own listing page, RSS feed and sitemap entry. It also means the post
is not in section `post`, so it gets no accent and no reading-progress bar.

Valid kinds: `reflection`, `security`, `build`, `roundup`, `personal`. The
`roundup` kind sets up a Lockd & Loaded post, title and URL included.

### Why it is built this way

PaperMod is a submodule, so nothing here touches `themes/`. The two hooks used
are stubs PaperMod ships to be overridden: `extend_head.html` and
`assets/css/extended/*.css`. `git submodule update --remote --merge` stays a
clean fast-forward.

Every rule in `post-themes.css` reads the accent through a `var()` fallback
whose value is the neutral the theme already uses, so pages with no accent —
the home page, `/about`, tag listings — render exactly as they did before.
That is also why there is no body class or `data-` attribute: adding one would
mean shadowing the theme's `baseof.html`.

The tradeoff is that the CSS targets PaperMod's class names. If a theme update
renames one, that rule quietly stops matching and the accent disappears from
that element. Nothing errors. After updating the theme, load a post and check
that links are still colored.

Two things deliberately left alone: code-block colors, which Chroma writes as
inline styles that no CSS variable can reach (changing that means setting
`markup.highlight.noClasses: false` in `config.yml`, which restyles every post
at once), and the `faith` variant of the `callout` shortcode, which still
carries its own hardcoded colors.
