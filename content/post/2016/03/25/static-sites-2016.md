---
title: "Static Sites in 2016"
date: "2016-03-25T12:00:00-04:00"
url: "/posts/static-sites-in-2016"
categories:
- efficiency-organization
tags:
- aws
- static site
---

It's early 2016, and there are a multitude of content management systems and
blog platforms out there:

* [Wikipedia's List of Content Management Systems][Wikipedia]

The security blog I contribute to, [Penetrate.IO][P.IO] runs on the venerable
[Wordpress][Wordpress] and requires constant updates to stay one step ahead of
attackers. This becomes tiresome after a while, especially since the only thing
I'm interested in hosting is a series of articles. These don't require
server-side computation, simply hosting. It's a little like [web development
from the late 90's][90s] - I only require simple HTTP hosting.

Once again, I turn to the [static site generators][static]. There are many more
options available now than there were in 2013 when I originally looked at them.
[Jekyll][Jekyll] has risen to the top of the list, has the best support, and has
expanded significantly since I last looked at it, so that's the tool I decided
to use for this job. A few Google queries later, and I've noticed a trend of
people posting about their static site setup. Afte spending the better part of
the past two days configuring this website, I now understand why: these posts
serve as a refresher for the site author!

Between configuring Jekyll, S3, CloudFront, and Letsencrypt, my head is spinning
with all of the tweaks I've performed and the guides I've followed. Here, then,
is my entry into the "Static site running on AWS" curriculum:

# The Problem

I want to host a small static site, encrypted, for as little as possible since I
don't make money from this site. I want the site to be attractive, simple, and
__easy to maintain__. I'm willing to sacrifice some of the ease of use of
established CMS applications (like Wordpress's single-click install, or ability
to blog at blogger using my GMail account) to forego the regular maintenance
some of them require. The ability to programmatically update content on the site
is a must.

Additionally, I don't always like to take work home with me, and when I do, I
don't want it to be pervasive in my life. With that said, this site should have
a minimal attack surface.

# The Solution

There were many combinations of offerings to consider for this problem, but I
settled on:

* [Jekyll][Jekyll] to generate the static site based on my content,
* [Amazon S3][s3] to host site content at low cost and high reliability
* [Amazon CloudFront][cf] to serve as a content delivery network and allow a
  TLS-secured channel to my content
* [Letsencrypt][le] to provide the TLS certificate
* [s3_website][s3w] to handle blog publication
* [letsencrypt-s3front][les3f] to install the Letsencrypt TLS certificate to AWS
  IAM

# Installing Jekyll

This was the easiest part of the entire set up, jekyll installs like any other
Ruby gem:

```bash
gem install jekyll
```

Configuring Jekyll is, unfortunately, an exercise left to the reader. [The
documentation is abundant][jekylldoc], however.

# Configuring S3

I followed steps 1 and 2, outlined in [Setting Up SSL on AWS CloudFront and
S3][r1]. These involved creating a bucket named `chrislockard.net` and enabling
web site hosting on it. I edited the bucket's policy to include the following
permissions which enable anyone (Internet browsers and CloudFront) to read the
contents of the bucket:

```json
{
  "Version":"2012-10-17",
  "Statement":[{
    "Sid":"PublicReadGetObject",
    "Effect":"Allow",
    "Principal": {
      "AWS": "*"
    },
    "Action":["s3:GetObject"],
    "Resource":["arn:aws:s3:::chrislockard.net/*"]
  }]
}
```

Uploading content to AWS would be handled by [s3_website][s3w].

# Configuring CloudFront

With the S3 bucket configured, it was time to configure [CloudFront][cf].

> Configuring CloudFront can be frustrating: remember to __always let CloudFront
> finish distributing__ before testing to see whether changes have worked.
> __Clear your browser's cache while testing CloudFront changes.__ Yes, this
> adds considerable delay when testing settings, but it is worth it to avoid
> cache-related headaches!

I created a new CloudFront distribution incorrectly, but was able to edit any
settings I needed to after the fact. The process involved:

* Choosing "web" distribution type
* Setting Origin Domain Name: __this is the "Endpoint" URL provided by an S3
  bucket when "Enable Web Hosting" is selected__
* Selecting a price class: `Use only US and Europe`
* Setting alternate domain names (CNAMEs): `chrislockard.net`
* Selecting an SSL certificate: `leave blank during initial creation, this will
  be set later`
* Setting a default root object: `index.html`
* Viewer Protocol Policy: __HTTP and HTTPS__ until a TLS certificate is
  configured

CloudFront created the web distribution, which was required for configuring the
TLS certificate using letsencrypt-s3front.

# Installing Letsencrypt and letsencrypt-s3front

Letsencrypt had issues running on OS X due to [SIP][SIP] blocking access to
`/etc/letsencrypt` Instead, I installed Letsencrypt in a debian VM using
`aptitude`. __However: I ran into issues  using the package manager's version,
so I installed Letsencrypt using `pip`__

```bash
pip install letsencrypt && pip install letsencrypt-s3front
```

I *still* ran into issues, until I came across [Working around letsencrypt
module import error][r2]. The solution, after previously installing Letsencrypt,
was to perform the following :

```bash
pip uninstall letsencrypt-s3front && pip uninstall letsencrypt
source ~/.local/share/letsencrypt/bin/activate
git clone https://github.com/dlapiduz/letsencrypt-s3front.git
cd letsencrypt-s3front
python setup.py install
```

# Create IAM Admin User

I created an admin account in [Amazon IAM][iam] with which to generate my TLS
certificate. I named this account "SSL Admin" so I would be able to refer to it
later. This user was given the following permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [{
    "Effect": "Allow",
    "Action": ["*"],
    "Resource": ["*"]
  }]
}
```

These permissions are dangerous. Accounts with these permissions should only
be temporarily activated to perform a specific task, then immediately
de-activated.

With this SSL Admin account created, it was time to generate and install the TLS
certificate.

# Generating the Letsencrypt certificate

The [letsencrypt-s3front tool][les3f] tool was used to generate and push the
Letsencrypt certificate to my S3 and CloudFront properties. I created
`letsencrypt-s3front.sh` to perform this task:

```bash
source /root/.local/share/letsencrypt/bin/activate

