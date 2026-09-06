#!/bin/bash
# check-url-collisions.sh -- find posts that pin the same `url:` frontmatter.
#
#   tools/check-url-collisions.sh [--published-only] [content-dir ...]
#
# Every post pins `url:` (see CLAUDE.md: "Always set the `url` field ... to
# `posts/slug-name`"). Two posts with the same pinned url is a silent bug --
# Hugo builds whichever it renders last and drops the other, with no error.
# This walks the content tree, normalises each url the way Hugo would resolve
# it (leading/trailing slashes don't matter), and reports any url claimed by
# more than one file.
#
# By default drafts are included, so a placeholder url copied from the
# archetype (posts/post-url) is caught before two of them get published.
# Pass --published-only to check just what a production build would emit.
#
# Exit status: 0 = every url is unique, 1 = at least one collision, 2 = bad
# invocation / unreadable tree. Suitable as a pre-commit or CI gate.

set -eu

published_only=0
dirs=""
for arg in "$@"; do
  case "$arg" in
    --published-only) published_only=1 ;;
    -h|--help)
      grep -E '^#( |$)' "$0" | sed -e 's/^# \{0,1\}//'
      exit 0
      ;;
    --*)
      echo "check-url-collisions: unknown option: $arg" >&2
      exit 2
      ;;
    *) dirs="$dirs $arg" ;;
  esac
done
[ -n "$dirs" ] || dirs="content"

for d in $dirs; do
  if [ ! -d "$d" ]; then
    echo "check-url-collisions: not a directory: $d" >&2
    exit 2
  fi
done

records="$(mktemp)"
trap 'rm -f "$records" "$records.keys" "$records.lk"' EXIT

# Print the frontmatter body: the lines between the opening `---` and the next
# `---`. Nothing if the file does not open with a fence.
frontmatter() {
  awk '
    NR == 1 { if ($0 !~ /^---[[:space:]]*$/) exit; next }
    /^---[[:space:]]*$/ { exit }
    { print }
  ' "$1"
}

trim() { sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'; }

# find on a word-split list is deliberate: paths under content/ have no spaces.
find $dirs -type f -name '*.md' -print | while IFS= read -r file; do
  fm="$(frontmatter "$file")"
  [ -n "$fm" ] || continue

  if [ "$published_only" -eq 1 ]; then
    if printf '%s\n' "$fm" | grep -qiE '^[[:space:]]*draft:[[:space:]]*true([[:space:]]|$)'; then
      continue
    fi
  fi

  url_line="$(printf '%s\n' "$fm" | grep -iE '^[[:space:]]*url:' | head -n 1 || true)"
  [ -n "$url_line" ] || continue

  raw="$(printf '%s' "${url_line#*:}" | trim)"
  case "$raw" in
    '"'*|"'"*) : ;;                               # quoted: leave inner text
    *"#"*) raw="$(printf '%s' "${raw%%#*}" | trim)" ;;  # strip trailing comment
  esac
  raw="${raw%\"}"; raw="${raw#\"}"
  raw="${raw%\'}"; raw="${raw#\'}"
  [ -n "$raw" ] || continue

  norm="${raw#/}"; norm="${norm%/}"

  printf '%s\t%s\t%s\n' "$norm" "$raw" "$file" >> "$records"
done

status=0

# --- Hard collisions: one normalised url in two or more files ---------------
collisions="$(cut -f1 "$records" | sort | uniq -d || true)"
if [ -n "$collisions" ]; then
  n="$(printf '%s\n' "$collisions" | grep -c . || true)"
  echo "$n url collision(s):"
  echo
  printf '%s\n' "$collisions" | while IFS= read -r key; do
    [ -n "$key" ] || continue
    echo "  /$key"
    awk -F'\t' -v k="$key" '$1 == k { printf "    %s    (url: %s)\n", $3, $2 }' \
      "$records" | sort
    echo
  done
  status=1
fi

# --- Case-only near-collisions (Hugo keeps them distinct; Cloudflare does not)
cut -f1 "$records" | sort -u > "$records.keys"
: > "$records.lk"
while IFS= read -r key; do
  [ -n "$key" ] || continue
  lk="$(printf '%s' "$key" | tr '[:upper:]' '[:lower:]')"
  printf '%s\t%s\n' "$lk" "$key" >> "$records.lk"
done < "$records.keys"

near="$(cut -f1 "$records.lk" | sort | uniq -d || true)"
if [ -n "$near" ] && [ -n "$collisions" ]; then
  # a lowercased key that is itself a hard collision is already reported
  hard_lc="$(printf '%s\n' "$collisions" | tr '[:upper:]' '[:lower:]' | sort -u)"
  near="$(comm -23 <(printf '%s\n' "$near" | sort -u) <(printf '%s\n' "$hard_lc") || true)"
fi

if [ -n "$near" ]; then
  echo "case-insensitive near-collisions (distinct to Hugo, ambiguous on Cloudflare Pages):"
  echo
  printf '%s\n' "$near" | while IFS= read -r lk; do
    [ -n "$lk" ] || continue
    awk -F'\t' -v lk="$lk" 'tolower($1) == lk { print $2 }' "$records.lk" \
      | sort | while IFS= read -r variant; do
        awk -F'\t' -v k="$variant" '$1 == k { printf "    %s    (url: %s)\n", $3, $2 }' \
          "$records" | sort
      done
    echo
  done
fi

if [ "$status" -eq 0 ]; then
  total="$(grep -c . "$records" 2>/dev/null || true)"
  echo "ok: ${total:-0} pinned urls, all unique"
fi

exit "$status"
