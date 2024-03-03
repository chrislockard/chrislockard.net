---
title: "Moving From Macos to Linux"
date: "2020-05-26T00:00:00-04:00"
url: "posts/moving-from-macos-to-linux"
draft: false
categories:
- foss
tags: 
- linux
- macOS
- foss
- liberty
summary: "I've adopted Linux on the desktop. Here's how I adapted my macOS workflow..."
---

I've recently installed [PopOS!](https://pop.system76.com/ "PopOS! an
Ubuntu-derivative from System76") on my home computer. Prior to the move, I was
nervous about giving up the comfy workflows I've developed over the past 12
years as a macOS user. So much of my computing was tied up in Apple's ecosystem
that I was afraid I would never be able to joyfully use another operating
system. 

I was __wrong!__

The night before I wiped my desktop, I made a list of all my macOS "killer"
features. Some of them, I was sure, would not survive the move, and I expected
to run back to macOS at the first sign of incompatibility. I'm elated to say
that, a month later, I've found sufficient (and in some cases __far superior__)
alternatives.

Here's a table of what I used to use on macOS, and what I've replaced it with on
Pop!: 

| Purpose              | Apple 🍎                                                                       | Linux 🐧                                                                        |
|----------------------|--------------------------------------------------------------------------------|---------------------------------------------------------------------------------|
| App launcher         | [Alfred App](https://www.alfredapp.com/)                                       | [ULauncher](https://ulauncher.io/)                                              |
| Terminal             | [iterm2](https://iterm2.com)                                                   | Gnome Terminal                                                                  |
| File sharing         | [Dropbox](https://dropbox.com)                                                 | [Dropbox](https://dropbox.com)                                                  |
| Browser              | [Brave](https://www.brave.com)                                                 | [Brave](https://www.brave.com)                                                  |
| Screen Capture       | Built-in (cmd-shift-4+space) or [Skitch](https://evernote.com/products/skitch) | [Flameshot](https://github.com/lupoDharkael/flameshot)                          |
| Quick notes          | [nvAlt](https://brettterpstra.com/projects/nvalt/)                             | [Emacs + deft.el](https://jblevins.org/projects/deft/)                          |
| Gaming               | n/a                                                                            | [Lutris!](https://lutris.net/) + Steam/Proton + Wine                            |
| Application Firewall | [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html)         | [gufw](http://gufw.org/),[OpenSnitch](https://github.com/evilsocket/opensnitch) |

## App Launcher
I rely heavily on Alfred in macOS to launch applications, quickly navigate the
filesystem, insert text snippets, and store a global clipboard history.
ULauncher provides this functionality and has [a large
library](https://ext.ulauncher.io/) of extensions. 

## Terminal
[iterm2](https://iterm2.com) for macos has a huge array of features. It turns
out i don't use the majority of them and gnome terminal does what i need it to.
The one thing i'm missing is a quake-style drop-down display for the terminal.

## File Sharing
[dropbox](https://dropbox.com) is available on all platforms I'm aware of. It
works nearly as well on Linux as it does on macOS - the only feature it's
missing that I rely on is smart sync.

> One "killer app" that macOS enjoys is Airdrop, a seamless proximity-based
> filesharing service. It's major drawback is, of course, that it only works with
> Apple devices and operating systems.
> [Snapdrop](https://onedoes.github.io/snapdrop/) appears to be a promising
> alternative for Linux and Windows.

## Browser
Browser engines are largely cross-platform, so I wasn't worried about losing out
here. I stick with the [Brave Browser](https://brave.com/rnr267) falling back to
Mozilla Firefox.

## Screen Capture
Over time, taking partial screenshots with 'cmd-shift-4' and whole-window
screenshots with 'cmd-shift-4-space' on macOS became second nature to me.
[Flameshot](https://github.com/lupoDharkael/flameshot) is a great substitute for
this on Linux.

## Quick Notes
Although I discovered it relatively recently,
[nvAlt](https://brettterpstra.com/projects/nvalt/) became a must-have. I
especially rely on it for note taking during meetings, and I really appreciate
its simple, system-wide shortcut to access and discard. 

I'm still searching for a similar implementation on Linux, but the [ deft
](https://jblevins.org/projects/deft/) package brings Notational Velocity (upon
which nvAlt is based) to my favorite text editor.

## Application Firewall
I use [Little Snitch](https://www.obdev.at/products/littlesnitch/index.html) on
macOS to ensure programs aren't making unwanted connections. This is helpful
when using untrusted software and in day-to-day usage (such as blocking
telemetry in applications or in the marketing emails I receive).

Sadly, the only alternative I've found in the Linux ecosystem is an unmaintained
project called [OpenSnitch](https://github.com/evilsocket/opensnitch). Hopefully
this project will get forked and maintained.

There's also [fireprompt](https://fireprompt.com/), but the lack of any
documentation or information on it (as pointed out in [this reddit
thread](https://www.reddit.com/r/linuxquestions/comments/bectru/has_anyone_more_information_on_the_fireprompt/)
seems suspicious to me)

I think the long-term solution for this is going to involve tinkering with
`gufw` and building a deny-all rule then selectively adding applications as I
use them.

## Gaming
I want to commend Lutris! This project is providing an absolutely _amazing_
service to its users. If you are interested in gaming on Linux, you should
definitely check out and contribute to this project. I've only spent a couple of
hours configuring it, but below you can see the games I've enabled and are fully
playable:

{{< figure src="/images/2020/05-26-1.png" caption="I love the icon artwork!" >}}

I was __floored__ to discover I could easily get one of my all-time favorite vintage
games - Diablo - running with a modernizing mod with a one-click installation
from the lutris website! Brilliant!

{{< figure src="/images/2020/05-26-2.png" caption="Diablo by Blizzard entertainment" >}}

In addition to Lutris, the steam client with the [Proton compatibility
layer](https://github.com/ValveSoftware/Proton/) has allowed me to play all of
the games I've purchased through the steam store. There's also my collection of
games from [GoG](https://www.gog.com/), many of which are packaged to run on
Linux as well.

When I first replaced my desktop with Linux in 2007, I eventually gave up
because the support for my favorite pastime wasn't mature. In the years since,
this has changed significantly and I am more impressed with Linux's gaming chops
than I am with either Windows or macOS.

## Conclusion
The common theme I see when looking for Linux alternatives to my favorite macOS
applications is there's usually only one feature missing. In some cases, this
one feature can make all the difference in the usability of the application. In
others, it's a minor annoyance. The new scale upon which I weigh these
decisions is whether the missing feature is worth giving up the computing
freedom gained by leaving the walled garden.

For me, the choice is clear.
