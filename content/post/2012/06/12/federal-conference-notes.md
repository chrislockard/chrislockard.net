---
title: "Federal conference takeaways"
date: 2012-06-12T12:00:00-04:00
url: "/posts/federal-conference-takeaways"
categories:
- infosec
tags:
- defense
- collaboration
summary: "Tips picked up from a red/blue infosec conference"
showtoc: true
---
# Network Defenders MUST Understand What They Defend

I know, this is common sense, right?  Wrong. Enterprise networks continue to
grow cruft; very rarely will they stagnate. Often times networks are set up by
one group of people, all of whom are long gone by the time you show up to do
your job and leave behind no documentation (feeling that gut churn yet?). What
do you do then?

_Your job_. It is up to you, as the network defender, to understand what the
network you're protecting is used for. If there's nobody around to tell you
where everything is, then you have to go to management and present the situation
and ask for authorization to perform your own mapping.

## Understand the Mission

Think of your organization as if it were the military (for some, this may not be
much of a stretch): What is the mission your network supports?  What falls
within and without the bounds of this mission?  These are questions that you
should be ready and able to answer. If you cannot, then you must speak with your
management about determining who can.

## Logical Mapping

Nmap would be an obvious starting point here, but sometimes you'll run into
management who thinks that Nmap is synonymous with outages and lost
productivity. Regardless of the tool you use, you have to map out what physical
devices exist on your network. Every device capable of obtaining an IP address
and even devices that normally don't but are connected to the network via a
device that does - think serial hub with an IP management port.

Another challenge associated with logical mapping is storing the information you
gather. How do you diagram it once you've collected it?  This is a question I'm
constantly investigating as a very kludgy Visio diagram is not the answer for
everybody.

## Physical Mapping

It is debatable in which order you map, but I think it makes sense to get an
idea of what devices are communicating on your network before determining where
they are physically. This is a crucial step, as you must understand what
physical security controls are in place to ensure the safety of assets on your
network. Are USB drive prohibited via group policy?  Savvy users can get around
that if the USB ports on their workstations aren't locked or removed. What good
is all of the perimeter protection if your adversary can steal what they're
after from the building it's in - or pay/convince someone within your
organization to do so for them?

## Users

Who uses the network?  Who are the administrators on the network?  Are the
administrators assigned the correct privileges such that they only have elevated
privilege for the applications they use and default privileges elsewhere?  Are
there any legacy users whose accounts may not have been deactivated and still
exist?  Questions like these are important to answer so that you have a concrete
idea of who the users are on the network. If Alice is your Exchange admin but
you notice that her account has admin privileges on Bob's IIS server, that
should call your attention. If Bob hasn't worked for your organization for six
months, but his account hasn't been deactivated and you notice successful
authentication attempts periodically, that should worry you even if it doesn't
worry anyone else.

The sobering point I took away from this recent conference is that attackers
always win and defenders always lose - the difference between a good defender
and a bad defender is how badly they lose.

# The Human Element

Enterprise tools are a wholly different set from many of the tools the
individual computer network defender relies upon. They can be multi-million
dollar tools that require teams of people and scads of hardware to support.
Often, these tools will have a marketable feature that automates certain tasks
and produces the results in an easy-to-read report.

While these tools are critical, constantly evolving, and providing automated
output, there will always be the need for the human operator to turn the data
output of these tools into useful information that can be presented to
decision makers.

Sounds obvious, right?

I would think so, too, but often a manager will listen to a sales pitch or read
something and get it into her head that the latest widget from
Sophokaspermcafymantec will fulfill their every need. Management will think all
they have to do is pay several million dollars for the software license and
support contract, get the company representatives out to install the beast, then
sit back, light a cigar, and bask as their enterprise sits impenetrable behind a
mountain of automatically-generated .pdfs and automated e-mail notifications.
Ahh, the good life!

In reality, it takes educated and intuitive individuals to parse this output and
paint a picture of what it says about the enterprise as a whole. There must be a
link between the tools and management that can properly interpret the results.
Sure, tools can parse the content of IDS logs many orders of magnitude more
quickly than a human can, but can they make a meaningful inference about any of
that resulting content? It will take a knowledgeable individual to interpret
this output, compare it with the original, and make an informed decision about
the relevance and importance of it.

To tie this in with my previous takeaway; it takes knowledge about the network,
about the mission as a whole, to turn the data spat out by the enterprise tools
into useful information that can be taken to management. This information must
be briefly summarized so it "sinks in" and management can make a decision what
to do with it.

The Human Element cannot be dismissed and must be constantly evolving to meet
the needs of the organization it supports.

Also, a little job security doesn't hurt!

# Collaboration is Essential

By now, you might be thinking that these takeaways are common sense and are so
trivial that you shouldn't be wasting your time reading them. I think so, too,
but this information is critical and bears repeating.

To effectively protect your organization's information and information networks,
collaboration between teams and team members is absolutely critical. Perhaps you
work in the government space or perhaps the private. Perhaps the role of
safeguarding information falls to one team, or perhaps many teams - perhaps
you're the only person on the team! Barring that last scenario, the role of each
team member and each team should be clearly defined (see Takeaway #1) and there
must be clear communication paths between the two. Every organization, whether
Federal or private, has to deal with politicking and bickering between different
chains of command. If you work in an environment where this is minimal or has a
minimal impact on the nature of the business, consider yourself extremely lucky. 

I have seen essential initiatives delayed by months, even more than a year in
one case, due to politicking and posturing between two individuals in a
managerial position who did not see eye-to-eye. Collaboration is essential not
only because it fosters goodwill between team members, but being coordinated in
your efforts raises the cost to your adversaries. Provide a stronger line of
defense and a more united front to your adversaries: if you recognize that the
teams responsible for InfoSec in your organization aren't getting the job done,
speak up!
