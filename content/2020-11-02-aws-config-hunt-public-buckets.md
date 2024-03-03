---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Use AWS Config To Hunt Public S3 Buckets"
subtitle: ""
summary: "This post covers using AWS Config as a starting point to find public s3 buckets in your organization."
url: "/posts/use-aws-config-to-hunt-public-s3-buckets"
authors: []
categories:
- infosec
tags:
- cloud
- aws
- monitoring
- secops
- config
date: 2020-11-02T13:53:04-05:00
lastmod: 2020-11-02T13:53:04-05:00
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
projects: []
---

In this post, I want to cover an approach for using Config to rapidly identify
world-readable S3 Buckets.

[Some time ago]({{< relref
"/content/post/2020/08/12/find-resources-with-aws-config.md">}}), I wrote about
using [AWS Config][config] to find resources across a large environment. Config's greatest
strength, in my experience, is rapidly identifying the account owning an
offending resource. In an organization containing over 200 accounts, it's not
feasible to play the guessing game.

To use it in this capactiy, Config must be enabled in all accounts you wish to
monitor. (In my organization, we do this automatically using [AWS
Organizations][orgs])

Open the AWS Config Advanced Query editor (be sure to set _Query Scope_
accordingly!), and paste the following query:

```sql
SELECT
  resourceId,
  resourceType,
  accountId,
  supplementaryConfiguration.PublicAccessBlockConfiguration.blockPublicPolicy,
  supplementaryConfiguration.PublicAccessBlockConfiguration.blockPublicAcls,
  supplementaryConfiguration.PublicAccessBlockConfiguration.ignorePublicAcls,
  supplementaryConfiguration.PublicAccessBlockConfiguration.restrictPublicBuckets
WHERE
  resourceType = 'AWS::S3::Bucket'
```

This returns a list containing all S3 Buckets in the environment and their
PublicAccessBlockConfiguration settings. Look for any _false_ or empty
statements here; this is a good place to start hunting for public buckets.

A full list of S3 bucket properties
used when querying Config can be found [here](https://github.com/awslabs/aws-config-resource-schema/blob/master/config/properties/resource-types/AWS::S3::Bucket.properties.json). 

As of the initial writing (2020-11-02), there is no bucket property that defines
whether a bucket is public. Until such a property is available, this is a good
start.

This query, along with others I regularly use, can be found in my [aws-secops]({{< ref
"/content/project/aws-secops/index.md">}}) collection. If you find it useful or
have suggestions, please drop me a line!

# Bonus for Security Hub Users

If you use [Security Hub][hub], you can find this information in the finding for
failed security standard checks. Sweet!

Under _Security Standards > AWS Foundational Security Best Practices > S3.2_ you
are presented with a list of all world-readable S3 buckets. Clicking on the
title of a failed check will open an info pane to the right containing, among
other data, the AWS account ID containing the bucket.

Enable the AWS Foundational Security Best Practices if you haven't already. Once 
enabled, you'll need to wait several hours up to a few days for all of your
accounts to check in

Security Hub is slowly maturing into a highly usable product, especially in
multi-account organizations. If it's been a while since you've checked it out,
give it another go! (Caveat: as with most other AWS services, you'll need to
enable Security Hub in all accounts you wish to monitor. This is a laborious
process if you have many accounts)

[config]: https://aws.amazon.com/config/
[orgs]: https://aws.amazon.com/organizations/
[hub]: https://aws.amazon.com/security-hub/
