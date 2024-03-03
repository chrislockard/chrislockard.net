---
title: "JavaScript: Methods for sending and receiving network data"
date: "2019-02-15T10:00:00-04:00"
url: "posts/javascript-network-data"
draft: false
categories:
- coding
tags:
- javascript
- development
- monitoring
summary: "Methods for sending and receiving data across a network with JavaScript"
---

JavaScript offers several methods for sending and receiving network data. This
post attempts to enumerate all forms known at this time, to make it possible to
audit code for potentially malicious activity (I'm looking at you, Chrome
extensions requiring access to read or modify all data on a page)

# Update: February 26, 2019

A few days after posting this, I became aware of
[https://crxcavator.io](https://crxcavator.io) which performs security
assessments of chrome plugins at scale. Check it out!

# Ajax and XMLHttpRequest

Asynchronous JavaScript and XML (Ajax) is a turn-of-the-millenium technology
that enabled web clients to retrieve dynamic content from the server without
requiring a full page reload to update. These days, Ajax is typically used to
request data via JavaScript Object Notation (JSON) instead of XML, though the
name stuck. The API for retrieving data from the server using Ajax is
`XMLHttpRequest`.

Searching for XMLHttpRequests across a chrome plugin's content can be
efficiently performed using grep, as shown:

```bash
$ grep -n -e "XMLHttpRequest" -R dbepggeogbaibhgnhhndojpepiihcmeb/
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/options.js:492:    xhr = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:16:    branchRefRequest = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:140:    req = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/completion_search.js:56:      xhr = new XMLHttpRequest();
```

Now I'm going to audit options.js, logging.js, main.js, and completion_search.js
for network activity.

Note that developers quite frequently name the XMLHttpRequest object 'xhr'.

# Fetch

The Fetch API is a modern API for defining request and response objects that can
be abstracted to include any future use cases for manipulating network requests
and responses.

The `fetch()` method is used to make a request to the resource specified as an
argument. Thus, we can search for potential network activity as follows:

```bash
grep -n -e "fetch(" -R dbepggeogbaibhgnhhndojpepiihcmeb/
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/lib/utils.js:418:          return fetch(function(data) {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/options.js:24:      this.fetch();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/options.js:43:      return this.fetch();
```

As `fetch()` defines the concept of a resource `Request`, it's worthwhile to
search for uses of this invocation as well:

```bash
$ grep -n -e "Request" -R dbepggeogbaibhgnhhndojpepiihcmeb/
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/options.js:492:    xhr = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:10:    var branchRefRequest;
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:16:    branchRefRequest = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:17:    branchRefRequest.addEventListener("load", function() {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:19:      branchRefParts = branchRefRequest.responseText.split("refs/heads/", 2);
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:27:    branchRefRequest.open("GET", chrome.extension.getURL(".git/HEAD"));
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/pages/logging.js:28:    return branchRefRequest.send();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/completion.js:515:    SearchEngineCompleter.prototype.preprocessRequest = function(request) {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/completion.js:787:        if (typeof completer.preprocessRequest === "function") {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/completion.js:788:          completer.preprocessRequest(request);
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:3:  var BackgroundCommands, DISABLED_ICON, ENABLED_ICON, Frames, HintCoordinator, PARTIAL_ICON, TabOperations, completers, completionHandlers, completionSources, cycleToFrame, fn, forCountTabs, frameIdsForTab, handleCompletions, handleFrameFocused, i, icon, iconImageData, j, len, len1, mkRepeatCommand, moveTab, onURLChange, portHandlers, ref, ref1, removeTabsRelative, root, scale, selectSpecificTab, selectTab, sendRequestHandlers, showUpgradeMessage, toggleMuteTab,
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:122:    if (sendRequestHandlers[request.handler]) {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:123:      sendResponse(sendRequestHandlers[request.handler](request, sender));
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:140:    req = new XMLHttpRequest();
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/main.js:870:  sendRequestHandlers = {
dbepggeogbaibhgnhhndojpepiihcmeb//1.64.3_0/background_scripts/completion_search.js:56:      xhr = new XMLHttpRequest();
```

# Quick Check for hardcoded IP address or domain

Though malicious activity could be obfuscated, it's usually not a bad idea to
quickly grep for any hardcoded IP addresses or hostnames.

IP address search

```bash
$ grep "\b(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])\." -R dbepggeogbaibhgnhhndojpepiihcmeb/
{no results}
```

Hostname search

```bash
$ grep "^[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,11}$" -R dbepggeogbaibhgnhhndojpepiihcmeb/
{no results}
```

Subdomain search (note the escaped \! to prevent the terminal emulator from
interpreting this as an event)

```bash
$ grep "%(?^(?\!.{256})(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+(?:[a-z]{1,63}| xn--[a-z0-9]{1,59})$%xi" -R dbepggeogbaibhgnhhndojpepiihcmeb/
{no results}
```

I am not a regex expert, nor did I write these (the fine posters in [this
StackOverflow
article](https://stackoverflow.com/questions/10306690/what-is-a-regular-expression-which-will-match-a-valid-domain-name-without-a-subd)
and [this StackOverflow
article](https://stackoverflow.com/questions/7930751/regexp-for-subdomain) did),
so these may not have complete coverage. An attacker may also use string
manipulation to dynamically construct the malicious hostname to contact using
`.join` or another method I'm not aware of.

# References

* [Digital Ocean - Using Grep & Regular Expressions to Search for Text Patterns
  in
  Linux](https://www.digitalocean.com/community/tutorials/using-grep-regular-expressions-to-search-for-text-patterns-in-linux)
* [MDN - Fetching
  Data](https://developer.mozilla.org/en-US/docs/Learn/JavaScript/Client-side_web_APIs/Fetching_data)
* [MDN - Web API -
  Request](https://developer.mozilla.org/en-US/docs/Web/API/Request)
