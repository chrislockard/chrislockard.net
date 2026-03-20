---
title: "Firefox Is Cooking"
date: "2026-03-19T20:41:41-04:00"
url: "posts/firefox-is-cooking"
categories:
- Technology
tags:
- firefox
- infosec
author: "Chris"
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "I'm surprised and delighted at the pace of Firefox innovation lately."
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
cover:
    image: "/images/2026/3-19-1.png" # image path/url
    alt: "Firefox Logo" # alt text
    caption: "Firefox Logo" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
---
Mozilla published a blog post on Tuesday that excited me for several reasons:

[More reasons to love Firefox: What's new now, and what's coming
soon](https://blog.mozilla.org/en/firefox/firefox-148-149-new-features/)

## Communications

First, I appreciate the improved communication. Along with recent posts like [AI
Controls are coming to
Firefox](https://blog.mozilla.org/en/firefox/ai-controls/), Mozilla has been
teasing new features and creating anticipation with these product posts. These
articles show that Mozilla is proud of what its building and wants to raise
excitement. For me, it's working! 


I've been using Firefox for so long that I'm used to visiting [What Train is it
Now?](https://whattrainisitnow.com/) to get an idea of what's coming, but it's
so much nicer to see clear, up-front communication.

## Privacy

The coming feature that's attracted my interest the most is the mention of a free built-in VPN. If this service is provided by Mullvad and only proxies Firefox's traffic, I will be overjoyed. The 50GB/month allowance seems more than generous, but I'll be curious to see how YouTube eats into that. Perhaps there will be a per-site configuration...

I'm most excited about this feature because this will close one of the biggest
privacy gaps between Firefox and Safari (with Private Relay): IP address
masking. Firefox provides [privacy](https://www.firefox.com/en-US/user-privacy/)
features - [including those I've written about before]({{% relref
"2020-08-20-fingerprinting-privacy-brave-vs-firefox.md" %}}) - but this will be
pivotal to stop one of the stickiest fingerprinting vectors: the user's IP
address. 

Of course, if Mozilla hasn't thought this through, or worse, decided to siphon
user data for profit, this will backfire spectacularly.

# Better Security

[Mozilla describes the Sanitizer
API](https://hacks.mozilla.org/2026/02/goodbye-innerhtml-hello-sethtml-stronger-xss-protection-in-firefox-148/)
for developers to use to mitigate Cross-Site Scripting (XSS) vulnerabilities. 

Yes! Mozilla displaying technical prowess and initiative is critical: it shows
that the web platform doesn't solely belong to Google and Chrome.

## Productivity Feature Parity

At some point in recent history, Brave added split view functionality and I didn't realize it. Then I used it at work once or twice, and now it's part of my workflow.

The addition of this feature reduces Brave's pull on me.

{{< callout type="success" title="Available Now" emoji="ℹ️" >}}
This feature is available now, in 148! Navigate to "about:config", and set "browser.tabs.splitView.enabled" to "true".
{{< /callout >}}

## Kit

Firefox's new mascot, kit, is oddly impactful. I'm not sure why, but I like the
idea of a mascot for this (very) personal software I use. 

The cynic in me hopes this isn't a cute facade to allow Mozilla to do harm.

## Unexpected Pleasantries

In all, I'm hyped for Firefox 149 to be released next week. I hope Mozilla can capture the momentum and take back some web browser market share from Chrome. Adding features users enjoy like those found in the 148 and 149 releases are how they're going to do it!
