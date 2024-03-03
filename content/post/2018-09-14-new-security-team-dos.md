---
title: "The new face of the security team DoS"
date: 2018-09-14T14:00:42-04:00
url: "/posts/new-face-of-security-team-dos"
categories:
- infosec
tags:
- bug bounty
- responsible disclosure
- spam
- dos
---

[Nearly a year ago,]({{% relref "/post/2017-10-20-lesson-for-bug-bounty-researchers.md" %}}) I wrote about an
emerging trend I observed with some of the bounty researchers I was interacting
with. This screed can be considered an extension of that article.

There an emerging trend I'm noticing - I've been receiving more messages like
the following:

> Hey , I found Security Vulnerability in your web application ,which can damage
> site as well as users too.For security purpose can we report vulnerability
> here,then will i get bounty bounty reward in PayPal or Bitcoin for Security
> bug ?

This message bears the hallmark of an opportunist: _I have potential leverage
over you, now I expect payment to make this go away._

This message was delivered to the customer support address where I work on a
Friday afternoon. Because we don't yet have a responsible disclosure message on
our website, this resulted in the passage of several emails that unnecessarily
raised concern among several teams. I eventually took possession of the issue,
and resolved it by inviting the user to our bug bounty program. After this
issue, I'm confident the voices opposed to having a responsible disclosure
statement on the web site will be quieted. We would be able to avoid the mild
disruption and save time.

This incident has me slightly concerned. This one message consumed a ballpark of
1 man hour combined between all of the people involved. What if we were to
become inundated with such messages? Is the increased time consumption linear?

These spammish messages are the result of the sea change in vulnerability
disclosure that's been slowly gripping the industry over the past three years.
The increasing acceptance of vulnerability submissions and the accompanying
prevalence of bug bounty programs is *absolutely* an overall positive for our
industry and for the security of products and services. I am 100% for bug
bounties and responsible disclosure. These types of messages are a side effect
of this attitude change, however.

When individuals - who may or may not be security researchers, and who may or
may not be spammers - face less fear of legal recourse for reporting "security
vulnerabilities" and when the socially accepted response to disclosure is
reward, I think the opportunity arises for a new potential threat to security
teams: the flood of false reports.
