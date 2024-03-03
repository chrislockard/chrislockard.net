---
title: "Professional Organization Habits"
date: "2013-12-06T12:00:00-04:00"
url: "/posts/professional-organization-habits"
categories:
- efficiency-organization
tags:
- notes
- organization
- evernote
---
This is a topic I've had a love/hate relationship with my entire life.  I was
once forced to go to a time management workshop on Saturdays in high school. My
friend and I spent more time talking to the girls in front of us than actually
listening to what the lecturer was saying, so I wonder if I missed out on
something there...  I still struggle with time management and focusing on one
task at a time until completion.  Working in an environment in which a given
task can be interrupted and superseded at any time is not doing me any favors.
This post will cover the tools I've found to help me out of this situation I've
found myself in.

# [KeepNote](http://keepnote.org)

This tool allows you to create notebooks containing sub-folders and sub-pages.
Information is copied into a notebook primarily from text sources.  Files and
media can be copied in, but instead of in-line inclusion, KeepNote will create a
link to the content.  This is handy, so long as the location of the media or
file doesn't change.

{{< figure src="/images/2013/12-06-1.png" caption="keepnote screenshot" >}}

A caveat I've found with KeepNote is that it doesn't alway do the best with
pasting text from a PDF.  This hasn't been a deal-breaker for me, but it is
something to be aware of.

Information is stored in a sane format on your filesystem; a notebook is a just
a folder containing the data and markup for notes in sub-folders and files.
This makes it simple to back up or copy a notebook to another system as you can
use a one-liner similar to

```bash
$ rsync -av --progress ~/[notebook]/ backup@offsite:/backups/
```

By default, KeepNote will auto-save your notebook every ten seconds, which has
saved me grief several times.  KeepNote aligns very well with the way my brain
sorts information - I find it easy to work with.  I will create a new notebook
in my truecrypt container for each engagement.  Within this notebook, I create a
new folder for each phase of the engagement.  Under each of these folders, I
create a page for each task within the phase.

For keeping text-based notes in a structured format, I think KeepNote is the
tool for the job.

# [Evernote](https://evernote.com)

{{< figure src="/images/2013/12-06-2.png" caption="Evernote Logo" >}}

Evernote took me a while to "get into."  I tested it over a year ago and found
that I just couldn't figure out how it would benefit my day-to-day work.  I
briefly switched over to Google Keep and thought I had found a winner - Keep is
really handy for quick notes like grocery lists, and its user interface is very
attractive - but after a couple of months, I realized it wasn't "heavy-duty"
enough.

Then I met a colleague who used Evernote in a novel way.  Every variant of a
Linux command he used was kept in an Evernote.  Whenever we couldn't quite think
of the correct syntax, he would often pull up the Evernote faster than we would
find it in the man page!  With Spotlight indexing Evernote, answers were never
more than a quick command+space away.

I have since taken to using Evernote to keep track of almost everything I do
professionally.  If I'm working through a unique problem at work, I'll document
my findings and the eventual solution in an Evernote.  Sure enough, I've been
able to quickly solve a problem I've encountered before thanks to this
application.

Evernote is also great at, and constantly improving, its ability to store all
kinds of notes: text, graphics, audio, and more.   All notes are synced to
Evernote's servers and are replicated across my work computer, home gaming
computer, laptop, tablet, and phone.  It's truly changed how I keep track of the
things I do every day.

More than one blog post here has started from an Evernote I've kept about
something I've done on a project.  Some notes have had so much information that
I basically copy/paste and "pretty-up" the formatting before hitting Publish.
Evernote makes things easy.

Bonus: if you mostly take text notes - like I do - Evernote Free takes care of
your needs!  The 60 MB monthly allotment is hardly ever reached, and maximum
note size isn't much of an issue!
