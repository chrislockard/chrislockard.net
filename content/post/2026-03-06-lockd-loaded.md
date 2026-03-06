---
title: "Lockd & Loaded (March 6 2026)"
date: "2026-03-06T08:00:00-05:00"
url: "posts/lockd-loaded-2026-03-06"
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

- [Partnering with Mozilla to improve Firefox’s security \ Anthropic][1] -
  Inspiring writeup about how Anthropic and Mozilla leveraged Claude Opus 4.6 to
  identify and fix several dozen moderate-to-severe security flaws. The key
  takeaway for me from this article is the following:

> Opus 4.6 is currently far better at identifying and fixing vulnerabilities
> than at exploiting them. This gives defenders the advantage. And with the
> recent release of Claude Code Security in limited research preview, we’re
> bringing vulnerability-discovery (and patching) capabilities directly to
> customers and open-source maintainers.

Defenders have a short window before Frontier Models will catch up on the
exploitation side and then I think we're going to see *many* new exploits
released into the wild.

- [Where Things Stand With the Department of War][2] - There's an ongoing
  dispute between Anthropic and the US Department of War. From the sidelines, it
  appears there have been a lot of whipsawing and posturing, but it does not
  seem as though the DoW's designation of Anthropic as a "supply chain risk" was
  warranted. 

Predictably, OpenAI swooped in and claimed the DoW contract as the Anthropic/DoW
disagreement was unfolding which, I think, says a lot.
- [ChatGPT 5.4 Release][3] - Initial observations on HackerNews indicate this is
  a substantial improvement over 5.3. Opus 4.6 and 5.4 seem to be neck-and-neck.
  Other factors aside, this is a good place to be as a customer.
- [Critical OpenClaw Vulnerability Exposes AI Agent Risks][4] - I love the
  *idea* of OpenClaw, but until there are more safeguards in place, I cannot in
  good consience give unmitigated local and/or remote code execution to an
  agent.
- [LocalAI.io][5] - A promising project. I'm intensely interested in running localLLMs, but I haven't managed to create a useful pipeline yet.

That's all for this week! God bless.

[1]: https://www.anthropic.com/news/mozilla-firefox-security 
[2]: https://www.anthropic.com/news/where-stand-department-war 
[3]: https://openai.com/index/gpt-5-4-thinking-system-card/ 
[4]: https://www.darkreading.com/application-security/critical-openclaw-vulnerability-ai-agent-risks
[5]: https://localai.io/
