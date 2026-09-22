---
title: "Safari 27 Tracking Protections"
date: "2026-09-22T13:00:00-04:00"
url: "posts/safari-27-tracking-protections"
categories:
- Technology
tags:
- Safari
- Privacy
type: post
author: ""
postTheme: "" # accent comes from the category; set to override
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "I learned about Safari 27 privacy improvements from a tracking company."
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
---

For the past week, [I've been using Siri AI][siri] to answer questions.
[Intrigued as I am about browser privacy protections][browserprivacy], I had a
conversation about Safari 27's privacy updates in light of recent Apple OS
updates. One of the sources Siri referenced was [this article][stape] from a
tracking company.

This tracking company highlights notable privacy enhancements in Safari 27,
including:

- Safari Link Tracking Protection (LTP) removes additional tracking parameters
  on Threads, X, and YouTube.
- Advanced Fingerprinting Protection (AFP), added in last year's Safari
  26, classifies additional trackers as fingerprinters.
- Safari 27 introduces network-layer protections to help thwart first-party
  tracking.
- Apple's privacy protections can be updated at any time, including new
  identifiers added to LTP and additional tracking script classifications.

I followed Apple's OS 27 cycle pretty closely and don't recall hearing
about any of these improvements [from Apple][27releasenotes]. [Other
trackers][taggr] are panicking about them. Good.

However, I'm conflicted about these changes.

On one hand, I am *thrilled* from a privacy standpoint with all of these
improvements, especially that Safari can update its tracking protections
independently from browser updates (which typically occur with macOS updates).
This enables rapid privacy updates in a constantly changing and user-hostile
landscape. Apple is raising the privacy bar here, and not only should that be
applauded, but users should be aware of these new protections! Other browsers
should follow suit with, or brag if they've already implemented, similar
protections.

On the other hand, users are forced to place trust in Apple here: Apple has
unilateral control over what sites get blocked by this privacy control, with no
independent oversight. Compared to the trust one already extends to Apple,
though—passwords, health data, sensitive notes, etc.,—this privacy control is
less impactful if abused. Anyone using Apple's computing platform, or
Microsoft's or Google's or any other, must necessarily extend *some* trust to
the platform provider. Still, as someone constantly looking out for shenanigans,
it bothers me that Apple's implementation forecloses independent validation.


[siri]: {{% relref "/post/2026-09-15-siri-ai-is-here-now-what.md" %}}
[browserprivacy]: {{% relref "/post/2026-07-01-fingerprinting-protection-brave-firefox-safari.md" %}} 
[stape]: https://stape.io/news/safari-27-update-tracking-protection 
[27releasenotes]: https://developer.apple.com/documentation/safari-release-notes/safari-27-release-notes
[taggr]: https://taggrs.io/safari-27-tracking-protection/
