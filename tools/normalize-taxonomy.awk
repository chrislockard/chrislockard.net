# Rewrite a YAML frontmatter taxonomy block to canonical display names.
#
#   awk -v key=tags -v mapfile=tools/tag-names.tsv \
#       -f tools/normalize-taxonomy.awk post.md
#
# Terms are matched on their *slug*, not their literal text, so existing
# variants ("AI", "ai") and spacing variants ("bug bounty", "bug-bounty") all
# resolve to the same mapping entry. Values not present in the mapping are left
# untouched and reported on stderr, so a typo is never silently rewritten.
#
# Only list items inside the named block are touched. The frontmatter fence
# also begins with '-', so it is matched before the list rule.

function slugify(v,   s) {
    s = tolower(v)
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", s)
    gsub(/[[:space:]]+/, "-", s)
    return s
}

BEGIN {
    if (key == "" || mapfile == "") {
        print "usage: -v key=<frontmatter key> -v mapfile=<slug\\tname tsv>" > "/dev/stderr"
        exit 2
    }
    while ((getline line < mapfile) > 0) {
        if (line ~ /^[[:space:]]*#/ || line ~ /^[[:space:]]*$/) continue
        split(line, f, "\t")
        map[f[1]] = f[2]
    }
    close(mapfile)
}

FNR == 1 { inblock = 0 }

/^---[[:space:]]*$/ { inblock = 0; print; next }

$0 ~ ("^" key ":[[:space:]]*$") { inblock = 1; print; next }

inblock && /^[[:space:]]*-[[:space:]]*/ {
    v = $0
    sub(/^[[:space:]]*-[[:space:]]*/, "", v)
    if (v == "") { print; next }

    q = ""
    if (v ~ /^".*"$/) { q = "\""; gsub(/^"|"$/, "", v) }

    slug = slugify(v)
    if (slug in map) {
        indent = $0
        sub(/-[[:space:]]*.*$/, "", indent)
        print indent "- " q map[slug] q
    } else {
        unknown[v] = 1
        print
    }
    next
}

/^[A-Za-z_]/ { inblock = 0 }

{ print }

END {
    for (u in unknown) print "UNMAPPED: " u > "/dev/stderr"
}
