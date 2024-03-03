---
title: "Life Management System Comparison"
subtitle: "PPV vs PARA and supporting tools (Notion vs Evernote vs Orgmode)"
summary: "I describe how Pillars, Pipelines, and Vaults is the best Life Management system I've found"
url: "/posts/life-management-system-comparison-ppv-vs-para-notion-vs-evernote"
authors: []
categories:
- efficiency-organization
tags:
- notion
- ppv
- evernote
- para
- orgmode
date: 2022-02-21T21:00:00-04:00
lastmod: 2022-02-21T21:00:00-04:00
featured: false
draft: false
---

# Introduction

[I wrote a long time
ago](https://www.chrislockard.net/posts/professional-organization-habits/) about
my lack of professional organization habits for most of my life. Since that post
nearly 10 years ago, I’ve tried many workflows and tools that promised increased
efficiency, organization, motivation, time management, knowledge management, or
some combination of the above. A non-exhaustive list includes:

- [Evernote](https://evernote.com) 
- [Trello](https://trello.com) 
- [Org-mode](https://orgmode.org/)
- [Org-roam](https://www.orgroam.com/) 
- [Obsidian](https://obsidian.md/) 
- [Zettelkasten](https://zettelkasten.de/posts/overview/)
- [PARA](https://fortelabs.co/blog/para/)

Disheartened, I resigned myself to the fate of cobbling together one or more of
these tools into a workable system, never fully trusting that it was serving me
the way I needed it to. 

But then something amazing happened! I discovered [August
Bradley](https://www.youtube.com/channel/UCfqj2oq6LVmR3ybC2nfjqKg) and his
[Pillars, Pipelines, and
Vaults](https://www.youtube.com/playlist?list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b)
(PPV) system. It has completely changed how I approach my work, habits, goals,
and aspirations, and I’m so excited about this system that I want to share it
with you!

But first, a brief review of what *didn’t* work about previous systems that
makes PPV so special:

# Deficiencies in Other Systems

## Impeding Recall

This is the most important deficiency in any other tool or system I used
previously. Before discovering PPV, I sought in vain to find a solution that
would provide me with the information I needed *exactly* when I needed it.

Evernote addressed this deficiency better than other tools and systems: as long
as I knew to save *everything* in Evernote, there was a good chance I could find
it later when I needed it. This requires expending a great deal of effort to add
everything that might be useful. The more time needed to add content, the less
useful the tool or system becomes.

## Comprehensiveness and Adaptability

I wanted one solution for several problem domains: life management and
organization, task tracking, knowledge management, goal setting, motivation
assistance, mind expansion, learning assistance, and others not yet identified.

Other tools and systems were singularly focused. Evernote can help track tasks
and goals (and minutiae!). Trello is only useful for task tracking. Zettelkasten
excels at knowledge management, but falls short everywhere else. PARA succeeds
in several areas, but it only excelled in the organization and tracking problem
domains.

## Maintenance & Upkeep

Every system or application will require some level of maintenance and upkeep.
The most glaring example of this was my time spent with Org-mode and its Emacs
ecosystem. Every so often there was something I needed to fix: a botched
package upgrade here, or a configuration error there. Don’t get me started on
breaking changes (ahem, Org-roam). Each triviality demanded minutes (sometimes
hours) to unpack and fix. I also ~~spent~~ wasted a great deal of time
[bikeshedding](https://web.archive.org/web/20220120202856/https://whatis.techtarget.com/definition/Parkinsons-law-of-triviality-bikeshedding)
my Emacs config ([a popular pasttime among many
Emacsers](https://web.archive.org/web/20210923070322/https://www.reddit.com/r/emacs/comments/pti06k/life_of_an_emacser/)).

## Mono-platform

Productivity or knowledge management tools or systems should run everywhere.
Many of those I tried should have in theory, but in practice did not.

Org-mode and Org-roam require [Emacs](https://www.gnu.org/s/emacs/). Emacs runs
comfortably on desktop operating systems, but Windows performance and capability
is sub-par. As an iPhone owner, I did not have an elegant (or even complete)
solution to reviewing or adding content to my Org-mode ecosystem while away from
a desktop. As someone who spends roughly 40% of my productive time away from a
desktop, this is a significant disadvantage.

Evernote famously runs just about everywhere, but I’ve only had a good user
experience retrieving information from it on-the-go. Trying to add anything
meaningful requires a keyboard.

Syncing content between iOS and the rest of my ecosystem isn’t feasible as I’m a
heavy Dropbox user. Currently, the obsidian app only supports iCloud or
Obsidian’s bespoke sync.

Good luck keeping your zettelkasten in sync and uncorrupted if you use Windows,
macOS, and Linux desktops along with an iPhone.

## Time/Value Ratio

My expectation for an ideal solution is one that rewards me for the time and
effort I’ve put into it. The systems I previously tried increased their value
over time, but not as quickly as I was happy with. In some cases, the rate of
return was abysmal: my experience with Org-roam was that I spent days of my life
configuring and using this system only to fight with it constantly for little
tangible return. 

# PPV - A Life Management Quantum Leap

And so, over Christmas break I came across [August Bradley’s YouTube
channel](https://www.youtube.com/channel/UCfqj2oq6LVmR3ybC2nfjqKg). I watched
his [“Intro & Overview of Pillars, Pipelines, and Vaults - Notion Life Operating
System”](https://www.youtube.com/watch?v=d93SGaf82OM) and immediately took
notice. The confident, soft-spoken Bradley was presenting something that seemed
too good to be true. My curiosity piqued, I watched several more videos,
including the “[My Notion Life Operating System
Overview](https://www.youtube.com/watch?v=4-TYSah25UM)” before going to sleep at
an absurdly late hour. I was captivated.

{{< figure src="/images/2022/2-21-1.png" caption="I'm writing this post in Notion :)" >}}

A word before I extol the virtues of PPV: This system, like any other, will
require time and effort to stand up. [August offers a course that aids in this
endeavor](https://www.yearzero.io/notion-life-design). You can come a long way -
as I have - by viewing the [PPV YouTube
series](https://www.youtube.com/playlist?list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b).
It’s a couple dozen hours of content. I would recommend watching the series
through to get an understanding of how the components of the system fit together
before implementing it yourself. I’m impatient, and so I began implementing as I
went (I was also learning my way around Notion at the same time). This resulted
in a need to watch videos two or three times to ensure I understood and applied
the concepts appropriately.

Note that some of the concepts I describe below won’t make as much sense if
you’re not already familiar with PPV.

# PPV Proficiencies

How well does PPV address the deficiencies of previous tools and systems I’ve
used? Extremely well:

## Recall

I lead with this proficiency because it’s the most important to me: PPV will
surface information when I need it. My favorite example is how my Action Items
(tasks) list ties into the projects I’m currently working on and how they
automatically emerge day-to-day and week-to-week. Thanks to my Action Items
dashboard, I can also quickly see what I’ve completed in the past week, and what
my tasks for today, tomorrow, and the upcoming week are. This is an *actual*
super power during weekly team meetings, project stand-ups, and one-on-ones.

## Emergence

The true value of August Bradley’s PPV is that it’s a component of a larger
system. In fact, Bradley discusses Systems Thinking extensively, with the [third
video in the PPV series](https://www.youtube.com/watch?v=3AKHjwvEufg) being
dedicated to this concept. 

Perhaps the most significant property of the PPV system is that it fosters
emergence - the quality of systems becoming greater than the sum of their parts.
Emergence is what Zettelkasten is known for and aspires to. My experience with
Zettelkasten is that emergence is the only killer feature of the system. In PPV,
it’s one of many features. 

## Comprehensiveness and Adaptability

I stated above that I wanted one solution for several problem domains: life
management and organization, task tracking, knowledge management, goal setting,
motivation assistance, mind expansion, learning assistance, and others not yet
identified. 

PPV not only meets this criteria, but it exceeds. In fact, due to the way Notion
databases inter-relate, I’m not sure it’s technically possible for any other
software to implement this comprehensiveness and adaptability. Airtable,
perhaps.

Life management, organization, and task tracking are accomplished by many facets
of PPV, including
[dashboards](https://www.youtube.com/watch?v=2sQup0BfdPs&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=6),
the [Action
Zone](https://www.youtube.com/watch?v=ZlmGbujysS0&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=8),
the [Project
Database](https://www.youtube.com/watch?v=apzPFrIjytY&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=17),
and [Daily
Tracking](https://www.youtube.com/watch?v=9qLdGOLs7u4&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=10).

Knowledge management is facilitated by the implementation of
[Vaults](https://www.youtube.com/watch?v=2vvs7CjyS1M&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=27),
some examples of which are the [Book
Vault](https://www.youtube.com/watch?v=uNHOUmojYRU&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=28),
the [Notes & Ideas
Vault](https://www.youtube.com/watch?v=cbPPelWopis&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=30),
and my favorite the [Knowledge and Tag
Vault](https://www.youtube.com/watch?v=xj19RWriD8o&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=37).

The [Alignment
Zone](https://www.youtube.com/watch?v=lM1xmu4JMB8&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=16)
is the best method I’ve ever seen for goal setting and motivation assistance.
Even if this was the only feature of PPV, I would still prefer this system over
others. It is simply that powerful. The Alignment Zone is the crux of all your
aspirations, goals, projects, and tasks. It is the alignment of all of these
features that is so essential to PPV. 

## Maintenance & Upkeep

Every system or application will require some level of maintenance and upkeep.
In PPV,  maintenance and upkeep are features of the overall system, with
[weekly](https://www.youtube.com/watch?v=kNL6mA5kRec&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=21),
[monthly](https://www.youtube.com/watch?v=QYFVjZAbA2I&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=22)/quarterly,
and
[yearly](https://www.youtube.com/watch?v=bnoV0Gepg2w&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=48)
reviews. These reviews are essential to the overall system because they ensure
that your day-to-day tasks overall support your goals and aspirations. For more
on this, review the [Alignment
Zone](https://www.youtube.com/watch?v=lM1xmu4JMB8&list=PLAl0gPKnL3V8s7dPXoo07mYnuErhWVk8b&index=16).

## Cross-platform

This is more so a feature of [Notion](http://notion.so), the app upon which PPV
is built, than PPV itself. Notion is available on all desktop and mobile
operating systems. You can customize the appearance of several views in Notion
to be mobile-friendly (for instance gallery or list views for databases).  

## Time/Value Ratio

My expectation for an ideal solution is one that rewards me for the time and
effort I’ve put into it. I’ve been using PPV for just shy of three months, and
the return on investment has been phenomenal. Although it took a few dozen hours
to implement to its current state, I have saved nearly as much time on
organizational and task tracking alone. I anticipate minor tweaks needed here
and there moving forward, and there’s almost zero propensity to bike-shed
anything else about my Notion environment, so the time/value ratio can only go
up!

## Security & Privacy

This is a sweet, sweet bonus: Notion has a comprehensive [privacy and security
page](https://www.notion.so/help/security-and-privacy) that even outlines how to
opt-out of Notion telemetry. [They’re even SOC2
compliant](https://www.notion.so/blog/notion-soc-2-compliant).

# Notion isn’t perfect...

By this point, I’m sure I sound like a shill. Although PPV is the closest to
perfection in any life management system I’ve ever come, Notion is not without
some annoyances. Namely:

- No offline mode - as a SaaS, this isn’t unexpected. Still, every time AWS goes
out, Notion will as well.  
- Web clipper can be hit-or-miss - Sometimes it works
flawlessly, others not at all. In general, it doesn’t have the polish of
Evernote’s.  
- Not the snappiest tool on the block - A minor, minor annoyance
when compared with all of the immense benefits afforded.

# Conclusion

I have been tremendously impressed by August Bradley’s PPV system and
implementation in Notion. Building out my own version of it has been exciting,
because I’ve been able to start using it before it’s completely finished. It’s a
lot like building the plane as it’s taking off and starting to fly. The best
part? I’m already beginning to see tremendous benefits, most notably in the
clarity of mind I have at the end of each day. My mind can settle down
and I trust that I’ve captured everything needed to maintain and operate my
Life.

No other system out there can do that. 

# Call to Action

Give August Bradley’s PPV series a go! Watch as he describes Systems Thinking
concepts and how Notion can apply them.