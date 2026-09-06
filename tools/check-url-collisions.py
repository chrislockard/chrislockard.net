#!/usr/bin/env python3
# check-url-collisions.py -- find posts that pin the same `url:` frontmatter.
#
#   tools/check-url-collisions.py [--published-only] [content-dir ...]
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

import os
import sys
from collections import defaultdict

DEFAULT_DIRS = ['content']


def frontmatter_url(content):
    """Return the raw `url:` value from a file's YAML frontmatter, or None."""
    if not content.startswith('---'):
        return None

    past_opening = False
    for line in content.splitlines():
        stripped = line.rstrip('\r')
        if stripped == '---':
            if not past_opening:
                past_opening = True
                continue
            return None  # closed frontmatter without a url
        if not past_opening:
            continue

        trimmed = stripped.strip()
        if trimmed.lower().startswith('url:'):
            value = trimmed[len('url:'):].strip()
            # strip a trailing "# comment"
            if value and value[0] not in '"\'' and '#' in value:
                value = value.split('#', 1)[0].strip()
            return value.strip('"\'').strip()

    return None


def is_draft(content):
    """True if the frontmatter sets `draft: true`."""
    if not content.startswith('---'):
        return False
    past_opening = False
    for line in content.splitlines():
        stripped = line.rstrip('\r')
        if stripped == '---':
            if not past_opening:
                past_opening = True
                continue
            return False
        if not past_opening:
            continue
        trimmed = stripped.strip().lower()
        if trimmed.startswith('draft:'):
            return trimmed[len('draft:'):].strip().startswith('true')
    return False


def normalise(url):
    """Collapse url spellings Hugo treats as identical to one canonical form."""
    return url.strip().strip('/')


def md_files(roots):
    for root in roots:
        for dirpath, _dirs, names in os.walk(root):
            for name in names:
                if name.endswith('.md'):
                    yield os.path.join(dirpath, name)


def main(argv):
    args = argv[1:]
    published_only = '--published-only' in args
    roots = [a for a in args if not a.startswith('--')] or DEFAULT_DIRS
    for root in roots:
        if not os.path.isdir(root):
            print(f'error: not a directory: {root}', file=sys.stderr)
            return 2

    # normalised url -> list of (raw url, path)
    seen = defaultdict(list)
    for path in md_files(roots):
        try:
            with open(path, encoding='utf-8') as f:
                content = f.read()
        except OSError as e:
            print(f'warning: cannot read {path}: {e}', file=sys.stderr)
            continue

        if published_only and is_draft(content):
            continue

        raw = frontmatter_url(content)
        if raw:
            seen[normalise(raw)].append((raw, path))

    collisions = {k: v for k, v in seen.items() if len(v) > 1}

    if collisions:
        print(f'{len(collisions)} url collision(s):\n')
        for key in sorted(collisions):
            print(f'  /{key}')
            for raw, path in sorted(collisions[key], key=lambda x: x[1]):
                print(f'    {path}    (url: {raw!r})')
            print()

    # Case-only near-misses: not a hard error (Hugo keeps them distinct) but
    # Cloudflare Pages serves case-insensitively, so flag them.
    lowered = defaultdict(set)
    for key in seen:
        lowered[key.lower()].add(key)
    case_dupes = {k: v for k, v in lowered.items()
                  if len(v) > 1 and k not in collisions}
    if case_dupes:
        print('case-insensitive near-collisions (distinct to Hugo, '
              'ambiguous on Cloudflare Pages):\n')
        for _lc, variants in sorted(case_dupes.items()):
            for variant in sorted(variants):
                for raw, path in sorted(seen[variant], key=lambda x: x[1]):
                    print(f'    {path}    (url: {raw!r})')
            print()

    if collisions:
        return 1

    total = sum(len(v) for v in seen.values())
    print(f'ok: {total} pinned urls, all unique')
    return 0


if __name__ == '__main__':
    sys.exit(main(sys.argv))
