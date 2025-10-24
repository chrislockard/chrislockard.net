---
title: "Creator Experience and Privacy"
date: 2025-07-31T05:30:00-05:00
url: "/posts/cx-and-privacy"
categories:
- Privacy
tags:
- blog
- workflow
author: "Chris"
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Balancing user privacy with content creator experience on the modern web is a worthy challenge."
disableHLJS: true 
disableShare: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
---
## A Nerve Was Struck

Since [yesterday]({{% relref "/post/2025-07-30-htmlhobbyist.md" %}}), I've been
thinking about how content creators can streamline their workflow while
maximizing the privacy of their consumers. Since this website is the only
content I produce, I'm focused on text content more than video or podcast.

I am captivated by the thought of reverting this site to a basic setup of plain
HTML and CSS, hosted someplace like [GitHub Pages](https://pages.github.com/) or
[Neocities](https://neocities.org/). This idea harkens back to my young teenage
years, writing HTML by hand and uploading it to
[Geocities](https://en.wikipedia.org/wiki/GeoCities). Those were simpler times
that fill me with a great sense of warmth and nostalgia and that's the allure to
go back.

I'm also hooked on the privacy aspect of this idea. Just the user's
browser, and structured markup. No tracking, no scripts, no junk. Okay, maybe
some junk[^1]

But much has changed personally and technologically since then. I have more
demands on my time now, and the responsibilities of my life mean I don't have
the time to hand-craft my own HTML and so I need shortcuts that
will let me focus on the content instead of the infrastructure or markup.
[HTMLHobbyist](https://htmlhobbyist.com/) highlights how simple and
cost-effective hosting a site is today, and I appreciate that. But there is more
to hosting a site online than just where my HTML files live.

## An Unsafe Space

Today's web is different than Web 1.0. It is far more dangerous for web surfers
and content creators alike.

Web surfers must worry about websites hosting malicious code that can infect their
devices, phishing threats from sharing their email address, scams and spam, low
quality content, and more. Many of these threats were around in the web's early
days as well, but they have increased in sophistication, automation, and
frequency as more of the world has come online.

Content creators have to worry about securing their websites against attackers,
protecting their users' data (to comply with laws that didn't exist when the web
was young), and, increasingly, protecting their content against unscrupulous AI
that scrapes and reuses it without permission.

It's simple to stand up a website today, but the complexity and attack surface of
the web has changed enough that content creators trying to stay safe and
maintain a modicum of user privacy must be mindful of how they operate.

## Privacy Considerations for Content Creators

It is this consideration that I've pondered since yesterday and continue to as I
think aloud in this post. [As I state](https://www.chrislockard.net/privacy/),
I am privacy conscious. Privacy aware. Perhaps even privacy *obsessed*. I
agonize over [which browser I should
use](https://www.chrislockard.net/posts/fingerprinting-privacy-brave-vs-firefox/),
which search engine respects me the most, and [how trustworthy the websites I
visit are](https://www.chrislockard.net/posts/blacklight-privacy-tool/). And so
I think about how to share my thoughts and ideas online in a way that doesn't
harm the people consuming them.

For instance, since this site is hosted on [Cloudflare
Pages](https://pages.cloudflare.com/), I know that a sizeable portion of any
privacy-minded audience I have will be upset by this.  However, the ease of use
and protection this service provides me drives how often I
produce content here. My workflow is simple: I write and edit a post in
Markdown, commit it to [this site's GitHub
repository](https://github.com/chrislockard/chrislockard.net), and Cloudflare
Pages builds and deploys it automatically. This is a great balance of simplicity
and efficiency that allows me to focus on my writing and not infrastructure.

Additionally, Cloudflare provides security for my readers and this site.
Cloudflare encrypts all communications between the reader's browser and the
Pages server hosting this content. Increasingly important, CloudFlare also
provides gratis [AI Bot Scraping
protection](https://developers.cloudflare.com/bots/concepts/bot/#ai-bots). I
want humans to consume my content, not AI bots. If I were to host this site on
my own server, I would not be able to shield my content from these unscrupulous
scrapers.

So, I feel obligated to trade off some privacy protection for my readers to
enable myself to have readers at all. Perhaps I'm being myopic, but I don't
think that I am. Even on a self-hosted web server serving up static content,
users would still be vulnerable to traffic snooping my hosting provider might
do. Or, *if I was malicious*, I could directly track my readers' behavior myself
with server-side logging they were oblivious to.

What is scarier: the prospect of trusting Cloudflare not to to snoop on you or
the prospect of trusting a small-time content producer not to snoop on you?  

## A Conclusion? I'm not sure

I think what I'm trying to say is there will always be a trade-off of using
the modern web to share content. The toothpaste is out of the tube and we can't
go back to the innocent days of the early web, even if producing content like
HTML Hobbyist makes it appear that way. I want to consume content online without
worrying about my privacy, but that's impossible these days.

What's important is for content creators and consumers to be aware of these
trade-offs so they can make informed decisions and so that consumers can demand
more from the producers they frequent.

In the spirit of HTTP Hobbyist, I would love to see web sites lean more on HTML
and CSS than JavaScript or other technologies that add unnecessary complexity.
Content creators should simplify their tech stack and eliminate user tracking.
If this means hand-writing artisanal HTML, then great! But I urge content
creators to make conscious decisions to reduce privacy and security threats
to their consumers every time they create.

[^1]: I'm looking at you, "under construction"" GIFs! And .midi files on auto-loop. 🙄
