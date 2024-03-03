---
title: "Configure an Upstream Proxy for Burpsuite"
date: "2015-11-05T12:00:00-04:00"
url: "/posts/configure-upstream-proxy-burpsuite"
categories:
- infosec
tags:
- appsec
- burpsuite
---

I had the need to proxy traffic from Burpsuite to another proxy during web app
testing this week. There are a few ways to do this, but this method was the
easiest since I already had Burpsuite's TLS certificate installed. For more
information on this, see the [Burpsuite help][burp help]. To configure an
upstream proxy for Burpsuite, such as [OWASP ZAP][OWASP], follow these steps:

First, configure your upstream proxy that will sit between Burpsuite and the web
application to listen on a different port since they both bind TCP 8080 by
default. Here I've configured ZAP to listen on port 8082 :

{{< figure src="/images/2015/11-05-1.png" caption="ZAP Proxy Port Configuration" >}}

Then, edit Burpsuite's configuration to point to the upstream proxy. Here, I set
a wildcard destination host using '*' and set the proxy host to 'localhost' and
proxy port to '8082':

{{< figure src="/images/2015/11-05-2.png" caption="Configuring Burpsuite's upstream proxy" >}}

Done!

[burp help]: https://portswigger.net/burp/help/proxy_options_installingCAcert.html
[OWASP]: https://www.owasp.org/index.php/OWASP_Zed_Attack_Proxy_Project
