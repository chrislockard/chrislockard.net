---
title: "How to Securely Configure CloudFlare with S3"
date: "2020-04-17T00:01:00-04:00"
url: "/posts/secure-cloudflare-s3"
draft: false
categories:
- infosec
tags:
- cloud
- aws
- serverless
- cloudflare
summary: "This post covers how to secure an S3 bucket serving content through Cloudflare"
---

# The Setup

[In my last post]({{< relref "/content/post/2020/04/16/update-cloudflare-s3.md">}}), I
detailed my move to [CloudFlare](https://www.cloudflare.com/). CloudFlare took
the place of CloudFront and Route53 in my previous configuration:

{{< figure src="/images/2020/04-17-2.png" caption="This site's architecture just got even simpler! (diagram from https://app.diagrams.net/)" >}}

CloudFlare is a Content Delivery Network (CDN) that caches traffic from an
origin - in my case [AWS S3](https://aws.amazon.com/s3/). Traffic between the
browser and CloudFlare is encrypted. Traffic between CloudFlare and the origin
may also be encrypted - either with "Full" encryption (CloudFlare terminology
for an origin with a self-signed certificate) or "Full-Strict" encryption
(Cloudflare terminology for an origin with a certificate issued by a trusted
intermediary or root CA)

I consulted several guides during this re-architecture, primarily [this one from
CloudFlare](https://support.cloudflare.com/hc/en-us/articles/360037983412-Configuring-an-Amazon-Web-Services-static-site-to-use-Cloudflare
"CloudFlare guide to using S3 as an origin"). After following that guide, I had
a setup that resembled this:

{{< figure src="/images/2020/04-17-3.png" caption="CloudFlare only provides in-transit encryption to the browser in my architecture" >}}

Here, the connection between the user's browser and CloudFlare is encrypted
with TLS (1.3 for supported browsers - yay CloudFlare!). 

## Security!

I want to minimize several risks introduced by this architecture:

1. Unintended disclosure of information stored in my origin,
2. In-flight modification of data between CloudFlare and my origin,
3. Denial of Service/Distributed Denial of Service attacks against my origin,
4. Resource exhaustion attacks designed to rack up my AWS bill.

Notice the connection between CloudFlare and S3 is unencrypted in the diagram
above. When configuring an S3 bucket to serve static content as a website, S3
creates a publicly-accessible endpoint over plaintext HTTP. Anyone with this
endpoint can access it directly, bypassing much of the protection offered by
CloudFlare.

S3 doesn't offer TLS encryption when configured as a static content server, so
it isn't possible for me to enable "Full" encryption in CloudFlare. In any case,
encryption is only going to help me mitigate the first two risks, what about the
second two?

<a name="bucketpolicy"></a>
# Enter S3 Bucket Policy

Access Control to the rescue!

[S3 Bucket
Policies](https://docs.aws.amazon.com/AmazonS3/latest/dev/example-bucket-policies.html)
allow for fine-grained access control to S3 objects. As far as I'm aware, bucket
policies are the most tightly-bound security control to an object in S3 - as
we'll soon see, they can even override other S3 security settings!

I want my origin's bucket policy to allow read access to CloudFlare so it can 
serve content and restrict all write access except for my blog publishing
account. Although useful to learn what their current public IP addresses are,
CloudFlare's tutorial omits the policy to make this so.

I present the bucket policy (with some slight privacy modifications) used to address the
four risks previously identified:

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "CloudFlareReadGetObject",
            "Effect": "Allow",
            "Principal": {
                "AWS": "*"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::www.example.com/*",
            "Condition": {
                "IpAddress": {
                    "aws:SourceIp": [
                        "2400:cb00::/32",
                        "2405:8100::/32",
                        "2405:b500::/32",
                        "2606:4700::/32",
                        "2803:f800::/32",
                        "2c0f:f248::/32",
                        "2a06:98c0::/29",
                        "103.21.244.0/22",
                        "103.22.200.0/22",
                        "103.31.4.0/22",
                        "104.16.0.0/12",
                        "108.162.192.0/18",
                        "131.0.72.0/22",
                        "141.101.64.0/18",
                        "162.158.0.0/15",
                        "172.64.0.0/13",
                        "173.245.48.0/20",
                        "188.114.96.0/20",
                        "190.93.240.0/20",
                        "197.234.240.0/22",
                        "198.41.128.0/17"
                    ]
                }
            }
        },
        {
            "Sid": "AllowBlogPublish",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::012345678912:user/mybloguploadaccount"
            },
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::www.example.com/*"
        }
    ]
}
```

> I want to point out that specifying Principals in S3 bucket policies requires
> the use of an extra block declaring the AWS object to grant permission to. This
> tripped me up as I'm not used to specifying Principals in this manner using IAM
> policies for other services.

This policy allows me to turn on [Block Public
Access](https://docs.aws.amazon.com/AmazonS3/latest/dev/access-control-block-public-access.html
"S3 Block Public Access") and restrict access to the S3 endpoint and objects to
all users except CloudFlare.

Here's what happens when an object is requested directly:

{{< figure src="/images/2020/04-17-5.png" caption="Intentional 403s are just as satisfying as unintentional 403s are infuriating!" >}}

Some things to note:

* The bucket arn must be for the bucket containing the site content - replace
  `www.example.com` with your bucket name, but be sure to include the trailing
  `/*` to instruct S3 to apply the permission to all objects in the bucket!
* Turn on Block Public Access **after*** you apply this bucket policy.
* The format for specifying a principal in a Bucket Policy is different than you
  might be used to if you're writing IAM policies - [see this
  reference](https://docs.aws.amazon.com/AmazonS3/latest/dev/s3-bucket-user-policy-specifying-principal-intro.html)
* The Principal specified in "AllowBlogPublish" must have adequate IAM Action permissions
  to write to the Bucket in addition to Action specified in this Bucket Policy.
* Following the principle of least privilege,
  `arn:aws:iam::012345678912:user/mybloguploadaccount` has very few permissions,
  including `s3:PutObject` to write objects to the bucket. It is protected by
  Multi-Factor Authentication and is only used for the purpose of publishing
  content to this blog - it has no other permissions in AWS.
  
Here's this site's architecture now:

{{< figure src="/images/2020/04-17-4.png" caption="https://app.diagrams.net/ is really great!" >}}

The IAM Key is not as shiny as the TLS padlock, but it doesn't need to be. It
enables me to mitigate four risks to this site so I can be sure my users are
safe and my AWS costs remain minimal!
