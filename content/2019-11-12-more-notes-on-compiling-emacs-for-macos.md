---
title: "More Notes on Compiling Emacs for macOS"
date: "2019-11-12T15:13:21-05:00"
url: "posts/more-notes-compiling-emacs-macos"
draft: false
categories:
- foss
tags: 
- emacs
- macOS
- foss
- gnu
- liberated
summary: "Compiling emacs on macOS using Homebrew"
---

My [last post]({{< relref
 "/content/post/2019/09/17/notes-on-compiling-emacs-for-macos.md">}}) covered how to manually
compile Emacs on macOS. This process has worked well for me, except that
I lacked the capability to automatically update my Emacs distribution.

I originally sought to compile my own version of Emacs because I wanted a newer
version than the one availble via the official Homebrew tap. Some searching led
me to a stackoverflow post that pointed me to
[daviderestivo/homebrew](https://github.com/daviderestivo/homebrew-emacs-head).
This approach should have the added benefit of updating Emacs when I run `brew upgrade` instead of needing to git pull and recompile the whole Emacs project.

Probably, I should automate my process and include code signing but there just
aren't enough hours in the day right now, so this will have to do. These notes
are for my future reference:

# Step 1 - Add Tap

Add the custom tap with

`brew tap daviderestivo/emacs-head`

# Step 2 - Install Emacs

I've specified the flags I want for my install. More can be found on the tap's
github page, linked below:

`brew install emacs-head --HEAD --with-cocoa --with-librsvg --with-imagemagick@7 --with-jansson --with-no-frame-refocus --with-mailutils --with-dbus --with-modules --with-modern-icon-sexy-v1`

# Step 3 - Copy Emacs to /Applications

I wanted an elegant and automated way for Emacs to show up in Spotlight, as I
launch all software on the mac this way. It seems the best way to do this is to
simply copy the Emacs.app bundle to /Applications per [this github discussion.](https://github.com/Homebrew/legacy-homebrew/issues/4635)

`$ cp -r /usr/local/Cellar/emacs-head/HEAD-1e5392a_1/Emacs.app /Applications`

And that's it! The latest version of Emacs HEAD is installed and ready to use.

# References

The research for this post primarily involved this link:

- [StackOverflow - How can I install emacs correctly on os x](https://stackoverflow.com/questions/44092539/how-can-i-install-emacs-correctly-on-os-x)

Which pointed me toward this Homebrew package:

- [daviderestivo/homebrew](https://github.com/daviderestivo/homebrew-emacs-head)

This github discussion describes methods of installing homebrew bundles into the
appropriate locations for Spotlight to properly find them:

- https://github.com/Homebrew/legacy-homebrew/issues/4635
