---
title: "Siri AI Is Here! Now What?"
date: "2026-09-15T13:45:00-04:00"
url: "posts/siri-ai-is-here-now-what"
categories:
- Technology
tags:
- AI
- macOS
- Alfred
type: post
author: ""
postTheme: "" # accent comes from the category; set to override
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "My initial experience with Siri AI after eagerly awaiting it."
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
    image: "images/2026/9-15-1.jpg" # image path/url
    alt: "Glowing concentric circles representing AI"
    caption: "Siri AI's Rendition of Siri AI"
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

This morning when I awoke, my iPhone informed me that the "New Siri" was ready
for me. I was relieved, as yesterday when I eagerly installed iOS and macOS 27,
I expected the feature to be available immediately. Instead, I was met with the
[waitlist][waitlist].

Frustrated, I went to bed having only marginally explored what my devices were
capable of because the marquee feature was unavailable.

Now that Siri AI is available, I'm eager to see how it complements or replaces
the [workflows][gemma4] I've [built][agenticos] up in the age of AI.

## macOS

As discussed post-WWDC, Siri AI merges with Spotlight to become the singular
interface for querying the Mac. I've long been an [Alfred][alfred] user, but I
give Spotlight a chance periodically because Apple prohibits third-party tools
from reading Mail Spotlight data and that's often the one place I need to
search.

The improvements discussed during the [WWDC keynote][wwdc] shine through: the
Siri AI window invokes nearly instantly, like Alfred does. The chatbot-like
interface is suitable, though I am displeased to learn that I can't scroll text
output or copy text from the pop-up Siri AI view. For that, I need to open the
new dedicated Siri.app. This is disappointing because I *have* to reach for the
mouse to action text versus Alfred where everything is controllable by the
keyboard. Perhaps I'm holding it wrong and a solution will present itself, but
for now, the promise of a baked-in keyboard-driven experience remains elusive.
Still, I appreciate that a private chatbot is a simple ⌥-space away (I've
remapped ⌘-space to invoke Alfred).

Confusingly, I'm not sure whether all Siri AI functionality is enabled. System
Settings no longer says I'm waitlisted to use Siri AI, and when I invoke it, I
get the new Siri AI window that *appears* to contain Siri AI functionality.
However, this curious message appears in System Settings > Siri:

{{< picture src="/images/2026/9-15-2.jpg" caption="Schrödinger's Siri" align="center" >}}

So, it's possible not all Siri AI functionality has been enabled on my device.
I'm not sure what *isn't* available.

## So What?

I've eagerly anticipated Siri AI, and in the eight hours I've had access to it,
I haven't identified its killer feature.

My Siri AI daydreams revolved around improving [task and knowledge
management][taskmgmt], but realizing them isn't immediately obvious. My wife's
Pixel device has a daily summary feature that I tried to replicate with Siri AI.
Though not quite as straightforward, I've gotten decent results with two
separate Siri AI requests:

> *What emails from today do I need to pay attention to?*

This surfaced three messages across my personal Gmail, my shared family Gmail,
and my Fastmail account that were, indeed, the messages I was most concerned
with today. This is the most useful thing Siri AI has done for me thus far.

> *Prepare an executive summary for my day*

This showed me my calendar and reminders for the day, but when I asked for a
recurring daily brief, Siri disappointed me by saying it couldn't automatically
create one. It offered to create a reminder for me to prompt it daily at 8 a.m.
for a daily brief.

Another disappointment, and possible bug, is that using Siri AI to open a System
Setting fails and puts me at "System Settings > General." Alfred, on the
other hand, is able to bring me directly to the setting.

## Initial Impression

Although I've initially been underwhelmed, I'm excited to see where Siri AI
goes. I rarely used Siri before because of how limited it was. Although Apple
has, [somewhat famously][appleaifail], stumbled to get useful AI features in
users' hands, Siri AI is the continuation of the turnaround Apple Intelligence
began. My initial time spent with it shows promise: I am starting to reach for
Siri instead of defaulting to a web search, and it called attention to the
handful of important emails across my mail providers. 

Still, for Apple's second attempt, it's lukewarm.


[waitlist]: https://www.macrumors.com/2026/09/15/ios-27-siri-ai-has-waitlist-how-to-join/
[gemma4]: {{% relref "post/2026-04-13-gemma4-localllm.md" %}}
[agenticos]: {{% relref "post/2026-08-20-agentic-os-local-llm-macos.md" %}}
[alfred]: https://www.alfredapp.com/
[wwdc]: https://developer.apple.com/wwdc26/
[taskmgmt]: {{% relref "post/2022-02-21-life-management-system-comparison.md" %}}
[appleaifail]: https://spyglass.org/apple-ai-fail/
