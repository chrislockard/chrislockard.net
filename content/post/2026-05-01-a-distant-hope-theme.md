---
title: "A Distant Hope Theme"
date: "2026-05-01T12:55:54-04:00"
url: "posts/a-distant-hope-theme"
categories:
- dev
tags:
- zed
- theme
author: ""
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Introducing a Zed dark mode theme inspired by An Old Hope"
disableHLJS: true # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: false
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: false
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "/images/2026/5-1-1.png" # image path/url
    alt: "Theme preview in Zed editor" # alt text
    caption: "Theme preview in Zed editor" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
---

Instead of my usual news roundup, today I'd like to share the theme I've been
working on for a little while.

Back in my [Emacs Phase][Emacs], I greatly enjoyed a theme included in [Doom
Emacs][DoomEmacs] called "doom-old-hope". I've since learned this was based on
[an earlier theme for the Atom text editor][Atom].

For the past year, I've been using [Zed][Zed] as my regular text editor. Since I
haven't seen any themes matching "An Old Hope" in Zed's theme library, I
decided to make my own.

## A Distant Hope

Today, I want to give back to the Zed community, so I'm releasing a theme I'm
calling [*A Distant Hope*][Theme].

The colors don't match 1:1 with An Old Hope, and that's intentional. I drew
inspiration from that theme, but had a few ideas of my own :)

I primarily use Zed on a mac, and so one of the aims of this theme is to match
the Zed window chrome with macOS's so it blends in with the rest of my
applications. 

## Installation

I'm still working to get a PR approved so it can be added to the theme list
Zed's extensions view, but you can grab it right now by:

1. Cloning the repo `cd ~/.config/zed/themes/ && git clone
   https://github.com/chrislockard/a-distant-hope-theme`
2. In Zed, open command palette (e.g., cmd-shift-p) and run "zed: install dev
   extension" and enter `~/.config/zed/themes/a-distant-hope-theme` 
3. Open the command palette again and enter `theme selector: toggle` and choose
   `A Distant Hope`

I hope you enjoy the theme! PRs and comments welcome!

[Emacs]: {{% relref "/post/2019-09-17-notes-on-compiling-emacs-for-macos.md" %}}
[DoomEmacs]: https://github.com/doomemacs/doomemacs
[Atom]: https://github.com/jesseleite/an-old-hope-syntax-atom
[Zed]: https://zed.dev
[Theme]: https://github.com/chrislockard/a-distant-hope-theme
