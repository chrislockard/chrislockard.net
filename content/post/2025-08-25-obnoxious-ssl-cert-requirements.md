---
title: "SSL Certificate Requirements are Becoming Obnoxious"
date: "2025-08-25T13:15:39-04:00"
url: "posts/ssl-cert-requirements-obnoxious"
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
description: "SSL requirements are quickly becoming obnoxious."
disableHLJS: true # to disable highlightjs
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
I am responsible for approving SSL certificates for my company. I've developed a
process over the past couple of years that works well. My stakeholders
understand their roles and responsibilities and put up a minimal amount of fuss
as I review and approve each cert. What started out as a quarterly or
semi-monthly task has become a monthly-to-weekly task depending on when our
certs are expiring.

I appreciate the amount of trust put into certificates and understand that they
are a critical component of digital security. But this 💩 is getting out of
hand.  When certificates underpin nearly all digital security, including VPNs,
WiFi, Email, Websites, APIs, and more, increasing the administrative burden of
managing them will have diminishing returns.

And, I think it's going to push organizations away from traditional
Certificate Authorities (CAs) in the long run.

## Validation Mechanisms

Our certificate issuer used to allow a number of handy validation methods.

In 2021, [they announced][digicert2021] that file-based domain validation would be
disallowed for wildcard certificates. When used for non-wildcard certs,
file-based domain validation would be required for every individual SAN/FQDN.
This was a minor annoyance, because at the time we had some automation that
would allow us to renew certs with minimal fuss.

File-based domain validation *was* less secure; one dangling DNS record or
webserver mis-configuration is all it takes to hijack a certificate. (I
recommend any organization leveraging PaaS platforms like AWS or GCP might want
to consider a thorough DNS inventory and cleanup if they haven't recently; you
may be surprised by what you find.)

The remaining domain control validation (DCV) methods for my organization have
been reduced to two options: DNS TXT recrods and email-based validation. One of
these is completely useless: we don't set up email addresses for every possible
subdomain, so email-based validation may as well not exist when we need to
update a certificate for `test.lab.corp.example.com` because there is no
`webmaster@test.lab.corp.example.com`. But, it's not just validation methods.
There are new defenses requiring more stringent validation.

DNS validation is a decent and secure option in an organization where DNS
management access is tightly controlled. I don't generally have a problem with
it as it's a straightforward and small time sink to implement.

## Defending against Hijacking and Spoofing

A recent change aims to thwart BGP hijacking and DNS spoofing attacks. Starting
next month, DigiCert (and presumably other CAs) will require [Multi-Perspective
Issuance Corroboration (MPIC)][digicertmpic] checks.

On the face of it, this seems like a good idea. MPIC requires CAs to perform DCV
from two or more global vantage points (RIR regions). This should dramatically
reduce the risk of mis-issuance via BGP attacks. But I wonder how many
organizations segment access to their apps based on geography that this will
impact. I *also* wonder how many organizations have had certificates mis-issued
due to BGP hijacking.

{{< callout type="info" title="A Note on Timing" emoji="ℹ️" >}}
A particular annoyance I've encountered is the notification messages for these
potentially breaking changes. In several cases, I've received notification of an
upcoming major change (like MPIC) just a few weeks before it will take place.

Communicating these major changes with such short timeframes is *extremely*
damaging to the trust and relationship I've built with my stakeholders. I feel a
combination of guilt and frustration when I have to Slack a group of people I
*know* are swamped and sheepishly say "*Hey, there's a potentially huge breaking
change happening soon. Y'know, for security. Please help me make sure we aren't
going to break anything when this goes live.*"
{{< /callout >}}

