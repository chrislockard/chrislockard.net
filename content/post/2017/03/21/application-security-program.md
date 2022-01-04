---
title: "Developing an Application Security Program"
date: "2017-03-21T12:00:00-04:00"
url: "/posts/application-security-program"
categories:
- infosec
tags:
- BSIMM
- analysis
- appsec
---

Since my last post, I've left my position with the consultancy. I'm now working
for a medium-sized corporation in a senior application security role. One of my
many tasks is to contribute to the development of an Application Security
program. This post will serve as my thoughts on setting up an AppSec Program.

# Measuring current performance

The [Building Security In Maturity Model (BSIMM)][BSIMM] is a study of existing
software security initiatives used by 95 companies of varying size across six
verticals. In my organization, there is a lack of movement without consensus.
This endeavour has taught me that the BSIMM's major value has been the influence
it weilds by virtue of including this swathe of companies.

The BSIMM is the measuring stick I've pitched to management as the tool we
should use to evaluate where our AppSec program stands. Once we've discussed
where the program stands, we will employ a more prescriptive framework to help
us enable change.

To get started, I duplicated the BSIMM scorecard. You can find a copy of this
here for use in your organization:

[BSIMM Scorecard][Scorecard]

With this, I sat down with the security stakeholders and we had a round-table
discussion going over each activity. For each activity, we weighed in:

* Is this an activity that we currently perform in our organization?
* Is there a repeatable process surrounding it?
* Is this process well documented?

This session was immediately valuable, because, for the first time, the security
team understood what activities we were and weren't performing. This information
was captured and will be used to decide how to move the AppSec program forward.

# Moving the AppSec program forward

While the BSIMM serves as a good measuring stick, it doesn't provide much
guidance for implementing the activities we may not currently perform or that we
underperform. My efforts are currently focused on determining a good framework
to help us move forward. I'm currently evaluating [Microsoft's SDL][SDL] and
[OWASP's SAMM][SAMM].

[BSIMM]: https://www.bsimm.com
[SDL]: https://www.microsoft.com/en-us/sdl/default.aspx
[SAMM]: https://www.owasp.org/index.php/OWASP_SAMM_Project#tab=Main
[OWASP]: https://www.owasp.org/
[Scorecard]: https://s3.amazonaws.com/chrislockard.net/files/BSIMM7-Scorecard.xlsx
