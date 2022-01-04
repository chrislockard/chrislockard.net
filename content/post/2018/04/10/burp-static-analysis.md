---
title: "Static Analysis with Burp Suite"
date: "2018-04-10T12:00:00-04:00"
url: "/posts/burp-static-analysis"
categories:
- infosec
tags:
- burpsuite
- static analysis
- appsec
---

I'm so far behind the times, it's sad. Burp Suite [gained the ability to perform
static analysis on JavaScript libraries back in
2014.](http://blog.portswigger.net/2014/07/burp-gets-new-javascript-analysis.html)
[Some
sites](https://blog.liftsecurity.io/2014/11/18/static-analysis-and-burp-suite/)
and [authors have already blogged about what their approach is for implementing
this](https://statuscode.ch/2015/05/static-javascript-analysis-with-burp/).I'd
like to echo Lukas's method, but with an easier setup.

Simply navigate to the local directory containing the app and serve it using
Python's built-in HTTP server.

* python2 syntax: `python -m SimpleHTTPServer <port>`
* python3 syntax: `python3 -m http.server <port>`

Navigate to the served content in your browser with burp proxy configured and
spider/scan the site as usual - static analysis results will appear in the scan
results pane.
