---
title: "Site Update: Cloudflare"
date: "2020-04-16T08:30:00-04:00"
url: "/posts/site-update-cloudflare"
draft: false
categories:
- infosec
tags:
- cloud
- serverless
- cloudflare
- aws
- s3
summary: "This site now uses CloudFlare"
---

The best way for me to learn about a certain technology is to play with it
myself. [CloudFlare](https://www.cloudflare.com/ "CloudFlare") is one such
technology that I have been vaguely aware of, but never quite sure of what it
was. So I decided to move this site to CloudFlare to see how it stacks up with
the current all-AWS deployment (S3, CloudFront, Route53).

> Let me be clear - I have been happy with the CloudFront and Route53 services.
> This move to CloudFlare was only to satisfy an intellectual curiosity, and if
> I'm unhappy with CloudFlare, I'll return to CloudFront and Route53
> without reservation.

So, if you're reading this, then that means the move to CloudFlare was
successful! You can see this site's now using CloudFlare DNS as well with:

```bash
$ dig -t ns chrislockard.net
...

;; ANSWER SECTION:
chrislockard.net.	86400	IN	NS	ali.ns.cloudflare.com.
chrislockard.net.	86400	IN	NS	andy.ns.cloudflare.com.

;; ADDITIONAL SECTION:
ali.ns.cloudflare.com.	3081	IN	A	173.245.58.59
ali.ns.cloudflare.com.	3391	IN	AAAA	2606:4700:50::adf5:3a3b
andy.ns.cloudflare.com.	2305	IN	A	173.245.59.101
andy.ns.cloudflare.com.	2376	IN	AAAA	2606:4700:58::adf5:3b65
...
```

# A note on cookies

I strive for this site to respect your privacy to the fullest extent possible.
My only reservation about CloudFlare after using it for three days is that it
sets the `_cfduid` cookie in your browser. This cookie helps CloudFlare detect
malicious visitors to this website and ***does not allow cross-site tracking of
visitors, does not follow users from site to site by merging various _cfduid
identifiers into a profile, nor does it correspond to any user ID on this
website**

This cookie is solely used to prevent DDoS attacks against this website. For
more information on CloudFlare's cookies, see ["Understanding the Cloudflare
Cookies"](https://support.cloudflare.com/hc/en-us/articles/200170156-What-does-the-Cloudflare-cfduid-cookie-do-
"Information on the cookies Cloudflare sets in the user's browser")
