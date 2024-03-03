---
title: "Make a connection"
date: "2015-09-18T12:00:00-04:00"
url: "/posts/make-a-connection"
categories:
- introspection-meditation
tags:
- collaboration
- analysis
- l0pht
- complexity
---

This post was inspired by a client who came to me and said "I do not understand
all of these findings, can you explain them to me?", referring to my web
application penetration test deliverable. We spoke for an hour, as I described
the findings to him. I corrected him when his understanding was shaky,
and I confirmed where his understanding was solid. He had a development
background, and was studying for a security certification, but he was managing a
large security project for a well-known company and I was surprised to learn he
was a security newbie. At the end of our conversation, he thanked me and said
"Now I understand, and I'll make sure my manager does as well!"

This is what we should strive to hear from our clients.

I appreciate that the client claimed ignorance and asked for clarity; admitting
ignorance is difficult. When clients don't understand our deliverables, they
won't know how to fix the issues we've identified. This problem can become
[turtles all the way down][turtles] (or up) if the client's manager does not
have any better understanding, or their manager's manager, etc.

This lack of understanding is what led us to the situation we're in now:
information security has become a multi-billion dollar industry based around
security product and consulting companies that still haven't solved the simple
problems. Business stakeholders still don't place an appropriate emphasis on
security. Watch this l0pht congressional testimony (millenials and younger:
consider this a history lesson):

{{< youtube VVJldn_MmMY >}}
 
When older hackers complain about "the same old stuff," remember this video. It
is still 100% relevant.

Explaining complex ideas to clients requires an understanding of the topic.
Complex ideas are best explained such that a five-year-old would understand. For
example, if you're explaining Remote Code Execution, you could point the client
to the Wikipedia article, or you could explain like so:

>  A program is a set of instructions like "Go here, go there". Remote code
>  execution is when I tell your program to "go over here" instead of "go there"
>  from across the Internet.

If this description sounds condescending, I disagree: as someone wiser than me
said  - "If you can't explain it simply, you don't understand it well." We have
to explain complicated concepts to business owners who may be using our
deliverables to make significant changes in their environment. Moreover, we want
to be the spark that ignites the flame of knowledge that our clients can use to
go forth and increase their security posture.

This is a plea: make the effort to connect with your clients. Exchange more than
pleasantries during status calls - mention the latest security headline, or
inform them of some project you're working on, or a tool you use to do something
cool. Pique their interest and tell them how you pwned another player in their
space. Make them care about how they can build a resilient
system/network/program/etc.

Maybe you'll spark an interest in them that will cause them to attend an OWASP
meeting, or their local hacking group. Maybe they'll go on to develop the next
killer tool that will benefit you on a future engagement.

Who knows, maybe in the next 17 years, the landscape will have changed enough so
that l0pht's congressional testimony won't still be 100% relevant.

[turtles]: https://en.wikipedia.org/wiki/Turtles_all_the_way_down
