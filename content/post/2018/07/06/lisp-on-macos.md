---
title: "Lisp on MacOS"
date: 2018-07-06T12:00:00-04:00
url: "/posts/lisp-on-macos"
categories:
- coding
tags:
- lisp
- macos
summary: "Towards a working LISP environment on macOS"
---

# Background

[Lisp](https://en.wikipedia.org/wiki/Lisp_\(programming_language\)) is a
programming language that's been on my radar for a while, but I've never
investigated until now. While browsing the web last night, I came across [this
Paul Graham article about the start of
Viaweb](http://www.paulgraham.com/avg.html) and my curiousity was piqued.

This post is my attempt to consolidate my experience of getting a lisp
development environment set up in July 2018.

For the rest of this post, `[~] $` is my terminal prompt, and
`*` is the sbcl Common Lisp interpreter prompt

# Lisp

[SBCL (Steel Bank Common Lisp)](http://www.sbcl.org/) appears to be the popular
option for [Common Lisp](https://en.wikipedia.org/wiki/Common_Lisp) which, in
turn, is the most popular open source Lisp dialect. This can be installed using
[homebrew](https://brew.sh/):

```bash
$ brew install sbcl
```

To verify a Common Lisp interpreter is installed properly, open a terminal and
type `sbcl` to enter the Common Lisp
[REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop):

```bash
[~] $ sbcl --noinform
* (+ 1 2 3)

6
* (quit)
[~] $
```

# Editor

To my dismay, it seems as though the lisp programming environment is
fundamentally tied to Emacs, an editor I've always eschewed. I can't even close
Emacs without Ctrl-C. Visual Studio Code is my preferred tool.

I installed a GUI version of GNU Emacs from
[Emacsforosx](https://emacsformacosx.com/) using homebrew:

```bash
[~] $ brew cask install emacs
```

Once brew finishes, this can be launched from the /Applications folder, using
spotlight, or from the terminal with

```bash
[~] $ open -a /Applications/Emacs.app
```

# Editor package manager

Some searching led to [MELPA](https://melpa.org/#/getting-started) as the Emacs
package manager I would have success with getting Slime - the Emacs Lisp helper
package - installed.

I set up MELPA by following the installation instructions
[here](https://melpa.org/#/getting-started):

```bash
[~] $ vi ~/.emacs
```

I pasted the MELPA initialization code below:

```lisp
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
```

## Installing Slime

From the [Slime
Introduction](https://common-lisp.net/project/slime/doc/html/Introduction.html#Introduction):

> SLIME is the “Superior Lisp Interaction Mode for Emacs.”  SLIME extends Emacs
with support for interactive programming in Common Lisp.

To install this, I restarted Emacs.app, and then ran the package manager to
install Slime:

```
(within Emacs.app)
M-x package-install <return> slime <return>
```

I then added the Lisp interpreter I installed using Homebrew to my .emacs file:

```
(within iTerm.app)
[~] $ echo "(setq inferior-lisp-program \"/usr/local/bin/sbcl\")" >> ~/.emacs
```

## Success

At this point, everything is set up and ready to run! Common Lisp programming
using SLIME can be initiated by opening Emacs.app and typing ```M-x slime
<return>```

## Bonus round - Quicklisp

[Quicklisp](https://www.quicklisp.org/beta/) is the Common Lisp ~~package~~
library manager. It can be installed by [following the instructions at the
Quicklisp website](https://www.quicklisp.org/beta/#Installation):

Download Quicklisp.lisp:

```
[~] $ curl -O  https://beta.quicklisp.org/quicklisp.lisp
```

Install Quicklisp and specify a specific path to install quicklisp to (I don't
want my home directory unnecessarily polluted, so I chose to install it to my :

```
[~] $ sbcl --noinform --load quicklisp.lisp

  ==== quicklisp quickstart 2015-01-28 loaded ====

    To continue with installation, evaluate: (quicklisp-quickstart:install)

    For installation options, evaluate: (quicklisp-quickstart:help)

* (quicklisp-quickstart:install :path "~/.quicklisp")
...<snip>...
  ==== quicklisp installed ====

    To load a system, use: (ql:quickload "system-name")

    To find systems, use: (ql:system-apropos "term")

    To load Quicklisp every time you start Lisp, use: (ql:add-to-init-file)

    For more information, see http://www.quicklisp.org/beta/
*
```

To force quicklisp to load at sbcl startup, execute the following
post installation:
```
* (ql:add-to-init-file)
```


Verify that Quicklisp launches when the sbcl interperter starts by quitting
sbcl, relaunching it, and typing ```(ql:help)```:

```bash
[~] $ sbcl --noinform
* (ql:help)

"For help with Quicklisp, see http://www.quicklisp.org/beta/"
```

Verify that Emacs.app and the SLIME environment are correctly pulling in the
Quicklisp configuration by launching Emacs.app, running ```M-x slime <return>```
and then entering:

```
* (ql:help)

"For help with Quicklisp, see http://www.quicklisp.org/beta/"
```

# References

[Paul Graham - Lisp](http://www.paulgraham.com/lisp.html)
[Paul Graham - Beating the Averages](http://www.paulgraham.com/avg.html)
[Practical Common Lisp](http://www.gigamonkeys.com/book/)
[SLIME User Manual](https://common-lisp.net/project/slime/doc/html/)
[EmacsWiki - Emacs for MacOS](https://www.emacswiki.org/emacs/EmacsForMacOS#toc14)
[Quicklisp](https://www.quicklisp.org/beta/)

## My .emacs file

After following the steps outlined above, this is what my .emacs file looks like
(including two lines to change the meta key from alt/option to cmd on MacOS)

```lisp
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (slime))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq inferior-lisp-program "/usr/local/bin/sbcl")
(setq mac-option-modifier 'super)
(setq mac-command-modifier 'meta)
```
