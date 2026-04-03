---
title: "Lockd & Loaded (April 3 2026)"
date: "2026-04-03T08:00:00-05:00"
url: "posts/lockd-loaded-2026-04-03"
categories:
- Content
tags:
  - ai
  - infosec
author: "Chris"
showToc: false
TocOpen: false
draft: false
hidemeta: true
comments: false
disableHLJS: true
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
---

- [Claude Code Source Code Leak][1] - Reporting indicates the Claude Code source
  was leaked via a .map file pushed to the `npm` registry. As a Security
  Operations guy, I am simultaneously surprised and unsurprised by this:
  - On one hand, I would expect a company with the resources at Anthropic's
    disposal to have world-class processes and monitoring in place to prevent
    such disclosure.
  - On the other, even at a company operating at Anthropic's scale, I imagine
    the information security team may not be involved with the activities of all
    teams.

- [Ollama gains MLX Support][2] - This is in preview, and seems to only work for
  one model according to the blog post, but I'm beyond excited. [I wrote last
  Summer]({{% relref "2025-08-15-ollama-vs-lmstudio.md" %}}) about
  Ollama and LM Studio. More tools have released since then, including [omlx][3]
  that are compelling alternatives to Ollama. I'm glad to see them catching up
  in this regard.

[Happy Easter!][4] God bless.

[1]: https://cybersecuritynews.com/claude-code-source-code-leaked/
[2]: https://ollama.com/blog/mlx
[3]: https://github.com/jundot/omlx
[4]: https://www.catholic365.com/article/48845/why-easter-is-everything-the-heart-of-every-catholic.html
