---
title: "Lockd & Loaded 2026-04-24"
date: "2026-04-24T10:46:55-04:00"
url: "posts/lockd-loaded-2026-04-24"
categories:
- Content
tags:
- links
author: "Chris"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Desc Text."
disableHLJS: true # to disable highlightjs
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

This week, I continued my LocalLLM experimentation.

- [Jan.ai][jan] - Jan.ai is another localLLM inference provider. I don't like
  that I can't find much information about the folks who produce it, but I've
  watched the app's traffic, and the only possibly suspicious domain it's
  connected to is `apps.jan.ai`.  Jan is compelling because it exposes it's llama.cpp backend and also offers an MLX backend for macOS users.

- [Llama.cpp][llama] - Llama.cpp is the project that started the entire LocalLLM
  phenomenon. I haven't played with it yet because it's not as approachable as
  Jan, Ollama, or LM Studio, but it's the progenitor of these so I expect it to
  provide more functionality than these projects I'm familiar with. 

- [Unsloth - Huggingface][unsloth] - I just said Llama.cpp isn't as approachable
  as other projects. One reason for this is that you must find and download
  .gguf models from Huggingface first. Unsloth is the Huggingface repo that
  contains many different quantized model versions and has a large following so
  newer models are available here shortly after release.

- [The Creative Software Industry has Declared War on Adobe][verge] - This
  caught my eye because for as long as I've used computers, Adobe was *the*
  creative software company. All others competing in this space were nipping at
  Adobe's heels, but renerative AI could enable regicide.

That's all for this week! God bless.

[jan]: https://www.jan.ai/
[llama]: https://github.com/ggml-org/llama.cpp
[unsloth]: https://huggingface.co/unsloth
[verge]: https://www.theverge.com/tech/913765/adobe-rivals-free-creative-software-app-updates
