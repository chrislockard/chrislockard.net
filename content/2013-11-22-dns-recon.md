---
title: "DNS Recon"
date: "2013-11-22T12:00:00-04:00"
url: "/posts/dns-recon"
categories:
- infosec
tags:
- pentesting
- dns
- nslookup
- dig
- host
summary: "Introductory methods for DNS reconnaissance."
---

The Domain Name System is crucial for human interaction with networks.
Gathering information about a target is critical to performing a successful
penetration test, and the DNS service is one of the key sources of this
information.  Today, I want to write about the different types of information
that can be discovered by probing this service using a mix of command line tools
and web resources.  There are many tools available to interact with DNS, but
today I'm going to cover the use of _nslookup_, _host_, and _dig_ on the command
line, and the [netcraft][netcraft] website.

# DNS Record Types

A brief word on the different DNS record types.  There are many different
resource records stored in the zone files of DNS databases.  This post will only
cover three today: the A, NS, and MX records.

A - This record stores a 32-bit IP address for the domain  
NS - This record stores the domain's authoritative name server(s)  
MX - This record stores the list of mail transfer server(s) for the domain  

For a full list of DNS records, [Wikipedia has you covered][Wikipedia].  Now,
I'll demonstrate how to use several tools to gather information about hosts
using DNS records.

# nslookup

We'll start off by using nslookup.  This tool can be used interactively by
typing nslookup, or you can specify command line arguments to retrieve specific
information from it.  (see the man page for nslookup for more information).  To
use it interactively, we'll start by launching the application:

```bash
$ nslookup
```

Next, we'll tell it what type of record we want.  In this case it is the A
record which is the default for nslookup.  Here's a screenshot of the results:

![nslookup screenshot](/images/2013/11-22-1.png)

These results tell us a few things:

My local DNS server is 192.168.103.250 My local DNS server was queried on port
53 (192.168.103.250#53) The answer is non-authoritative, though it is the best
answer my local DNS server has, and My domain has the IP address 192.185.16.82
Moving on, let's see if we can determine what mail servers are used to handle
mail to this domain. I'll set the record type to _MX_ and query DNS again:

![mx record screenshot]( /images/2013/11-22-2.png)

Unsurprisingly, the mail handler for my domain is mail.dagorim.com.  However, if
it weren't, this query would reveal which server WAS the mail handler.  The 10
next to my handler is the priority of this mail server.  As I only have the one,
it has the highest priority.  Try finding the mail handler for several domains
and see if you can guess what some other values might mean. 

Finally, to gather name server information from the NS record, I'll perform the
following:

![mx record second screenshot]( /images/2013/11-22-3.png)

What information does this output give?  nslookup is a very handy utility,
though it can require several steps to get everything you want.  Let's see what
other tools we can use...

# host

`host` has a different syntax from `nslookup`, but it can provide much of the
similar information.  I'll try a similar search of my domain:

![host screenshot]( /images/2013/11-22-4.png)

By default, `host` will return more useful information in a truncated fashion
over `nslookup`.  These results can be scripted more easily, for instance, if I
have a list of domains, I could write a script to run _host_ against them all
and search for the line "has address" to quickly find the IP address of each.
host has several command line options, and I recommend playing with all of them.  

# AXFR - Zone Transfer

One option in particular is worth becoming familiar with.  Invoking `host -l`
will attempt to perform a zone transfer on the target's DNS server.  If
improperly configured, the target's DNS server will provide the DNS client with
a list of IP addresses for each subdomain.  This could, potentially, give you a
very accurate map of the hosts on your target's network without having to do
much work at all!

> I am not sure what the law says about performing zone transfers.  __Use at
> your own risk!__

# Authoritative Answer

Using `host`, it is possible to obtain an authoritative DNS response for a
domain.  This may be useful if you suspect the [local DNS database may be
poisoned][DNSpoison].  This can be performed by querying another DNS server - in
the following example, I query Google's public DNS server by appending its IP at
the end of my command:

![authoritative answer screenshot](/images/2013/11-22-5.png)

If I were to receive a different IP address from Google's DNS server, I would
immediately suspect that the domain my local DNS has been pointing me to is
potentially malicious.

# dig

`dig` is another powerful DNS client.  By default, `dig` will query the name
server registered in `/etc/resolv.conf`.  Other name servers can be specified on
the command prompt by prepending an @ symbol. To query the same information
we've looked for earlier, the syntax looks like:

![dig screenshot](/images/2013/11-22-6.png)

One of the powerful features of `dig` is the ability to process batches of
queries.  To use this feature, put each query - any type that `dig` can
process - in a text file, one per line and then call dig with the -f parameter.
Here's an example query:

```bash
$ dig -f hosts.txt
; <<>> DiG 9.8.4-rpz2+rl005.12-P1 <<>> dig @8.8.8.8 dagorim.com;; global options: +cmd;; Got answer: ...google.com.  213 IN A 74.125.226.224...;; Query time: 9 msec;; SERVER: 192.168.103.250#53(192.168.103.250);; WHEN: Fri Nov 22 14:46:24 2013;; MSG SIZE  rcvd: 415
```

Here is what `hosts.txt` contains:

```bash
dig @8.8.8.8 dagorim.com
dig blogger.com
dig google.com
```

I want to point out that, while this is a great feature of `dig`, bash scripting
can net you similar time savings with other tools.  Personally, I like to wrap
scripts around the `host` command based on the way it formats output.  `dig`
also contains the ability to query name servers on non-standard ports.  While I
haven't yet encountered DNS running on a non-standard port, this feature is a
lifesaver when needed.

## Query Options

dig contains a series of query options to specify various preferences.  Some of
these include using/not using TCP instead of UDP for regular lookups, attempting
to find the authoritative name server and displaying SOA records for the domain,
displaying truncated results, setting the number of query attempts, and much
more.  Check out the [dig man page][dig man page].

# Netcraft

Netcraft is a service that provides in-depth site information based on crowd-sourced data aggregation.  Users can volunteer to install their toolbar, then, while browsing the web, Netcraft learns about domains their users visit.  

[http://searchdns.netcraft.com/](http://searchdns.netcraft.com/)

Is a very helpful site for learning more about a target domain.  Unfortunately,
nobody has viewed this blog with the Netcraft bar attached, so there's no
information about it yet, but give a search of Google or Facebook a shot.
Netcraft will reveal quite a bit about a target domain.

[netcraft]: http://toolbar.netcraft.com/site_report
[Wikipedia]: http://en.wikipedia.org/wiki/List_of_DNS_record_types
[DNSpoison]: http://www.networkworld.com/news/tech/2008/102008-tech-update.html [dig man page]: http://linux.die.net/man/1/dig
