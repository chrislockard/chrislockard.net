---
title: "Notes on Setting up Open WebUI with Ollama"
date: "2026-03-04T12:00:00-04:00"
url: "posts/notes-openwebui-ollama"
categories:
- AI
tags:
- ollama
- macOS
author: "Chris"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "I'm documenting this step along the path to Local LLMs."
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

Some time ago, I wrote about [Local LLMs]({{% relref
"/post/2025-08-15-ollama-vs-lmstudio.md" %}}) and specific pain points (like
weeping as memory and swap usage shoot through the roof).

One of these pain points is not having a single frontend from which I manage and
interact with models. This approach may be slightly antiquated in the age of
[OpenClaw](https://openclaw.ai/), but as [OpenClaw security issues
mount](https://www.darkreading.com/application-security/critical-openclaw-vulnerability-ai-agent-risks),
I'm convinced it would be best to start with the basics before moving onto
automation that exposes my device to Remote Code Execution (RCE).

## The Backend

Since my [previous post]({{% relref
"/post/2025-08-15-ollama-vs-lmstudio.md" %}}) on [Ollama](https://ollama.com/) vs [LM
Studio](https://lmstudio.ai/), I've stuck with Ollama, so that will continue to
be my backend. I'm eagerly watching
[#13648](https://github.com/ollama/ollama/pull/13648) and
[#1730](https://github.com/ollama/ollama/issues/1730) to learn when Ollama will
support MLX models. Once it does that, it has everything I need to feel
confident my laptop's resources are most easily and efficiently utilized.

## The Frontend

All signs point to [Open WebUI](https://github.com/open-webui/open-webui) as *the* project to use, so that's where I'm starting.

### Installation

Open WebUI has a Docker container, but I don't want that overhead, so I'll rely
on the Python installation. Whenever Python enters the room I'm afraid of
breakage, so I rely on the excellent [mise](https://github.com/jdx/mise)
utility.

#### Install Python 3.11 with Mise

Open WebUI's documentation suggests using Python 3.11, so I'll do that with:

`mise use --global python@3.11`

After approving some alerts in
[LittleSnitch](https://obdev.at/products/littlesnitch/index.html), I verify the
installation with:

```fish
python --version
Python 3.11.15
```

#### Create Open WebUI Environment

This will create a workfolder for Open WebUI and install an isolated Python environment inside:

```fish
mkdir -p Applications/Open\ WebUI
cd Applications/Open\ WebUI
python -m venv venv
source venv/bin/activate.fish
```

#### Install Open WebUI

Simple as `pip install open-webui`

### Launch Open WebUI

From my naked environment, this becomes:

```fish
cd Applications/Open\ WebUI
source venv/bin/activate.fish
open-webui serve
```

#### First Time

After a few moments, Open WebUI will launch and make connections out to the
following domians:

```
huggingface.co
cas-server.xethub.hf.co
transfer.xethub.hf.co
```

And around 1GB will be downloaded in the background. At this point,
`~/Applications/Open WebUI` is ~2.3GB.

Python takes around a minute on my M4 Max to settle down and start the server on
`http://localhost:8080`.

#### Registration

Upon first login, Open WebUI prompts for a name, email address, and password to
create an admin account. The UI ensures that this information never leaves the
device.

### Running Open WebUI

After logging in, Open WebUI makes a call to the following: 

```txt
api.openapi.com
api.github.com
```

And then I'm off to the races! The UI loads with my most recently used model from Ollama with a chat interface closely resembling that of Claude or ChatGPT.

#### Automating for Posterity

I'm going to forget how I ran this when I wake up tomorrow, so the following
Fish function should take care of future runs:

```fish
# ~/.config/fish/functions/webui.fish
function webui
    source ~/Applications/Open\ WebUI/venv/bin/activate.fish
    open-webui serve
end
```

I'm going to explore Open WebUI as a possible replacement for ChatGPT in Firefox's AI sidebar and Brave's Leo. More to come.
