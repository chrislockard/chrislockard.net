---
title: "Protect AWS API Gateway with AWS WAF"
date: "2020-01-31T17:00:00-05:00"
url: "/posts/aws-waf-and-apigw"
draft: false
categories:
- infosec
tags:
- cloud
- aws
- monitoring
- secops
- waf
- api gateway
summary: "Help protect APIGW from attackers with AWS WAF"
---

Unlike my [last post]({{< relref "/content/post/2020/01/30/aws-cloudtrail.md" >}}), this post will be a discussion of a design
pattern and a reference implementation of
sorts for protecting AWS [API Gateway](https://aws.amazon.com/api-gateway/) with
[AWS WAF](https://aws.amazon.com/waf/) using AWS managed [Web
ACLs](https://docs.aws.amazon.com/waf/latest/developerguide/web-acl.html).

> Does it seem like I just threw a word salad at you? It seems like that to me,
> too. See [this
> article](https://redmonk.com/sogrady/2020/01/24/how-to-compete-with-aws/) for a
> spin on AWS that highlights some of my concerns with it.

Moving on...

## API Gateway

API Gateway (APIGW) is an Amazon Service for developing and deploying REST,
WebSocket, and HTTP APIs. Often, these APIs will be exposed to the Internet.
Attackers can try to leverage these APIs to compromise the confidentiality,
integrity, or availability of these APIs to gain unauthorized access to
data or systems.

It may not alway be feasible to add robust security in the code called by the
API, so this design pattern intends to guide users to implement Web ACLs to
protect the API against common attacks originating from the Internet.

## AWS WAF

AWS WAF provides a simple-to-configure and effective barrier against common web
application and API attacks. APIs exposed to the Internet should be configured
with one or more AWS WAF applied via Web ACL rules, a component of AWS WAF.

### Web ACL Rules

Web ACLs rules can be _Managed_ or _Unmanaged._ In most cases, using the AWS
Managed rules are preferred. These managed rules can be combined to best protect
the given resource. As shown in the diagrams below, different groups of rules
are applicable to different applications. For instance, an application run
solely on AWS Lambda would benefit from having the _Bad Inputs, Core Rules,
Reputation List,_ and _Linux OS_ managed rules from AWS as there are no
Lambda-specific rules. For an application running on Microsoft Windows that
reads from or writes data to a SQL database, the appropriate Managed rules are
_Windows OS, SQL Server,_ and _Admin Protection_.

**Note:** There is currently a limit of 1500 _Web ACL rule Capacity Units_ (WCUs).
Each atomic check in a Managed or Unmanaged rule consumes one of these WCUs.

> I strongly recommend implementing Web ACLs to all APIGW deployments, even those
> that aren't exposed to the Internet. Applying Web ACLs to APIGW deployments
> helps to define the trust boundary for each API, and prevents malicious requests
> that originate from within the environment from spreading across trust
> boundaries.

## Design

Here's a high-level overview of some designs:

### External API Deployments

In external API deployments, Web ACLs help guard against attacks originating
from the Internet.

{{< figure src="/images/2020/01-31-17.png" caption="External application backed by Lambdas" >}}

{{< figure src="/images/2020/01-31-18.png" caption="External application backed by SQL" >}}

### Internal API Deployments

For internal API deployments, Web ACLs help guard against internal attackers or
from malicious code or data that has propagated to another internal system.

{{< figure src="/images/2020/01-31-19.png" caption="Internal application backed by Lambda" >}}

## Example Implementation

In this example, we'll look at the following API GW deployment:

{{< figure src="/images/2020/01-31-1.png" caption="External APIGW deployment" >}}

### Deploy API

Before we can apply Web ACLs, we must deploy the API.

With your API selected, navigate to Resources > Click on the _root resource ( '/'
) > Click Actions > Deploy API_:

{{< figure src="/images/2020/01-31-2.png" caption="Actions > Deploy API" >}}

The next modal will pop up. For _Deployment Stage,_ select _[New Stage]_ and fill
out the rest of the information as needed:

{{< figure src="/images/2020/01-31-3.png" caption="Deploy API > Name Stage" >}}

You will be brought to the _Stage Editor._ From here, under _Settings_ (you should
be here by default), select _Create Web ACL_.

{{< figure src="/images/2020/01-31-4.png" caption="Deploy API > Stage Editor" >}}

### Create Web ACL

You should now be on the AWS WAF landing page in the same region as your API GW
deployment. Click _Create Web ACL:_

{{< figure src="/images/2020/01-31-5.png" caption="AWS WAF landing page" >}}

#### Describe the Web ACL

This brings you to the first step for creating the Web ACL - Naming and
describing it. Fill these fields out in a way that they make sense and are
related to the API GW deployment they will guard. Select _Regional Resources_ as
Resource Type since this Web ACL will be applied to an API GW deployment and
click _Next:_

{{< figure src="/images/2020/01-31-6.png" caption="Describe the WebACL" >}}

#### Apply Rules and Rule Groups to the Web ACL

On the next page, we will select the rules that will be applied to this Web ACL.
These rules are what traffic will be evaluated against by AWS WAF to determine
whether it should be allowed or denied. AWS WAF offers two rule types: _Managed
_ and _Unmanaged._ _Managed_ rules are curated rules provided by AWS or AWS
Marketplace sellers. _Unmanaged_ rules are rules you write yourself - this post
will not deal with _Unmanaged_ rules.

In this example, we are selecting AWS managed rule sets to protect this API
deployment against common web attacks:

{{< figure src="/images/2020/01-31-7.png" caption="Add managed rules" >}}

{{< figure src="/images/2020/01-31-8.png" caption="Add managed rule group" >}}

{{< figure src="/images/2020/01-31-9.png" caption="Add managed rules" >}}

> Rule selection should be based on the application or service underlying the API.
> For example, if this API served a SQL database running on Linux, it would be
> important to select the Linux Operating System, POSIX Operating System, and SQL
> Database managed rule groups

Back on the _Add Rules_ and _Rule Groups_ page, consider whether your API should be
permissive or restrictive by default. In most cases, the default action should
be set to _Allow_.

{{< figure src="/images/2020/01-31-10.png" caption="Change default ACL action" >}}

#### Set Rule Priority

Generally, the default order of managed rules doesn't matter much. It is
preferred to have the Amazon IP Reputation List as the highest priority since it
is the least specific rule group. Click _Next_.

{{< figure src="/images/2020/01-31-11.png" caption="Set rule priority" >}}

#### Configure Metrics

Generally, the automatically-provided metrics names are fine to use for
CloudWatch metric names.

{{< figure src="/images/2020/01-31-12.png" caption="Change CloudWatch Metric names" >}}

#### Review and Create Web ACL

{{< figure src="/images/2020/01-31-13.png" caption="Review and finalize Web ACL creation" >}}

Ensure that all settings are desired, and click _Create Web ACL_. You should then
see the new Web ACL in the WAF Web ACLs list:

{{< figure src="/images/2020/01-31-14.png" caption="Web ACL Selection" >}}

### Apply Web ACL

Back in API GW's Stage Editor, click refresh in your browser and the new Web ACL
will be selectable:

{{< figure src="/images/2020/01-31-15.png" caption="Select Web ACL to apply to APIGW Stage" >}}

Select it and then _Save Changes_ in this screen.

## Success!

That's it! The APIGW deployment is now protected by a Web ACL leveraging AWS
managed rules. Below, you can see it in action from the _AWS WAF > Web ACLs >
Overview_ page:

{{< figure src="/images/2020/01-31-16.png" caption="Attack traffic blocked by AWS WAF" >}}
