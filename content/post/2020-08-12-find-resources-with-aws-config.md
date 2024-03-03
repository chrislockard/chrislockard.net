---
title: "Find Resources With AWS Config"
date: 2020-08-12T10:00:00-04:00
draft: false
url: "posts/find-resources-with-aws-config"
categories:
- infosec
tags: 
- cloud
- aws
- monitoring
- secops
summary: "Use AWS Config to locate AWS resources"
---

In a multi-account environment containing dozens or hundreds of accounts and
hundreds or thousands of buckets, it used to be difficult to locate the account
that a resource belonged to. In this post, I will show you how to locate S3
buckets and other resources using [AWS Config](https://aws.amazon.com/config/
"AWS Config").

# AWS Config

AWS bills Config as a service "that enables you to assess, audit, and evaluate
the configurations of your AWS resources." A prerequisite of these actions is,
of course, an inventory of assets or resources. Thankfully, AWS Config does the
heavy lifting for us and provides an interface from which we can query these
resources.

## A Note on Architecture Requirements

In a multi-account, multi-region environment, account and service management is
difficult. In my environment, we deploy Config to all accounts via [AWS
Organizations](https://aws.amazon.com/organizations/ "AWS Organizations") which
is beyond the scope of this post.

What is crucial to using Config in the manner I discuss in this post is setting
the Config delivery method to the same S3 bucket across all of your accounts.
This bucket can reside in the designated monitoring account (you _do_ have one
of those, right?)

If you have a multi-account multi-region environment, the same S3 bucket must be
the target delivery method for AWS Config in each account and region. For
reference, these are my Config Settings:

{{< figure src="/images/2020/08-12-1.png" caption="AWS Config Settings" >}}

## Querying resources

From the [Config Console](https://console.aws.amazon.com/config/ "AWS Config
Console"), navigate to _Advanced queries_ > _New query_:

{{< figure src="/images/2020/08-12-2.png" caption="AWS Config Query editor" >}}

The _Query scope_ allows you to choose from the current account and region, or
an aggregated view of all accounts. For most queries, the latter is preferable.

## S3 Buckets

Frequently, I need to investigate the permissions settings or contents of an S3
bucket as a result of a security alert. The alert doesn't contain information
about the account the bucket resides in, so unless I'm familiar with the bucket
in question, I need to either intrude on someone else by asking if they know
about it, or spend considerable time looking through accounts to find it. Until
now.

With the Query editor open, I can use the following query to look for all S3
buckets across my organization:

```sql
SELECT
  resourceId,
  resourceType,
  accountId
WHERE
  resourceType = 'AWS::S3::Bucket'
```

This returns a list of the 700+ current buckets _and the account that owns them!_

> While AWS Config is capable of so much more, for me, this is Config's killer
> feature - finding S3 buckets used to require significant effort

## Other resources

AWS Config comes with a canned selection of other queries useful for
interrogating assets within your environment. For instance, this query will
display all running EC2 instances across your environment broken down by
number of each instance type:

```sql
SELECT
  configuration.instanceType,
  COUNT(*)
WHERE
  resourceType = 'AWS::EC2::Instance'
GROUP BY
  configuration.instanceType
```

The following query will display all DynamoDB tables with disabled server-side
encryption:

```sql
SELECT
  resourceId,
  resourceName,
  resourceType,
  awsRegion,
  tags,
  configuration.ssedescription.status
WHERE
  resourceType = 'AWS::DynamoDB::Table'
AND configuration.ssedescription.status <> 'ENABLED'
```

Excellent!

## Moving forward

Armed with the amazing capabilities AWS Config provides, you can now interrogate
your environment as you see fit!

For more information about the AWS Config resource schema used to build queries,
see
[https://github.com/awslabs/aws-config-resource-schema](https://github.com/awslabs/aws-config-resource-schema
"link to AWS Config github").

You can find my arsenal of AWS secops utilities at
[https://github.com/chrislockard/aws-secops](https://github.com/chrislockard/aws-secops
"link to my AWS secops github").
