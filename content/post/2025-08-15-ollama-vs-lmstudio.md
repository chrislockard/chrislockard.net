---
title: "Ollama vs LM Studio on macOS"
date: "2025-08-15T11:48:15-04:00"
url: "posts/ollama-vs-lmstudio-macos"
categories:
- AI
tags:
- ollama
- lmstudio
- macOS
author: "Chris"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "On a Mac, these each have their own strengths and weaknesses."
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
---
If you're a Mac user interested in running AI models locally, you've probably
faced the challenge of balancing model performance with hardware constraints. In
this post, I share what I've learned since January, exploring AI runtimes like
[Ollama](https://ollama.com) and [LM Studio](https://lmstudio.ai/) on a 48GB
Macbook Pro, highlighting their strengths, weaknesses, and how they handle
memory-intensive models.

## Within Constraints

Since January, I've been using my new Macbook to explore the world of local, or
on-device generative AI. I thought 48GB of RAM would be enough, so I settled for
the most expensive Macbook I could get my hands on in-store (I was impatient and
didn't want to wait up to three weeks for a 64GB model to arrive)[^1]

Since then, I've been paying for this decision; literally in that my final
installment was just paid, and figuratively in that I'm constantly concerned
with the size of the models I can run locally.

### The RAM Struggle

It's an odd thing to be concerned about as someone who has spent his life in
tech: I'm used to optimizing for gaming or compute performance. But now, the
main blocker I face is whether I have enough unified memory to run the model! (I
suppose performance is still a concern. After all, I could load a larger model,
but if it consumes all of my RAM and constantly swaps degrading system
performance, it won't be useful)

This RAM constraint has been the driving force behind my exploration of
different AI runtimes, and AI in general. My goal is to find the best, most
capable model that will run on this laptop without causing it to swap and give
other apps breathing room to run.

## Ollama

I started with [Ollama](https://ollama.com/) because of its popularity and ease
of use. Most of the tools supporting my use cases had support for Ollama
built-in. Ollama is my favorite user experience for interacting with AI models:
just a simple `ollama run <model>` command and I'm presented with a clean
interface to begin chatting with the model. By default, I can access the model
locally on port 11434 and [its popularity](https://github.com/ollama/ollama)
means it's widely supported by my tools.

Over time, I began to wonder about Ollama:

* Was it optimized for my Mac?
* Was I limited in my model selection based on Ollama's implementation?
* Could I be running larger models with better performance?

These questions led me to explore other runtimes, and I soon found [LM
Studio](https://lmstudio.ai/).

## LM Studio

LM Studio is, as its name implies, more comprehensive than Ollama. In addition
to a minimal CLI, LM Studio offers a GUI with a chat interface, built-in model
discovery and download, and many other options.

I was initially turned off, as I prefer the simplicity of Ollama's CLI, but it
was LM Studio's support for MLX models that drew me in.
[MLX](https://opensource.apple.com/projects/mlx/) is still a mystery to me (as
are most things in the AI space); I understand it is a framework developed by
Apple for LLMs to more effectively use Apple Silicon and its unified memory, but
I don't understand exactly how it works.

I do know that MLX models run via LM Studio are generally more performant and,
importantly to me, more memory efficient than models running on Ollama. [This
Reddit thread by
purealgo](https://www.reddit.com/r/ollama/comments/1j0by7r/tested_local_llms_on_a_maxed_out_m4_macbook_pro/)
showcases the performance gains of running supported models on MLX instead of
GGUF.

## Resource Comparison

The numbers that interested me, however, were the memory usage numbers. LM
Studio's support for MLX models meant that I could run larger models with more
capability than I could with Ollama. Alternatively, I could run the same models
and have more memory available for other applications. This is a big deal for
me: as I mentioned, my goal is to run the most capable model locally and GPU RAM
seems to be the limiting factor.

For instance, I have been running the Qwen3:8B model on Ollama because it has
been performant, accurate enough for my use, and decent at running tools. I'm
also very interested in the recently released gpt-oss models from OpenAI.

These metrics show memory usage (rsize, lower is better), context length (how
much the model can process), and speed (time to generate a short story). MLX
models on LM Studio generally use less memory and run faster.

### Qwen3:8B

|                            | Ollama | LM Studio |
| ---------------------------| -------| --------- |
| Memory (rsize)             | 9.5 GB | 4.89 GB   |
| Context Length             | 40960  | 40960     |
| Quantization               | Q4_K_M | 4-bit     |
| Format                     | GGUF   | MLX       |
| "Tell me a story" duration | 13.2s  | 11.2s     |

### gpt-oss:20B

|                            | Ollama | LM Studio |
| ---------------------------| -------| --------- |
| Memory (rsize)             | 13.9 GB| 11.72 GB  |
| Context Length             | 131072 | 131072    |
| Quantization               | MXFP4  | 4-bit     |
| Format                     | GGUF   | MLX       |
| "Tell me a story" duration | 32s    | 19.7s     |

{{< figure
  src="/images/2025/8-15-1.png"
  alt="Memory comparison chart, generated by Grok"
  align=center
  caption="Memory usage comparison chart, generated by Grok"
>}}
>
## More Than Just Numbers

Of course, there's more to the story than just the numbers. Ollama is widely
used and supported by many tools. It has a simple CLI and a clean interface.
It's open source with a large community of users and contributors. I feel like I
can trust Ollama.

LM Studio is closed source which, all things being equal, will be a deterrent
for me. I've been monitoring traffic with both apps using [Little
Snitch](https://obdev.at/products/littlesnitch/index.html) and I haven't seen
any suspicious connections, but for privacy-conscious users like myself, this is
a big drawback.

LM Studio is also made by a small company that doesn't disclose on [their
site](https://lmstudio.ai/work) how much it costs for business use. For personal
use, it's gratis. I've been around long enough to know when I'm the product and
when I'm the customer. I don't like being the product, so I generally don't want
to use LM Studio. That said, LM Studio's performance with MLX models is hard to
ignore.

## Conclusion

I'm glad to have an abundance of AI runtimes to choose from on my Mac. In this
post, I've only compared Ollama and LM Studio, but there are many others.

Ollama and LM Studio are the two that I use most often, and I find myself
bouncing between them depending on the model I want to run and why I want to
run it.

* Ollama is user-friendly, widely supported, and open source, but less
memory-efficient for larger models.
* LM Studio excels with MLX models, saving RAM and improving performance, but I
  have trust and privacy concerns with it.
* For Mac users, MLX models are a Big Deal, offering significant memory and
performance improvements.

### The Best Is Yet to Come?

My desire would be for Ollama to support MLX models so that I gain all of its
benefits (open source, trustworthy, wide support, ease of use, simple interface)
*and* the ability to use more memory-efficient and performant models.

[MLX Support is coming](https://github.com/ollama/ollama/pull/9118) to Ollama,
so hopefully I'll soon be able to have my cake and eat it too. 🤞🏻

[^1]: To anyone reading this thinking "wow, what a privileged jerk" let me share
    that *never* in my life have I spent this much on a computer. And never have
I spent so much on a computer that almost immediately felt *obsolete*. The first
AI workload I got up and running on this involved running an un-quantified
[Flux](https://huggingface.co/black-forest-labs/FLUX.1-dev) model and weeping as
I watched my RAM usage max out, my swap space fill up, and my Mac slow
noticeably. It really stings to be uneducated. I've learned a lot about the
limitations of my hardware since January and I sleep at night telling myself
that I needed to learn this expensive lesson sometime. Also, I still think what
Apple charges for more memory and storage is borderline criminal.
