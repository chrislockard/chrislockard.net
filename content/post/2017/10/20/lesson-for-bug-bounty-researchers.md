---
title: "A Lesson for Bug Bounty Researchers"
date: "2017-10-20T12:00:00-04:00"
url: "/posts/bug-bounty-researchers-doing-it-wrong"
categories:
- infosec
tags:
- bug bounty
- pentesting
---

I'm managing a bug bounty program that has shown tremendous benefit so far.
Several findings have been extremely clever, and I've been fortunate enough to
have good interactions with the vulnerability researchers. However, I've also
had a few unsatisfactory interactions with researchers. This post is directed at
Bug Bounty researchers that do not have much experience in corporate
environments. I think a list of do's and don'ts is appropriate for this
breakdown.

# DO

## Be professional

I appreciate you are likely pulling in good money sitting in your bedroom in a
hoodie exploiting low-hanging fruit. When you interact with a company through a
bug bounty program, be professional. Almost certainly, multiple people from the
business will eventually view your correspondence. You never know what executive
may see your correspondence, and if they don't like what they see, you're not
getting paid.

## Be responsive

Just as it annoys you when you don't hear back from a company you've reported a
bounty to, it's frustrating for the bounty manager when they can't get in touch
with you. Don't ever report a critical issue then disappear.

## Include a high-level overview of the issue in your bounty write-up

The bounty manager must communicate the issue to multiple levels of
stakeholders. Writing an executive summary for your exploit helps ensure the
bounty manager effectively communicates the issue as you reported it.

## Include a detailed technical explanation 

This includes a step-by-step walkthrough to reproduce the issue.

I suspect there are a significant number of bounty managers who aren't
technical. By including all the technical information up front, it saves time
when the bounty manager has to communicate the issue to developers. This is
**extremely** helpful for the bounty manager.

## Include screenshots in your bounty write-up for each step of the exploit

A picture is worth a thousand words.

## Include a video POC

A video is worth a thousand pictures. Especially when the bounty manager
explains esoteric security concerns to developers. 

## Include detailed remediation information for the issue

Include things such as technology-specific remediation advice. For instance, if
you've found rXSS, identify whether it's in a vulnerable JavaScript library or
function that outputs text to the page versus in the dynamic language the page
is written in and present the remediation recommendation accordingly. Copy
pasting "sanitize user input" from OWASP is not helpful to the bounty manager.

## Think through the issue

A good bounty brief will give the researcher some ideas about what the company
considers security relevant. Understand that if the risk is acceptable to the
business, your super l33t proof-of-concept may be casually dismissed. 

## Be Patient

All good things come to those who wait.

# DO NOT

## Spam the bounty manager or email address listed in the company's responsible disclosure statement

Yes, we'd all like for the issue to be triaged, fixed, and rewarded as quickly
as possible, but this **takes time**. If you send multiple updates per day to
the bounty manager, they might assume you are trying to pressure them into
rewarding you before fully understanding the scope of the issue you've reported.
This will immediately cause the bounty manager to question the veracity of your
submission.

## Forget that you're dealing with a business 

In business, security takes a backseat to the product or service. This means
processing your request takes time and effort by one or more employees.

It's possible all the employees required to remediate the issue aren't aware of
each other. In some organizations, it takes time to determine who owns the
vulnerability and who is responsible for implementing a fix. It's possible that
the bounty manager is discovering who these people are. 

## Forget that the bounty manager has other job responsibilities 

I do not spend eight hours a day monitoring our bounty program to manage
submissions. Like several other items in this post have pointed out, it **takes
time** to get vulnerabilities triaged appropriately.

## Think the bounty manager owes you something

You may have found a clever vulnerability that makes you think you're special.
Running a bounty program has shown me that there will always be someone else
that can uncover the same issue. If they are better at communicating with the
bounty manager and act appropriately, they will get the business, not you.

## Disclose the vulnerability publicly without consent

The company is devoting the time they can to remediating the issue you've
identified. If they're not working on your time table and you decide to disclose
publicly, then be prepared for any litigation that comes your way. Gently remind
recalcitrant companies about the issue (see the first item under Do NOT). If you
don't get a response, then find another company suffering from the same issue
and report it to them. 