AWS_ACCESS_KEY_ID="access_key_id" \
AWS_SECRET_ACCESS_KEY="access_key_secret" \
letsencrypt --agree-tos -a letsencrypt-s3front:auth \
--letsencrypt-s3front:auth-s3-bucket bucket.name \
--letsencrypt-s3front:auth-s3-region us-east-1 \
-i letsencrypt-s3front:installer \
--letsencrypt-s3front:installer-cf-distribution-id cloudfront.distribution.id \
-d bucket.name

```

The Access Key ID and Secret were those of the SSL Admin account. Once this tool
completed, my TLS certificate was installed on IAM!

# Configure CloudFront to use SSL

From the dashboard, there were three tabs I needed to edit: General, Origins,
and Behaviors.

* General: select "Custom SSL Certificate" and enter the Letsencrypt TLS
  certificate from the drop-down (this was was pre-allocated with my Letsencrypt
  TLS certificate). I selected the "Only clients that Support Server Name
  Indication (SNI)" radio box under "Custom SSL Client Support".
* Origins: Set "Origin Protocol Policy" to "HTTP Only". CloudFront distributions
  pointing to S3 Endpoint URLs won't support HTTPS.
* Behaviors: Set "Viewer Protocol Policy" to "Redirect HTTP to HTTPS".

With that, CloudFront was configured to serve this site from my S3 bucket over
HTTPS using my Letsencrypt TLS certificate.

# Configure DNS

Since I wanted to serve traffic to a site at the naked root of my domain, [I
needed to use Route 53.][awsdoc] This was fine with me, since I believe Amazon's
DNS to be more robust in the face of attack than my domain registrar's.

Configuring Route 53 involved:

* Creating a new hosted zone and setting my domain name to `chrislockard.net`
* Creating a new Alias (A) record for `chrislockard.net` and setting its value
  to my CloudFront distribution domain name (looks like
  98jfajklfjf.cloudfront.net)
* Transferring DNS to Route 53 from my registrar by setting my registrar's DNS
  servers for chrislockard.net to the values provided by Route 53 in my NS
  record.

After waiting for thirty or so minutes, I could navigate to
[https://chrislockard.net](https://chrislockard.net) and everything worked!

# Resources

The following sites were all referenced during the configuration of this
website, and without whose help you would not be reading this article:

* [AWS Example: Setting Up a Static Website][r1]
* [AWS Example: Setting Up a Static Website Using a Custom Domain][r2]
* [Setting Up SSL on AWS CloudFront and S3][r3]
* [Create a jekyll blog & host it on amazon s3][r4]
* [Let's Encrypt a Static Site on Amazon S3][r5]
* [Working around letsencrypt module import error][r6]
* [CloudFront error when serving over HTTPS using SNI][r7]
* [Running Jekyll][r8]
* [Using Jekyll in 2016][r9]
* [Deploy your website to S3][r10]

[Wordpress]: https://wordpress.org
[Blogger]: https://www.blogger.com
[SquareSpace]: https://www.squarespace.com
[Wikipedia]: https://en.wikipedia.org/wiki/List_of_content_management_systems
[P.IO]: https://penetrate.io/
[90s]: http://digitalsynopsis.com/design/old-90s-web-design-trends/
[static]: https://www.staticgen.com/
[Jekyll]: https://jekyllrb.com/
[s3]: https://aws.amazon.com/s3/
[cf]: https://aws.amazon.com/cloudfront/
[le]: https://letsencrypt.org/
[s3w]: https://github.com/laurilehmijoki/s3_website
[les3f]: https://github.com/dlapiduz/letsencrypt-s3front
[jekylldoc]: https://jekyllrb.com/docs/home/
[SIP]: https://en.wikipedia.org/wiki/System_Integrity_Protection
[iam]: https://aws.amazon.com/iam/
[awsdoc]: http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html
[r1]: http://docs.aws.amazon.com/AmazonS3/latest/dev/HostingWebsiteOnS3Setup.html
[r2]: http://docs.aws.amazon.com/AmazonS3/latest/dev/website-hosting-custom-domain-walkthrough.html
[r3]: https://bryce.fisher-fleig.org/blog/setting-up-ssl-on-aws-cloudfront-and-s3/
[r4]: http://danielwhyte.com/app/design/2014/10/05/creating-a-jekyll-s3-server.html
[r5]: https://www.codeword.xyz/2016/01/06/lets-encrypt-a-static-site-on-amazon-s3/
[r6]: https://github.com/dlapiduz/letsencrypt-s3front/issues/20
[r7]: http://stackoverflow.com/questions/22282137/cloudfront-error-when-serving-over-https-using-sni
[r8]: http://mmistakes.github.io/so-simple-theme/theme-setup/#running-jekyll
[r9]: https://mademistakes.com/articles/using-jekyll-2016/
[r10]: https://github.com/laurilehmijoki/s3_website/blob/master/additional-docs/setting-up-aws-credentials.md
