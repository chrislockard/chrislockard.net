---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Aws S3 Cloudfront Cloudflare Https"
subtitle: "Upgrading security to allow for HSTS and full(strict) cloudflare TLS"
summary: "This post covers increasing security for a static site hosted on s3 using cloudfront and cloudflare"
url: "/posts/aws-s3-cloudfront-cloudflare-https"
authors: []
categories:
- infosec
tags:
- aws
- s3
- cloudfront
- cloudflare
date: 2020-10-02T10:21:19-04:00
lastmod: 2020-10-02T10:21:19-04:00
featured: false
draft: false

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
projects: ["aws-secops"]
---

[A while back]({{ relref
"/content/2020-04-17-til-cloudflare-s3-security.md"}}) I described how I
secured the origin (AWS S3) of this website via bucket access policy and how
this mitigated the four threats I was concerned with. It's bothering me that I
don't have the content encrypted between AWS and Cloudflare, so this post sets
out to highlight how I've enabled that. I've found this topic to be not very
well documented, but I did find [this post][sambecker] by Sam Becker as a
resource.
 
# Refresher - Current Config

As I previously wrote, this is the current setup for this site:

{{< figure src="/images/2020/04-17-4.png" caption="" >}}

## S3

This site is stored in an s3 bucket called `www.chrislockard.net`. This bucket has
[static website hosting][awsstatic] enabled. There's a second bucket,
`chrislockard.net` that redirects to this bucket and serves requests made to the
naked `https://chrislockard.net` domain.

## CloudFlare

CloudFlare manages the DNS records for this site and its TLS settings (that is,
the encryption of traffic between your browser and the content cached on
CloudFlare).

# Enter CloudFront

[Back in 2016]({{ relref "/content/2016-10-03-static-sites-2016-update.md"}})
I wrote about deploying this blog via CloudFront. I had just discovered the
awesome [AWS Certificate Manager][awsacm] and today this will
be making a return along with CloudFront to ensure that this blog is delivered
entirely via HTTPS, from source to destination. 

I am re-using the CloudFront distribution I previously created back when I
switched to using it for this site in 2016. I won't recap the process for
creating that here, see [Sam Becker's Post on Medium][sambecker] for a guide on
configuring this part. Here are some refresher notes:

* Set the CloudFront origin to the S3 website endpoint provided in the S3
  bucket's __Static website hosting__ card. This should be of the form
  `bucketname.net.s3-website-us-east-1.amazonaws.com`
* Distribution delivery method should be set to `Web`
* Distribution alternate domain names (CNAMEs) should include the naked
  `example.com` and site subdomain `www.example.com`

[sambecker]: https://medium.com/@sambecker/getting-cloudflare-cloudfront-s3-to-cooperate-over-strict-ssl-f70090ebdec
[awsstatic]: https://docs.aws.amazon.com/AmazonS3/latest/dev/WebsiteHosting.html 
[awsacm]: https://aws.amazon.com/certificate-manager/
[advancedweb]: https://advancedweb.hu/how-to-use-a-custom-domain-on-cloudfront-with-cloudflare-managed-dns/
[judge]: https://community.cloudflare.com/t/cloudflare-s3-full-ssl-new-version/195651/2
