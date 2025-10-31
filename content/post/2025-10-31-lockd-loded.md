---
title: "Lockd & Loded - Neovim Edition"
date: "2025-10-31T12:39:22-04:00"
url: "posts/lockd-loded-neovim-edition"
categories:
- Content
tags:
- neovim
author: "Chris"
showToc: false
TocOpen: false
draft: false
hidemeta: true
comments: false
#description: "Desc Text."
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
This week, I had the itch to develop my own [Neovim][1] configuration. Nearly a
decade ago, I tried [Emacs][2] and fell in love with it. Well, [DooM Emacs][3],
specifically. It was elegant, powerful, and sleek.

But, I just couldn't ever quite understand Emacs Lisp and how the editor's
configuration was put together. I also found myself wanting to integrate more
and more of my applications into the editor - which for some people is THE
reason they love Emacs - but I found this to violate the principle of "do one
thing well." My brain just likes knowing "this is the tool for this" and "that
is the tool for that." Plus, it didn't help that my Emacs config was breaking
frequently (because of said elisp inscrutability). Once I realized I was
spending more time shepherding my Emacs configuration than I was using it, it
was time to move on.

Since [Ghostty][4] came out just under a year ago, I've been spending more time
than ever in the terminal. I'd used Neovim in the past with [LazyVim][5] (in fact,
that's what I'm using to write this post), but I wanted to know how to configure
my own tool. With the release of Neovim 0.9 and the `NVIM_APPNAME` environment
variable, I can now incrementally build my own Neovim configuration without
breaking my existing workflow.

And so, dear reader, this week I want to share some gems that helped me grok
configuring Nevoim using the lazy.vim plugin manager. I hope you find them
useful in your own Neovim journey.

## Lazy.nvim - The Plugin Manager

- [Understanding Neovim's Initialization Process][6]
- [Lazy.nvim Explained][7]
- [Create a Neovim Config Switcher][8]

## LazyVim - Neovim Configuration Framework based on Lazy.nvim

- [Lazyvim Keymaps (useful to port to a personal configuration)][9]

## Awesome Neovim Resource

- [TJ DeVries' Advent of Neovim][10] - A treasure trove of Neovim tips and
tricks.

[1]: https://neovim.io/
[2]: http://www.gnu.org/software/emacs/emacs.html
[3]: https://github.com/doomemacs/doomemacs
[4]: https://mitchellh.com/ghostty
[5]: https://www.lazyvim.org/
[6]: https://neovim.io/doc/user/starting.html#_initialization
[7]: https://www.youtube.com/watch?v=_kPg0VBRxJc&t
[8]: https://www.youtube.com/watch?v=LkHjJlSgKZY
[9]: https://www.lazyvim.org/keymaps
[10]: https://youtu.be/TQn2hJeHQbM?si=ntLNjlix6E4PugDN
