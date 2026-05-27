#!/usr/bin/env python3
import os
import sys
from collections import defaultdict

def frontmatter_categories(content):
    if not content.startswith('---'):
        return []

    frontmatter_lines = []
    past_opening = False
    closed = False

    for line in content.splitlines():
        stripped = line.rstrip('\r')
        if stripped == '---':
            if not past_opening:
                past_opening = True
                continue
            closed = True
            break
        if past_opening:
            frontmatter_lines.append(stripped)

    if not closed:
        return []

    categories = []
    in_block = False

    for line in frontmatter_lines:
        trimmed = line.strip()

        if trimmed.lower().startswith('categories:'):
            value = trimmed[len('categories:'):].strip()

            if value.startswith('[') and value.endswith(']'):
                inner = value[1:-1]
                categories = [
                    item.strip().strip('"\'')
                    for item in inner.split(',')
                    if item.strip()
                ]
                in_block = False
            elif not value:
                in_block = True
            else:
                categories = [value.strip('"\'')]
                in_block = False

        elif in_block:
            if trimmed.startswith('- '):
                val = trimmed[2:].strip().strip('"\'')
                if val:
                    categories.append(val)
            elif trimmed and not trimmed.startswith('#'):
                in_block = False

    return categories


post_dir = 'content/post'

try:
    files = os.listdir(post_dir)
except OSError:
    print(f'Error: cannot read {post_dir}', file=sys.stderr)
    sys.exit(1)

counts = defaultdict(int)

for filename in files:
    if not filename.endswith('.md'):
        continue
    path = os.path.join(post_dir, filename)
    try:
        with open(path, encoding='utf-8') as f:
            content = f.read()
    except OSError:
        continue

    for cat in frontmatter_categories(content):
        key = cat.lower().strip()
        if key:
            counts[key] += 1

for cat, count in sorted(counts.items(), key=lambda x: (-x[1], x[0])):
    print(f'{cat}: {count}')
