# layouts

Most site customizations live in official Hugo/PaperMod extension points that
never collide with a theme update: `layouts/_partials/extend_head.html`,
`layouts/_partials/extend_footer.html`, `layouts/shortcodes/`,
`assets/css/extended/`. See `data/postthemes.yaml` for how the post-accent
system uses these.

`layouts/rss.xml` is different: it's a **full override** of
`themes/PaperMod/layouts/rss.xml`. Hugo's template lookup prefers a
project-root layout over the theme's own, but there's no partial-override
mechanism for a single output format -- the whole file is replaced, not
patched. This one adds two things the theme doesn't have:

- an `<?xml-stylesheet?>` PI pointing at `static/rss/style.xsl`, so `/index.xml`
  renders as a readable page in a browser instead of raw XML (feed readers
  parse the RSS directly and never apply it)
- a per-item `<category>` element, and `.Summary | plainify` instead of
  `.Summary | html` for the fallback description, so a post with no
  frontmatter `description` and an early shortcode doesn't leak raw
  `<iframe>`/`<div>` markup into every reader's preview

**On a PaperMod update:** diff `themes/PaperMod/layouts/rss.xml` against the
version this was forked from (pinned at commit `d376885` in a comment at the
top of `layouts/rss.xml`) and reapply the same two changes to any upstream
changes, rather than assuming the override still matches.
