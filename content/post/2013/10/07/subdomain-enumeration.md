---
title: "Subdomain Enumeration"
date: "2013-10-07T12:00:00-04:00"
url: "/posts/subdomain-enumeration"
categories:
- infosec
tags:
- pentesting
- dns
- recon
summary: "Techniques for performing subdomain enumeration information gathering."
showtoc: true
---

As with most things related to pen-testing, there are many different ways to
enumerate the subdomains of your target.  One promising tool I've been playing
with recently is [recon-ng][recon].  I won't be at all surprised if recon-ng
becomes as popular for the reconnaissance phase of a pentest as metasploit has
become for the exploit phase.  Today, though, I want to talk about a fun method
I used a few weeks ago to find out more about the subdomains of my target.  But
first, here are some methods you can use completely passively

# Subdomains - Passively

There are great resources for enumerating subdomains using search engines.
Here's how I would look a domain up using Google:

`site:example.com`

On a recent assessment, I was kinda surprised to discover that Wolfram Alpha had
a useful subdomain list in their site results.  In the "web statistics"
box, there's a button labeled "subdomains."  This returned a very accurate list
of subdomains for my target, and I've since taken to using wolfram to aid in
site enumeration.

# Recon-Ng

You can view Tim Tome's DerbyCon 2013 talk on using it [here][TimTomesTalk] -
this is a fantastic talk highly worth a watch.
Hell, even if you don't care about pen-testing, it's a fantastic talk to see
just how much useful information is out there, (almost) freely available to
those who seek it.

I start with recon-ng by setting my workspace to whatever my current domain
target is, just to keep things sane.

`recon-ng > set workspace example.com`

Next, I use the five major search engine site modules to look up subdomains for
the domain I am interested in.

```bash
recon-ng > use api/google_site
recon-ng [google_site] > set domain example.com
DOMAIN > example.com
recon-ng [google_site] > run
[*] Searching Google API for: site:example.com
...
```

Repeat the usage of different site modules (google_site, baidu_site, bing_site,
google_site, yahoo_site) and all of the results will be funneled into your hosts
table.  You can see all of the hosts discovered by typing

`recon-ng > show hosts`

# The Fun Way

This method was used to verify and supplement the results obtained via the other
methods I've outlined above.  Remember, being thorough pays, and it never hurts
to try and have the most information about your target as possible.  The basic
outline of this method is:

1. Use wget on the main page of the target's domain (usually www.example.com)
2. Parse the results for all subdomains linked to

## Wget

Grab the site's main page:

`wget example.com`

This will return index.html.

## Parse index.html

We'll use a combination of grep, cut, and sort to pull out subdomains returned
from index.html.

```bash
grep "href=" index.html | cut -d"/" -f3 | grep "\." | cut -d'"' -f1 | sort -u
```

This series of commands will look for all links in index.html by looking for all
instances of "href=", trims up the link so we can easily use it in another
command or save it to a text file containing many links.  Here's a visual aid:

1. `grep "href=" index.html returns <a href="http://blog.example.com" >`
2. `<a href="http://blog.example.com" /> passed to cut -d"/" -f3 returns
   blog.example.com"`
3. `blog.example.com" passed to cut -d'"' returns blog.example.com`

Now, if this command was run on an index.html file containing many links, it
would put them all in order, one per line, for easy scriptability.  If saved to
list.txt, we can easily pull out the subdomains like so to get IP addresses.:

```bash
for url in $(cat list.txt); do host $url; done | grep "has address" | cut -d" " -f4 | sort -u
```

These results can be saved to a file, and you have a list of subdomains with IPs for each.  

[recon]: http://www.recon-ng.com/
[TimTomesTalk]: http://www.irongeek.com/i.php?page=videos/derbycon3/1104-look-ma-no-exploits-the-recon-ng-framework-tim-lanmaster53-tomes
