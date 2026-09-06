#!/bin/bash
# new-post.sh -- create a draft post and open it in Zed.
#
# Usage:
#   new-post.sh ["post idea / title"] [category]
#
# Both arguments are optional. Anything missing is asked for with a native
# macOS prompt, so this works the same launched from Alfred, a hotkey, or a
# terminal. The "New Post" Alfred workflow (tools/alfred/) calls this script.
#
# What it does: slugifies the idea, writes content/post/YYYY-MM-DD-slug.md with
# the site's frontmatter convention (draft: true, one category, url pinned to
# posts/<slug>), then opens the file in Zed.

set -eu
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/homebrew/bin"

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
POSTDIR="$REPO/content/post"

die() {
  # Surface errors to stderr (terminal) and, when there is a GUI, an alert.
  echo "new-post: $1" >&2
  osascript -e "display alert \"New Post\" message \"$1\" as critical" >/dev/null 2>&1 || true
  exit 1
}

[ -d "$POSTDIR" ] || die "content/post not found under $REPO"

# --- Title -----------------------------------------------------------------
title="${1:-}"
if [ -z "$(printf '%s' "$title" | tr -d '[:space:]')" ]; then
  title="$(osascript -e 'text returned of (display dialog "New post idea:" default answer "" with title "New Post" buttons {"Cancel", "Create"} default button "Create")' 2>/dev/null)" || exit 0
fi
title="$(printf '%s' "$title" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
[ -n "$title" ] || exit 0

# --- Category ------------------------------------------------------------
CATEGORIES="Cyber Technology Reflection Career Other"
category="${2:-}"
if [ -n "$category" ]; then
  want="$(printf '%s' "$category" | tr '[:upper:]' '[:lower:]')"
  category=""
  for c in $CATEGORIES; do
    if [ "$want" = "$(printf '%s' "$c" | tr '[:upper:]' '[:lower:]')" ]; then
      category="$c"
    fi
  done
fi
if [ -z "$category" ]; then
  category="$(osascript \
    -e 'set c to choose from list {"Cyber", "Technology", "Reflection", "Career", "Other"} with title "New Post" with prompt "Category (exactly one):" default items {"Technology"}' \
    -e 'if c is false then return ""' \
    -e 'item 1 of c' 2>/dev/null)" || exit 0
fi
[ -n "$category" ] || exit 0

# --- Slug + filename ---------------------------------------------------
slug="$(printf '%s' "$title" \
  | tr '[:upper:]' '[:lower:]' \
  | iconv -f utf-8 -t ascii//TRANSLIT 2>/dev/null \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//')"
[ -n "$slug" ] || die "could not derive a slug from: $title"

today="$(date +%Y-%m-%d)"
stamp="$(date +%Y-%m-%dT%H:%M:%S%z | sed -E 's/([0-9]{2})$/:\1/')"

path="$POSTDIR/$today-$slug.md"
n=2
while [ -e "$path" ]; do
  path="$POSTDIR/$today-$slug-$n.md"
  n=$((n + 1))
done

# --- Frontmatter ------------------------------------------------------
esc_title="$(printf '%s' "$title" | sed 's/"/\\"/g')"
cat > "$path" <<EOF
---
title: "$esc_title"
date: "$stamp"
url: "posts/$slug"
categories:
- $category
tags:
- tag1
- tag2
type: post
author: ""
postTheme: "" # accent comes from the category; set to override
showToc: false
TocOpen: false
draft: true
hidemeta: false
comments: false
description: ""
disableHLJS: true # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: false
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "" # image path/url
    alt: "" # alt text
    caption: "" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/chrislockard/chrislockard.net"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

EOF

# --- Open in Zed -----------------------------------------------------
open -a Zed "$path" 2>/dev/null || zed "$path" 2>/dev/null || true

echo "$path"
