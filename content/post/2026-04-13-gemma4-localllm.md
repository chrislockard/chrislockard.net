---
title: "Gemma4 LocalLLM Resource Usage"
date: "2026-04-13T18:00:00-05:00"
url: "posts/gemma4-localllm-resource-usage"
categories:
- ai
tags:
  - ai
  - localllm
  - gemma
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

For the past few months, I've been using [Zed][1] because its coding assistant
and AI features fit better than other editors'. I've been
using Zed's built-in Claude agent to help me write code for toy programs,
generate blog post boilerplate, and review blog posts to ensure I'm completing
my ideas.

I've [been using][2] a Mac with 40 GPU cores, 48GB Unified RAM, and 546 GB/s
memory bandwidth and have been toying with models to find the most capable model
per GB of memory. I try to keep my used swap at 0 as a self-imposed constraint,
so I am interested in finding the model that can live within 5-20GB or so.

[Last week, Google DeepMind released Gemma4.][3] Ollama [gained support][4] for
it shortly afterward and I've been experimenting with it. Here are my findings.

## Decent Edge AI for Writing and Light Coding in a Moderate Footprint

I have three soft requirements that would make me switch to an on-device LLM
over Claude for most tasks.

Gemma4:e4b is the first model that fulfills my requirements:

  - ✅ Smart enough to be helpful (most of the time)
  - ✅ Fast enough to be useful
  - ✅ Can live alongside the rest of my day-to-day apps without bogging down
    system resources (especially RAM)
    
In this workflow, Gemma4 has been exceptionally performant. ~I haven't had to
debug tool calling at all (the same cannot be said for the Mistral and OpenAI
models I've tried) and~ As I was finalizing this article, I encountered issues
with Gemma4:e4b calling tools and/or following instructions in Zed. The model
thinks it has made changes to files when it actually has not, and I receive no
prompt from Zed to make file changes.

### gemma4:e4b Configuration

With this configuration, I see a resident ~10.76 - 10.87 GB of memory consumed
at all times. During inference, activity monitor memory pressure increases by
13% and system performance remains exceptional.

#### Ollama

```
ollama show gemma4:e4b
  Model
    architecture        gemma4
    parameters          8.0B
    context length      131072
    embedding length    2560
    quantization        Q4_K_M
    requires            0.20.0

  Capabilities
    completion
    vision
    audio
    tools
    thinking

  Parameters
    temperature    1
    top_k          64
    top_p          0.95

  License
    Apache License
    Version 2.0, January 2004
    ...
```

#### Zed

```
{
...
  "language_models": {
    "ollama": {
      "api_url": "http://localhost:11434",
      "auto_discover": false,
      "available_models": [
       {
          "name": "gemma4:e4",
          "display_name": "Gemma 4 e4b (local)",
          "max_tokens": 32768,
          "supports_tools": true,
          "supports_images": true,
          "supports_thinking": true,
        },
      ],
    },
  }
...
}
```

## Twice the footprint, ~Twice the capability

`gemma4:e4b` will fit the most comfortably in my system's resource footprint, so
I expect it to be my go-to. 

That said, `gemma4:26b` feels more capable. I don't have a reliable model
benchmark, so I default to answering the question "did this do what I wanted? If
so, how well or how poorly?"

Stepping up to `gemma4:26b` feels like a noticeable improvement in performance.
It comes with twice the memory footprint and longer loading/unloading times in
Ollama. 

I've also had a couple experiences where the model gets stuck in thinking mode
and loops on arrays of numbers.

### gemma4:26b Configuration

With this configuration, I see a resident ~19.98 - 20.47 GB of memory consumed at all times. During inference, activity monitor memory pressure increases 33%, but no swap is touched and the system maintains overall high performance.

#### Ollama

```
ollama show gemma4:26b
  Model
    architecture        gemma4
    context length      262144
    embedding length    2816
    parameters          25.8B
    quantization        Q4_K_M
    requires            0.20.0

  Capabilities
    completion
    vision
    tools
    thinking

  Parameters
    temperature    1
    top_k          64
    top_p          0.95

  License
    Apache License
    Version 2.0, January 2004
    ...
```
#### Zed

```
{
...
  "language_models": {
    "ollama": {
      "api_url": "http://localhost:11434",
      "auto_discover": false,
      "available_models": [
       {
          "name": "gemma4:26b",
          "display_name": "Gemma 4 26B (local)",
          "max_tokens": 65536,
          "supports_tools": true,
          "supports_images": true,
          "supports_thinking": true,
        },
      ],
    },
  }
...
}
```

Exciting times for LocalLLM!

[1]: https://zed.dev/
[2]: https://blog.google/innovation-and-ai/technology/developers-tools/gemma-4/
[3]: {{% relref "/post/2025-08-15-ollama-vs-lmstudio.md" %}}
[4]: https://ollama.com/library/gemma4
