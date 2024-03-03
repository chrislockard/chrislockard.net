---
title: "Compiling Emacs 27 on macOS"
date: "2020-05-15T08:30:00-04:00"
url: "/posts/compiling-emacs-27-macos"
draft: false
categories:
- foss
tags:
- emacs
- macos
- foss
- gnu
- liberated
summary: "The easy way to compile Emacs 27 on macOS using Homebrew"
---

I've got an obsession with Emacs. My favorite spin on Emacs is the _excellent_
 [Doom Emacs](https://github.com/hlissner/doom-emacs), which recently updated
 guidance on the recommended Emacs version from 26.3 to 27. I recently updated
 from 26.3 to 27 and found the process to be extremely painless. Here's how:

This post builds on the steps I take in [my last notes on Emacs compilation on
 macOS.]({{< relref "/content/2019-11-12-more-notes-on-compiling-emacs-for-macos.md">}})

First, remove the existing Emacs installation:

`brew remove emacs-head`

Next, ensure that the d12frosted/emacs-plus tap is available:

`brew tap d12frosted/emacs-plus`

Now, review the options you want to pass to the package from [this
list](https://github.com/d12frosted/homebrew-emacs-plus#options) and pass them
to the package installer:

`brew install emacs-plus --HEAD --with-emacs-27-branch --with-cocoa
--with-imagemagick@7 --with-jansson --with-no-frame-refocus --with-mailutils
--with-dbus --with-emacs-icons-project-EmacsIcon4 --with-xwidgets`

Homebrew will do all the work of pulling together the source and patches needed
to apply your selected options and after some minutes will spit out an
application. This can optionally be moved to `/Applications` or
`/Users/$(whoami)/Applications` if you want Spotlight or
[Alfred](https://www.alfredapp.com/) to easily pick it up:

`cp -r /usr/local/opt/emacs-plus/Emacs.app /Applications`

Everything is almost ready! The last step is to sync Doom's configuration with

`doom sync`

Once this is finished, you're up and running with Emacs 27 and your existing
Doom configuration!

![This screen greets me every day](/images/2020/05-15-1.png)
