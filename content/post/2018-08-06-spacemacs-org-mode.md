---
title: "Spacemacs Org Mode Introduction"
date: 2018-08-06T15:32:42-04:00
url: "/posts/spacemacs-org-mode-intro"
categories:
- efficiency-organization
tags:
- organization
---
# Update: 2018-08-10

Shortly after writing this post, I switched to Spacemacs develop branch - `cd
~/.spacemacs && git checkout develop` This upgraded my Spacemacs to version
0.300@26.1. This had the unexpected side effect of changing several of the key
bindings below.

* Settinm schedules and deadlines - now require a prefix of `SPC m d` before
  entering your selection (`d` for deadlines, `s` for scheduling)
* Sparse trees - keybind moved to `SPC m s s`
* Archive tree - keybind moved to `SPC m s A` (I didn't cover this in my
  original article, but this is how I archive _DONE_ tasks)
* Show all _TODO_ and deadlines - keybind moved to `SPC m s s t` and `SPC m s s
  d`

# Introduction

This is a basic overview of [org-mode](https://orgmode.org/ "org-mode") inside
of [Spacemacs](http://spacemacs.org/ "Spacemacs").

# Background

Last month, I wrote about my discovery of Emacs as a result of my interest in
the Lisp programming language. Today is exactly one month later, and the only
Lisp I've written has been [Emacs
Lisp](https://www.gnu.org/software/emacs/manual/eintr.html) as a result of the
extensive configuration of my .emacs file. In fact, I've [spent more time
customizing my Emacs install than I have actually using
Emacs!](https://github.com/chrislockard/dotfiles/commits/master/.emacs)

It wasn't too far into my Emacs journey that I began to get uncomfortable with
the keychords for most actions. To their credit, I was often able to keep the
keychord in muscle memory after minimal exposure. I decided I liked using
vim-style keybindings more than Emacs, so I quickly discovered
[Spacemacs](http://spacemacs.org/). Now, not only do I need to understand how
Emacs works, I need to learn the discrepancies introduced by the extensive
customization added by Spacemacs. 

One thing Spacemacs does extremely well is offer discoverability of features
using the Spacebar leader key. This allows me to easily explore major modes of
Emacs effectively. Which leads me to the reason for this post:
[org-mode](https://orgmode.org/) in Spacemacs!

Org-mode can use any number of nested tasks, and you can break a task down into
smaller and smaller tasks however you prefer using this method. 

```org
* This is a top-level task, such as a project
** This is a second-level task, such as a major component of a project
*** This is a third-level task, such as the constituent part of a major project component.
```

This is perhaps the most basic org-mode explanation you'll come across, but I
initially had a very difficult time understanding _exactly_ what org-mode was.
It really is just an interface for managing text-based tasks in text files.

## Following existing guides

Perhaps the first place anyone interested in org-mode should start would be [the
org-mode manual](https://orgmode.org/manual/index.html "org-mode manual").

During the past month, I've discovered that some of the best Emacs guides come
from [Sacha Chua](http://sachachua.com/), such as the gentle introduction to
org-mode found at [A Baby Steps Guide to Managing Your Tasks with
Org](http://emacslife.com/baby-steps-org.html). [There are also quality guides
on org-mode's website.](https://orgmode.org/#docs). Particularly [this
introductory tutorial](https://orgmode.org/worg/org-tutorials/org4beginners.html
"org-mode introduction") I *highly* recommend reviewing these guides!

However, these guides are _org-mode_ specific, not _org-mode-in-spacemacs_
specific, so I'd like to address some of the common functionality I've embraced
using org-mode in Spacemacs!

# Managing Tasks

## Marking TODO and DONE

Move to the task line in normal mode and press `t` to cycle between _TODO_ ,
_DONE_ , and no status

## Cycle contents of tasks

In your .org file's buffer, in normal mode, press `S <tab>` to quickly toggle
between _OVERVIEW_ , _CONTENTS_ , and _SHOW ALL_. You can also move to a task's
line and press `<tab>` to cycle between these states for that task and all of
its sub-tasks.

## Incorporate org-capture tasks into master todo list

I may be using it wrong, but I have one _.org_ file containing all of my tasks,
broken down like so:

```org
* Today
  ** Items for today
* This week
  ** Items that will need to be finished by the end of the week
* Soon
  ** Items that should be finished soon
* Projects < 3 months
  ** projects that need to be completed within three months
* Projects < 6 months
  ** projects that need to be completed within six months
```

I discovered _org-capture_ ( `SPC m c` ) but found that my tasks captured this
way were being written to ~/org/notes.org instead of my master todo list. To
change this, I added the following in my ~/.spacemacs file:

```lisp
...
((defun dotspacemacs/user-config ()
  ...
  (with-eval-after-load 'org
    (setq-default org-default-notes-file "~/Dropbox/Chris/org/tasks.org"))
```

Now, when I capture tasks with `SPC m c`, my tasks are appended to the bottom of
my _tasks.org_ file. I'm still exploring whether there's a better method to
quickly input tasks, but this has been the fastest method I've found.

## Setting schedules and deadlines

To set a deadline for a task, move the cursor over the task and press `SPC m d`.

To set a scheduled start (i.e., the date you plan to start working on the task),
move the cursor over the task and press `SPC m s`.

For more information, see [deadlines and
scheduling](https://orgmode.org/manual/Deadlines-and-scheduling.html "org-mode
deadlines and scheduling").

## Date formats

Setting dates in org-mode is made easier thanks to the shorthand inputs it
supports. For example:

* to set tomorrow as the deadline, enter `+1`
* to set one week from today as the deadline, enter `+1w`
* to set one month from today as the deadline, enter `+1m`
* to set the Thursday following the next, enter `+2thu`
* to set the upcoming July 4, enter `jul 4`

For more examples, see [date and time
prompt](https://orgmode.org/manual/The-date_002ftime-prompt.html "org-mode date
and time prompt").

## Using a sparse trees to quickly filter TODOs and deadlines

Sparse trees can be used to rapidly filter a todo list by showing only _TODO_
items, start/deadlines, or by any property set for a task. Access sparse tree
mode with `SPC m /` and look at the minibuffer for options.

For example, to show all of your deadlines, enter `SPC m / d`

To show all of your _TODOs_, enter `SPC m / t`

# Using org-agenda

__Prior to using any of org-agenda's features, your _.org_ file needs to be
added to it using `SPC SPC org-agenda-file-to-front` or `C-c [`__

Once this step is complete, most org-agenda items can be accessed by pressing
`SPC m a`. The most useful shortcut I've used for org mode is to bring up my
agenda for the week using `SPC m a a`

The other options available under `SPC m a` will become more useful as my number
of tasks tracked increases.

# Conclusion

These four very basic task management activities are my introduction to
org-mode. As with everything else Emacs related, I expect I have only scratched
the tip of the iceberg, but the journey of learning this tool has been an
experience I would recommend! The most difficult challenge involves forcing
myself to enter all of my tasks in Emacs rather than Jira, Evernote, or Outlook,
but the command and flexibility offered by org-mode appears superior at this
point!
