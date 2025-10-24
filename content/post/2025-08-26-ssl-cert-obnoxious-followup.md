---
title: "Follow up to SSL Certificate Requirements are Becoming Obnoxious"
date: "2025-08-26T15:56:27-04:00"
url: "posts/ssl-cert-obnoxious-followup"
categories:
- InfoSec
tags:
- crypto
- certs
author: "Chris"
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Followup to my post about SSL certificate requirements becoming obnoxious."
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
I submitted [Yesterday's post]({{% relref
"2025-08-25-obnoxious-ssl-cert-requirements.md" %}}) to
[HackerNews](https://news.ycombinator.com/item?id=45025835) and it got a fair
amount of traction.

I was trepidatious about posting it there, because I have never submitted my
work to such a large platform before. It feels good to have done so, and I urge
anyone reading this to spread their work as far and wide as possible. As James
Somers said: "[More people should
write](https://jsomers.net/blog/more-people-should-write)". It was amazing to
see the comments and discussions that ensued, and I'm grateful to the several
thousand people who read that post and the few hundred who commented on it.

There were a few common themes in the comments that are worth addressing:

## Get With the Times, Granpa

A fair few commenters suggested something along the lines of "get with the
times." They're not entirely wrong.

I wrote yesterday's post in frustration, and realized after reading these
comments that I should indeed look at the upcoming SSL certificate lifetime
decrease as an opportunity to eliminate the tech debt that has built up around
this current process.

I work on and manage a small but mighty SecOps team at a mid-sized company. We
embrace automation wherever it makes sense, and automating the SSL certificate
lifecycle makes eminent sense. The process I inherited for approving
certificates is manual and instead of writing about it, I should be working to
improve it. This will be a good exercise in task/project management and
prioritization.

Some comments suggest that one of my main points could have been emphasized
better. I suggested that the CAs aren't going to reap the benefits of this
automation that they may expect, especially if part of the automation involves
off-loading certificate issuance to platforms like AWS, GCP, or Salesforce.
I don't know enough about the CA business to know if they care about this. I can
think of a few reasons why they might not.

## It Works in my Environment, so it Must be Fine

Many commenters suggested that this is an easy problem to solve and that it must
be a skill issue on my part. I disagree, but I see a lot of myself in these
comments, so I have taken them to heart. I've also been tempted to dismiss the
trials of others because I'm not facing them myself.

## SSL Certificates are About Control

[One commenter](https://news.ycombinator.com/item?id=45026564) pointed out that
SSL certificates are a form of platform control. This is evocative of one of my
favorite privacy writers, [Bob Leggitt](https://backlit.neocities.org), who has
[written on this topic
before](https://backlit.neocities.org/weaponsing-the-non-commercial-web).

If the Web is a platform, then it certainly seem to me as though Google has done
the most to capture it. I don't like this web. I miss the old web, full of
personality, creativity, and website counters. I don't like the soulless new
web, and it seems [I'm not
alone](https://news.ycombinator.com/item?id=45026189). Good.

## Still Cooking

[One commenter noted](https://news.ycombinator.com/item?id=45026351) that
security is a process, not a destination. I've been known to say this myself, so
I thank them for reminding me.

Security is indeed a process, and process can be improved. I think this article
produced a lot of good discussions and I'm grateful for that. I have more
thoughts on these topics, and this experience, but I want to ruminate a bit more
before writing about them.

In the meantime, I want to thank everyone who read and commented on my post. I
appreciate your time and many insights, especially those that challenged me and
opened me up to new possibility. ❤️
