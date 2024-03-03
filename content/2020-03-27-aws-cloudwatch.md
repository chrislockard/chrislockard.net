---
title: "AWS Cloudwatch"
date: "2020-04-03T09:30:00-04:00"
url: "/posts/aws-cloudwatch"
draft: false
categories:
- infosec
tags:
- cloud
- aws
- monitoring
- secops
- cloudwatch
summary: "AWS CloudWatch enables monitoring and alerting on cloud events."
---

In [my post]({{ relref "/content/2020-01-30-aws-cloudtrail.md" }}) on CloudTrail, I
described how that service underpins other AWS security offerings. Although not
explicitly marketed as a security service, [AWS
CloudWatch](https://docs.aws.amazon.com/cloudwatch/?id=docs_gateway) is a
service that can usefully supplement your security organization.

## What CloudWatch Is

CloudWatch is an AWS service that displays visualizations of metrics allowing
you to discover what is going on in your AWS cloud. Other AWS services can
publish metrics to CloudWatch. CloudWatch allows you to then set alarms
for certain metrics and trigger actions in response.

CloudWatch provides obvious value by alerting on metrics. For example, if you
have a mission-critical lambda, CloudWatch can fire off an alert if the lambda
falls below or exceeds an execution threshold. For security related events, you
can configure CloudWatch to alert on access to sensitive information (or perhaps
a [canary token](https://canary.tools/help/canarytokens "Canary token link")or
honeypot). CloudWatch provides alerting capability for services that may not
provide such built-in.

## Why I Use CloudWatch

My favorite use for CloudWatch is using CloudWatch Insights (CWI) as a query
interface to CloudTrail. This requires some setup, but once that's performed,
this is a very powerful security operations and threat hunting capability.

## CloudWatch Insights

CWI provides a query interface similar to, but less powerful than, tools like
[SumoLogic](https://www.sumologic.com/). I have CloudTrail logs all pointing to
one log group that I then query using CWI. When you have to manage multiple
accounts like I do, the ability to query for activity using CWI is extremely
powerful. It can also be _extremely_ expensive, given there is a fee for the
amount of data queried.

## Use Cases

To illustrate the usefulness, here are some queries I've written to look for
malicious activity:

### Login Errors

There are some highly-sensitive accounts in my environment that I expect to only
ever be accessed programmatically. To look for access attempts, I have written
the following CWI query:

```
fields awsRegion, coalesce(userIdentity.userName, responseElements.assumedRoleUser.assumedRoleId, userIdentity.sessionContext.sessionIssuer.userName) as username, recipientAccountId as account, eventSource, eventName, sourceIPAddress as IP, @timestamp, eventTime, coalesce(userIdentity.arn, resources.0.ARN) as arn, concat(arn, eventName) as exclude, @message
| filter account like '012345678987'
| filter @message like 'fail' or @message like 'denied' or @message like 'error'
| filter eventSource like 'login' or eventSource like 'signin'
```

This query pulls out the:

* AWS region,
* [coalesces](https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/CWL_QuerySyntax.html#CWL_QuerySyntax-operations-functions
"AWS CWI Coalesce operator") the first user identifier found (of
`userIdentity.userName`, `responseElements.assumedRoleUser`, etc.),
* the event source (i.e., AWS service that originated the login failure),
* the timestamp of the event,
* the principal's ARN,
* and the exact error message

It then filters the CloudTrail messages received looking for instances of
"fail", "denied", or "error" in AWS services like "login" or "sign-in".

Combined, this information tells me for this specific account whether there have
been any failed logins. These may indicate that a malicious entity is probing
compromised credentials within the environment, or there could be an operational
issue such as a malfunctioning script or lambda.

> From my experience, the Operations team is grateful for any advance warning of
> a configuration issue. The example above once found a script that was invoked
> using expired IAM credentials.

The caveat with using a query like this that it might need updating from time
to time in case authentication errors from services change or new ones are added.

### Suspicious Logins

My environment uses federated authentication. As such, users assume roles into
each AWS account and it's easy to determine invalid logins. This query looks for
role assumptions that don't originate from federated logins:

```
fields awsRegion, coalesce(userIdentity.userName, responseElements.assumedRoleUser.assumedRoleId, userIdentity.sessionContext.sessionIssuer.userName) as username, recipientAccountId as account, eventSource, eventName, sourceIPAddress as IP, @timestamp, eventTime, coalesce(userIdentity.arn, resources.0.ARN) as arn, concat(arn, eventName) as exclude, @message
| filter account like '012345678987'
| filter eventName like 'AssumeRole' and eventName not like 'AssumeRoleWithSAML'
```

### Unapproved Regional Activity

I look for malicious activity across more than 100 accounts. Thankfully, I only
expect to see valid operations traffic in two regions. This query can quickly
detect activity outside of these regions:

```
fields awsRegion, coalesce(userIdentity.userName, responseElements.assumedRoleUser.assumedRoleId, userIdentity.sessionContext.sessionIssuer.userName) as username, recipientAccountId as account, eventSource, eventName, sourceIPAddress as IP, @timestamp, eventTime, coalesce(userIdentity.arn, resources.0.ARN) as arn, concat(arn, eventName) as exclude, @message
| filter awsRegion not like 'us-east-1' and awsRegion not like 'us-west-1'
```

## Expanding

Each of these queries is intentionally generic. I use them as a base and then
layer on additional filters to narrow the scope of what I'm interested in
during an investigation.

> Note: As of this writing (2020-04-03) CWI supports a maximum of 31 logical
> comparisons in one query. Exceeding this value will produce non-deterministic
> results.

## Conclusion

I hope this has provided you with a general idea of what CloudWatch, and
especially CloudWatch Insights queries, can provide for you.

There is a significant amount of work I gloss over that is required to have all
CloudTrail events logged to one CloudTrail for CloudWatch to use. A good primer
for this can be found in the [AWS CloudTrail
documentation.](https://docs.aws.amazon.com/awscloudtrail/latest/userguide/cloudtrail-receive-logs-from-multiple-accounts.html)
