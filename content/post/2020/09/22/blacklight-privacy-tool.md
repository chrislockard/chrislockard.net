---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Blacklight Privacy Tool"
subtitle: "Shine light on website tracking practices"
summary: ""
url: "/posts/blacklight-privacy-tool"
authors: []
categories: 
- privacy
tags: 
- blog
- blacklight
- surveillance capitalism
date: 2020-09-22T16:45:00-04:00
lastmod: 2020-09-22T16:45:00-04:00
featured: false
draft: false
showtoc: true
# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Today on my [Mastodon][fosstodon] feed, several folks were discussing a new tool
by [TheMarkup][themarkup] called [Blacklight][blacklight]. This tool is billed
as a "real-time website privacy inspector" that showcases the ad and tracking
tech deployed by a website. 

I shared this tool with several colleagues and it engendered a stimulating
conversation surrounding company commitment to privacy. I argued during this
conversation that it would be worse for a company to claim to value
customer privacy and then have Blacklight reveal otherwise, than to have made no
such claim in the first place. 

For example, Apple has made the claim that ["Privacy is a fundamental human
right"][appleprivacy]. Their [blacklight report][appleblacklight] shows that
Apple at least doesn't employ third-party tracking on their homepage. If they
had tracking enabled - and it's possible they have first-party tracking that
this tool doesn't detect - then that would look worse than a generic company
with loads of tracking on their website. While it doesn't excuse the tracking
performed by this example company, my argument was that customers would lose
more trust in apple because they were hypothetically lying about their respect
for privacy.

[Customers want privacy and it is good for business.][forbes] [Customers are
demanding punitive action against companies that violate their
privacy.][bloomberg] It makes sense to honor customer privacy from a business
standpoint, but more importantly from a moral standpoint.

It's worth pointing out that this tool doesn't provide novel information for
users who've been using an [ad-blocker][ublock], [script-blocker][noscript], or
[similar tool][umatrix] for years. However, it does provide the capability to
link to reports of these sites to users who do not use these tools and may not
be aware of how pervasive surveillance capitalism is online.

If you're unaware of the pervasiveness of online tracking, please enjoy using
this tool to uncover the trackers used by your favorite websites. 

# A Call to Action

Please share the results of sites you investigate with your friends and family!
Spread the word about the trackers infesting the web. This is a pernicious
problem that will only be solved once a critical mass of people become aware of
the issue.


[fosstodon]: https://fosstodon.org
[themarkup]: https://themarkup.org
[blacklight]: https://themarkup.org/blacklight/
[appleprivacy]: https://www.apple.com/privacy/
[appleblacklight]: https://themarkup.org/blacklight/?url=apple.com
[forbes]: https://web.archive.org/web/20200623171357if_/https://www.forbes.com/sites/blakemorgan/2020/06/22/50-stats-showing-why-companies-need-to-prioritize-consumer-privacy/#129c188837f6
[bloomberg]: https://web.archive.org/web/20200920073339/https://www.bloomberg.com/news/articles/2020-09-18/facebook-accused-of-watching-instagram-users-through-cameras
[ublock]: https://github.com/gorhill/ublock
[noscript]: https://noscript.net/
[umatrix]: https://github.com/gorhill/umatrix
