---
title: "Public Bug Bounty Rules of Engagement"
date: "2019-04-09T16:28:38-04:00"
url: "posts/public-bug-bounty-rules-of-engagement"
categories:
- infosec
tags:
- bug bounty
- pentesting
summary: "I share my experience and lessons learned from operating a public bug bounty."
---

[I wrote some time ago,]({{ relref "/content/2017-10-20-lesson-for-bug-bounty-researchers.md" }}) about my thoughts on
managing a bug bounty program. It's been nearly two years, and I've gone through
the pain of taking a bug bounty public, so I wanted to jot down some thoughts on
what maturing the bug bounty program looks like and some notes for security
researchers participating in bug bounty programs. The good researchers won't
need this advice, and the bad ones likely won't read it, so this is probably
futile, but these things should be shared.

# Bounty Operators

Maturing your bug bounty program by bringing it public is going to cause you
pain. Lots of pain.

* Prepare for many meetings and presentations with management as well as product
  teams to define what a bug bounty is, why it's important, and what their role
  will be once submissions start coming in.
* Prepare to carefully curate your rules of engagement/bounty brief and still
  finding out that you hadn't considered all the angles.
* Prepare for nervous management and product teams that will lead to many false
  starts.
* Prepare to find out just how good your WAF's/MSSP's capabilities are or are
  not.
* Prepare for a tremendous spike in submissions once the program is public.
* Prepare to answer lots and lots of questions.
* If something goes wrong, prepare to feel like you're participating in a
  congressional hearing.
* Prepare to hold your bounty partner liable for the activities of the
  researchers - this may put a strain on an otherwise great relationship.

# Bounty Researchers

* Read the bounty brief/rules of engagement thoroughly and completely before you
  open burp!
* Once you're done reading the bounty brief, read it again!
* If there's something in the brief that you disagree with, initiate a dialog
  with the bounty manager first.
* There are rules imposed in the brief that are there for very good reasons.
  Remember that there can be teams of, sometimes, hundreds of people supporting
  each target you're testing.
* If you fail to abide by the bounty brief, you are no better than an actual
  attacker in the organization's eyes.
* Recognize that there might be just one person triaging your submission along
  with many others within the organization and that their bug bounty
  responsibilities may not constitue their entire portfolio - be patient!
