---
title: "Set Cloudflare HTTP Headers in Hugo"
date: 2025-02-19T12:00:00-05:00
# weight: 1
# aliases: ["/first"]
categories:
- privacy
- infosec
tags:
- hugo
- cloudflare
author: "Chris"
# author: ["Me", "You"] # multiple authors
showToc: true
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Cloudflare HTTP headers made easy with Hugo"
#canonicalURL: "https://canonical.url/to/page"
disableHLJS: true # to disable highlightjs
disableShare: false
disableHLJS: false
hideSummary: false
searchHidden: true
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/chrislockard/chrislockard.net"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---
In a [previous post]({{% relref "/post/2020-10-09-security-headers-cloudflare-workers.md" %}}) I wrote about how to set Cloudflare HTTP headers using Cloudflare Workers. In this post, I'll show you how to do the same thing using Hugo.

Thanks to [Grok](https://grok.com), I learned a nifty trick for setting Cloudflare HTTP headers in Hugo. Instead of using Cloudflare Workers, you can use Hugo's built-in support for setting HTTP headers.

To do so, create the file `static/_headers` with your header content following [Cloudflare's format](https://developers.cloudflare.com/pages/configuration/headers/). As an example, here's the content of this site's `static/_headers` file:

```
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: deny
  Referrer-Policy: no-referrer
  Feature-Policy: microphone 'none'; payment 'none'; geolocation 'none'; midi 'none'; sync-xhr 'none'; camera 'none'; magnetometer 'none'; gyroscope 'none'
  Content-Security-Policy: default-src 'none'; manifest-src 'self'; font-src 'self'; img-src 'self'; style-src 'self'; form-action 'none'; frame-ancestors 'none'; base-uri 'none'
  X-XSS-Protection: 1; mode=block
  Strict-Transport-Security: max-age=300
```

When Cloudflare builds the site, it will automatically include these headers in the response. No additional configuration is required.

Verify your headers with curl:
```
curl -I https://www.chrislockard.net/
```
