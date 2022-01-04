---
title: "Spacemacs Go Layer and Environment Variables on macOS"
date: 2018-08-13T20:53:59-04:00
url: "/posts/spacemacs-env-go-layer"
categories:
- foss
tags:
- coding
- foss
- efficiency
summary: "Configuring Spacemacs Go layer and environment variables on macOS"
---

This is a quick note to future me (and anyone encountering this same issue).
[TL;DR - the solution](#solution)

While running into issues getting the *golang* layer configured, I discovered
that a lot of pain was caused by a cached configuration and some outdated
information.

# System Info

* OS: Darwin
* Golang: go version go1.10.3 darwin/amd64 (installed via Homebrew)
* Emacs: 26.1
* Spacemacs: 0.300.0 (develop)
* Spacemacs branch: f2a4cc
* Graphics display: t
* Distribution: Spacemacs
* Editing style: vim
* Completion: helm
* Layers:

```(
     html
     helm
     auto-completion
     emacs-lisp
     git
     go
     markdown
     (markdown :variables markdown-command "pandoc")
     (org :variables
          org-enable-reveal-js-support t
          org-want-todo-bindings t)
     themes-megapack
     spell-checking
     syntax-checking
     )
```

# Incorrectly configured $GOROOT

After `brew install go`, Homebrew suggests the following:

```bash
You may wish to add the GOROOT-based install location to your PATH:
  export PATH=$PATH:/usr/local/opt/go/libexec/bin
```

I had originally set this, but this caused all sorts of problems such as the
inability to `go get` packages with complaints that the standard library
packages couldn't be found.  I suspect this is due to go having problems dealing
with symlinks, as running `ls -lat /usr/local/opt/go` shows that folder is
symlinked to `/usr/local/Cellar/go/1.10.3`.  To fix this, I changed my $GOROOT
to `/usr/local/Cellar/go/1.10.3/libexec`. This appears to be the right solution,
although I'm concerned that I will need to change this every time I upgrade go.

# Outdated information

First off, the Spacemacs go layer documentation incorrectly states the "oracle"
package is a pre-requisite. This package was obsoleted at the end of 2016
per[this Stack Overflow
post](https://stackoverflow.com/questions/40444260/cannot-get-golang-oracle-package
"Stack Overflow: Cannot get GoLang oracle package"). The solution is to instead
install the "guru" package which has replaced it using:

```go get -u -v golang.org/x/tools/cmd/guru```

# Cached Configuration

Spacemacs wasn't pulling in my correct ```$GOROOT``` environment variable, which
I verified by enabling syntax checking (```SPC t s```) while in a *.go* file.
Some furious befored-bed Googling led to the following issues:

* [Develop: Go layer tools doesn't
  work](https://github.com/syl20bnr/spacemacs/issues/10867 "Develop: Go layer
  tools doesn't work")
* [New env var caching breaks git gpg
  signing](https://github.com/syl20bnr/spacemacs/issues/10851 "New env var
  caching breaks git gpg signing")
* [Github: How do I set $GOPATH properly for
  Emacs?](https://github.com/nsf/gocode/issues/261 "Github: How do I set $GOPATH
  properly for Emacs?")

The next problem was getting Spacemacs to pull the updated $GOROOT from my
environment definition. Up until now, I've been configuring my shell using
`~/.zshrc`.After reading [the Spacemacs
FAQ](http://spacemacs.org/doc/FAQ.html#why-am-i-getting-a-message-about-environment-variables-on-startup
"Spacemacs FAQ") about environment variables, I've moved the contents of my
`~/.zshrc` to `~/.zshenv` so that variables are sourced unconditionally (instead
of only for interactive shells).

This solves the problem of where to put my $GOROOT definition, but it still
wasn't being pulled into Spacemacs properly. [This
comment](https://github.com/syl20bnr/spacemacs/issues/10867#issuecomment-396949381
"Github issue comment") by[@ljupchokotev](https://github.com/ljupchokotev
"Github user ljupchokotev") is what finally pointed me in the right direction:
the Spacemacs environment file.

> Spacemacs pulls environment variables intelligently from your shell config
> file and stores them in ~/.spacemacs.env **Sometimes this file has old
> contents and must be re-created**

<a name="solution"></a>

# Solution

* Set the proper $GOROOT for *go* installed via Homebrew: `export
  PATH=$PATH:/usr/local/Cellar/go/<go version>/libexec`
  * *Optional*: set this in `~/.zshenv`, `~/.profile`, or `~/.bash_profile`
* Delete `~/.spacemacs.env` and restart Emacs. 
