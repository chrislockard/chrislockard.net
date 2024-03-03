---
title: "AWS Security Hub"
date: "2020-02-21T00:00:00-05:00"
url: "/posts/aws-securityhub"
draft: false
categories:
- infosec
tags:
- cloud
- aws
- monitoring
- secops
- securityhub
summary: "AWS Security Hub eases the pain of cloud monitoring"
---

This post is an overview of [AWS Security
Hub](https://aws.amazon.com/security-hub/) and the value it brings to a security
operations (SECOPS) organization for monitoring and alerting on AWS cloud
activity.

## What is Security Hub?

Security Hub serves as a single pane of glass through which you can view
security findings reported by AWS GuardDuty, Inspector, Macie, Access Analyzer,
and Firewall Manager.

For more general info, see the [Security Hub
FAQs](https://aws.amazon.com/security-hub/faqs/ "Security Hub FAQ") page.

## Security Findings

More than this, Security Hub automatically aggregates, organizes, and assigns
risk to these findings, allowing your security operations (SECOPS) team to
monitor events occurring in your cloud. Using the [AWS Security Finding Format
(ASFF)](https://docs.aws.amazon.com/securityhub/latest/userguide/securityhub-findings-format.html "Amazon Security Finding Format"), these events can be piped to CloudWatch
Events where they can be consumed by other tools to enable automation.

This finding format is significant, because it represents the first (to my
knowledge) time that AWS has tried to tie the findings from all of their
security tools together. Security Hub itself does a decent job of allowing one
to analyze a finding by drilling down into the relevant service console, but
there is a limit to the number of services that can plug into Security Hub at
the moment. With the ASFF, it is possible for any tool to produce a finding that
Security Hub can consume.

## Governance

Security Hub also offers an overview of an organization's compliance with
particular security frameworks or ad-hoc configuration baselines leveraging [AWS
Config](https://aws.amazon.com/config/ "AWS Config"). Out-of-the-box, Security
Hub will display adherence to the [CIS AWS
Foundations](https://www.cisecurity.org/benchmark/amazon_web_services/ "CIS AWS
Foundations") and [PCI DSS](https://www.pcisecuritystandards.org/ "Payment Card
Industry Data Security Standards") benchmarks, as of this writing (2020-02-21).
As with security findings, Security Hub simplifies the view into these
governance standards to allow one to quickly assess organizational adherence.

## Why Should I Use SecurityHub?

I believe the first and most obvious benefit of Security Hub is quickly
disseminating information to security operations and compliance teams. However,
the real value of Security Hub moving forward is the orchestration of security
findings via all of the other security tools using the ASFF.


## How Should I Use SecurityHub?

Every organization is going to answer this question differently. I want to offer
some pointers from my own lessons learned.

### Designate A Master Security Monitoring Account

A master security monitoring account eases the pain of consuming findings across
many accounts and regions. An architecture I recommend is to designate one
account as the master security monitoring account and invite all of your other
organizational accounts into it.

This is easily done in the console by navigating to _Settings > Accounts > Add
accounts_:

{{< figure src="/images/2020/02-21-1.png" caption="Add accounts in Security Hub" >}}

Member accounts can be added by creating a CSV with the following format:

{{< highlight csv "linenos=table" >}}
Account ID,Email
000111222333,account1-email@example.com
111222333444,account2-email@example.com
222333444555,account3-email@example.com
...
{{< / highlight >}}

These can be then bulk added to Security Hub by navigating to
_Settings > Accounts > Add accounts > Upload List (.csv)_:

{{< figure src="/images/2020/02-21-2.png" caption="Bulk import accounts" >}}

After clicking _Add Accounts_, Security Hub will display the accounts to be
added. Click _Next_. Now invite these accounts by selecting the "Invitation not
yet sent" drop-down, select all of the accounts you want to invite, and then
click _Actions > Invite_:

{{< figure src="/images/2020/02-21-3.png" caption="Invite member accounts" >}}

You'll be prompted for a message to send to the account owner and then you can
invite the account. The annoying part now is that you must login to each account
and accept the invitation. For a large organization, this can take quite some
time :(

**If there's a smarter way to do this, please tweet me [@unl0ckd](https://twitter.com/unl0ckd)!**

### Rollout AWS Organization Policy to prevent tampering

Unfortunately, principals with sufficient access in each account you invite to
Security Hub could disable it. [AWS
Organizations](https://aws.amazon.com/organizations/ "AWS Organizations")
service control policy can be used to prevent this. An example SCP might look
something like this, **but do not use this example verbatim without testing in
your environment!**

{{< highlight json >}}
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PreventTamper",
            "Effect": "Deny",
            "Action": [
                "account:*",
                "organizations:*"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
{{< / highlight >}}

### Enable Security Standards

Depending on your organizational needs, you may want to enable the AWS CIS
Foundations or PCI-DSS security standards in Security Hub. This is easily done
by navigating to *Security Standards* from the Security Hub homepage.

> For these standards to fully work, AWS Config must be enabled in each
> monitored account

### Conclusion

If you've followed along with this article, your SECOPS team should now be able
to view aggregated security and compliance information across all of your AWS
accounts from one pane of glass. 

I want to give AWS credit where it's due: I just described enabling security
monitoring for an entire organization's AWS presence in a five-minute blog post
due to the engineering effort that went into Security Hub. That is remarkable to
me. Kudos, Security Hub team!
