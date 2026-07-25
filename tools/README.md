# tools

Maintenance scripts for this site. Nothing here is built or published by Hugo —
`tools/` is not a content, static, or assets directory.

| File | Purpose |
| --- | --- |
| `normalize-taxonomy.awk` | Rewrite a frontmatter taxonomy block to canonical display names |
| `category-names.tsv` | `slug<TAB>display name` mapping for categories |
| `tag-names.tsv` | `slug<TAB>display name` mapping for tags |
| `count_topics.py` / `.swift` | Pre-existing: count posts per category |
| `count_technical.py` / `.swift` | Pre-existing: count posts in technical categories |

## normalize-taxonomy.awk

```sh
# categories
for f in content/post/*.md; do
  awk -v key=categories -v mapfile=tools/category-names.tsv \
      -f tools/normalize-taxonomy.awk "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done

# tags
for f in content/post/*.md; do
  awk -v key=tags -v mapfile=tools/tag-names.tsv \
      -f tools/normalize-taxonomy.awk "$f" > "$f.tmp" && mv "$f.tmp" "$f"
done
```

Terms are matched on their slug rather than their literal text, so `AI` and `ai`,
or `bug bounty` and `bug-bounty`, resolve to one entry. A value missing from the
mapping is left alone and reported on stderr, so a typo is never silently
rewritten — that is why the draft template's `tag1`/`tag2` survive a run
untouched. Only list items inside the named block are modified, and the script is
idempotent.

## Why it is keyed on slugs

Hugo slugifies taxonomy terms, so casing never reaches the URL: `InfoSec` and
`infosec` both serve from `/categories/infosec/`. A term written with spaces
behaves the same way — `Surveillance Capitalism` resolves to
`/tags/surveillance-capitalism/`. Display names can therefore be corrected
without moving a page.

The flip side is that mixed casing is invisible until it isn't. Hugo merges the
variants into a single term but labels it with whichever spelling it read first,
so the rendered name changes between builds for no apparent reason. That is the
bug this fixes.

Before applying a mapping, confirm it moves no URLs:

```sh
awk -F'\t' '!/^#/{s=tolower($2); gsub(/ +/,"-",s); if (s!=$1) print "moves: "$1}' \
    tools/tag-names.tsv
```

After applying, confirm the output is stable:

```sh
hugo --quiet -d /tmp/b1 && hugo --quiet -d /tmp/b2
diff /tmp/b1/tags/index.html /tmp/b2/tags/index.html
```

## Conventions

Acronyms and product names keep their own casing (`AWS`, `FOSS`, `macOS`, `iOS`,
`InfoSec`, `YubiKey`, `1Password`). Unix command names stay lowercase (`dig`,
`host`, `nslookup`). Run-together terms use CamelCase — `BurpSuite`, `OrgMode`,
`LocalLLM` — rather than gaining a space, so their URLs stay put. Everything else
is Title Case.

The three category merges of 2026-07 (`coding` and `programming` into `Dev`,
`introspection-meditation` into `Reflection`) are the only entries that ever
changed a URL; `static/_redirects` covers them.
