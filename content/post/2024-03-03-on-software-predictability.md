---
title: "On Software Predictability"
date: 2024-03-03T18:00:00-05:00
url: "/posts/on-software-predictability"
# weight: 1
# aliases: ["/first"]
categories:
- technology
tags:
- compatibility
- software
author: "Chris"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Desc Text."
#canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/chrislockard/chrislockard.net"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---

Life's busy. Also, it's hard. 

Software that breaks compatibility or predictability makes life harder. 

Returning to a project after years off requires re-orientation of architecture
and tooling. Although difficult, it's a fair assumption to make that one should
need to re-orient on an architecture: understanding where everything goes is
natrual. The tooling, on the other hand, should remain stable. Familiar. Predictable.
 
Imagine moving out of your childhood room to attend university or join the
military. You're gone for several years, and return one night, exhausted. You
open the door and begin to search for your bed. As your fingers find the
lightswitch and turn it on, instead of light you're greeted with an error sound.
Frustrated, you walk to where your bed ought to be.

Wanting to unpack, you reach out to pull open a dresser drawer. Instead of
pulling the drawer out as you had your entire childhood, you find you must now
turn a knob on the front of the drawer to loosen it first.

At the risk of straining this already thin metaphor, I hope the point is clear:
tools changing their form whilst not in use is frustrating. 

After decades of following software development, I'm taking this opportunity to
point out the importance of software predictability. Much has been said about
backward compatibility, but I think it's more important for software to behave
predictably. 

If the first use of your application's `-d` parameter was for deletion, then
it should should continue to implement deletion. If you later develop
functionality that you think `-d` should impelment, well, tough. Put it behind
another paramater. Your users will thank you.