Yes, this will improve the warm fuzzy security feeling we all want at night, but
how much *actual* risk is this requirement mitigating? The email notifications
telling me I have weeks to implement this change make vague assertions of the
risks, almost like they are trying to justify a thought exercise. Or an
[academic theoretical][princeton] (which itself acknowledges "no study has yet
to measure the effectiveness of these attacks on real-world certificate
authorities")

Although certainly not exhaustive, the [Wikipedia page on BGP
hijacking][wikibgp] lists one example of a BGP hijack resulting in a mis-issued
certificate, and that was for a South Korean cryptocurrency company in 2021.
Total loss (according to Wikipedia): $1.9m USD.

Huh. I *wonder* if industry is going to lose more than $1.9m implementing MPIC?
🤔

But the absolute worst change is coming, incrementally, over the next three
years.

## Validation Lifetimes

The most obnoxious change is the ongoing shortening of the certificate
validation window. Sure, letting certificates stay valid for 825 days was a bit
much. Okay. I get that. 10 year validation periods? Totes extreme.

Today, certificates are valid for 397 days or around 13 months. This is actually
a decent compromise between security and operational overhead, because it
ensures rotation without being too burdensome to schedules and AOP. The most
significant issue is when many certificates are grouped together on a single
expiration date, but that can be managed easily enough with some planning.

But by March 15, 2029, the maximum lifetime for an SSL certificate will be just
**[47 days][digicert47days]**.

47 days. *47 days!*

Maybe AI will have made my job redundant by then and this will all be ChatGPT's
problem. But I doubt it.

I'm sure in the Ivory Tower or the companies with extremely well-funded and
over-staffed security teams, this is no big deal. "But of course we should do
this, it's just a little more work for a team of 50 engineers with dedicated
developers!" Should I be grateful they didn't decide on 47 hours instead?

I am grateful for a multi-year ramp-up to this change. But for the rest of us
treading water and trying to make significant incremental change, this does
nothing but dictate our roadmap for the next three years.

## Money Changes Hands

So, with all of these challenges facing us, what is our organization to do? I'm
sure CAs like DigiCert are expecting to make more money off of us as we struggle
to implement these changes. Indeed, there are CA consulting services that will
offer to "bring PKI and DNS together to validate domain ownership and issue
certificates without manual DNS record updates".

For a fee, of course. By reaching out to the sales team, of course.

What I'm not sure the CAs are considering is that we will instead move as much
of our certificate business off of them as possible.

Any platforms that offer or include certificate management bundled with the
actual services we pay for will win our business by default. Even if there's
incremental cost for so doing, we will gladly pay the platform to manage
certificates on our behalf since that frees up several expensive engineers from
that responsibility.

## So What?

These validation tweaks and shrinking lifetimes are interconnected and they
amplify each other's obnoxiousness. Each one, academically, makes sense for
improving security. However, I can't help but wonder if the CA/Browser Forum is
aware of the cumulative impact of these changes on under-resourced organizations
or overworked IT departments. Maybe they are and they don't care. But the CA
vendors should care, because I think they will lose business over incremental
changes like these.

My organization will almost certainly move much of our certificate business to
individual platforms or to free CAs like [letsencrypt][letsencrypt] with
automation either taken care of for us or easily implemented.

[ACME][acme] might be a solution to some of these challenges, but it's not
problem-free. [Which client][acmeclients] do we use? Which resource-starved team
will manage the client and the infrastructure it needs? It will need time to
undergo code review and/or supplier review if it's sold by a company. There will
be a requirement for secrets management. There will be a need for monitoring and
alerting. It's not as painless as the certificate approval workflow I have
now.

Are these changes making the Internet more secure? Maybe. Probably. But it's not
obvious to me that the trade-off is worth it if the work needed to manage
certificates prevents project work from getting done.

What is obvious to me is that my stakeholders and I are hurrying to offload
certificate management to our vendors and platforms and not to our CA.

[digicert2021]: https://knowledge.digicert.com/alerts/domain-validation-policy-changes-in-2021
[digicert47days]: https://www.digicert.com/blog/tls-certificate-lifetimes-will-officially-reduce-to-47-days
[digicertmpic]: https://www.digicert.com/blog/mpic-for-digital-certificates
[letsencrypt]: https://letsencrypt.org/
[princeton]: https://www.princeton.edu/~pmittal/publications/bgp-tls-hotpets17
[acme]: https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment
[acmeclients]: https://letsencrypt.org/docs/client-options/
[wikibgp]: https://en.wikipedia.org/wiki/BGP_hijacking
