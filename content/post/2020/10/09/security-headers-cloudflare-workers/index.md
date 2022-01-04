---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Set Security Headers using Cloudflare Workers"
subtitle: ""
summary: "This article covers previous work and introduces a warning"
authors: []
categories:
- infosec
tags:
- cloudflare
- s3
date: 2020-10-09T10:26:18-04:00
lastmod: 2020-10-09T10:26:18-04:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

Today, I want to share a link to an article that covers using [CloudFlare
workers][cfworkers] to add security headers to content served from an origin
that won't allow you to set such headers naturally, such as GitHub Pages or AWS
S3.

These security headers are effective methods of preventing
[injection][owasp-injection] attacks against your website, or other websites
leveraging your website. 

[In this great article by Scott Helme][helme], he introduces code to create a
CloudFlare worker that will add headers to your website. I recommend giving it a
read to understand how the code works and how to set up a CloudFlare Worker to
add headers to your site. [Scott also has a site that's useful to test that your
CloudFlare Worker is properly setting headers.][secheaders]


Be __very careful__ when setting the
[HSTS](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security)
header. If your origin is not serving content via TLS, or if you decide to
revert from HTTPS to HTTP, this __will__ cause your site to become inaccessible
to users for the duration of the HSTS max-age value which is typically set for
__one year__.


Beware that setting HSTS will make it [difficult to revert to
HTTP][reverthsts][difficult to revert to HTTP][reverthsts].

Here's the code for the worker serving this site:

```javascript
let securityHeaders = {
    "Content-Security-Policy" : "upgrade-insecure-requests",
    "X-Xss-Protection" : "1; mode=block",
    "X-Frame-Options" : "DENY",
    "X-Content-Type-Options" : "nosniff",
    "Referrer-Policy" : "strict-origin-when-cross-origin",
    "Permissions-Policy" : "geolocation=(), microphone=(), camera=(), payment=()",
}

let sanitiseHeaders = {
    "Server" : "Server",
}

let removeHeaders = [
    "Public-Key-Pins",
    "X-Powered-By",
    "X-AspNet-Version",
]

addEventListener('fetch', event => {
  event.respondWith(addHeaders(event.request))
})

async function addHeaders(req) {
  let response = await fetch(req)
  let newHdrs = new Headers(response.headers)

  if (newHdrs.has("Content-Type") && !newHdrs.get("Content-Type").includes("text/html")) {
    return new Response(response.body , {
      status: response.status,
      statusText: response.statusText,
      headers: newHdrs
    })
  }

  Object.keys(securityHeaders).map(function(name, index) {
    newHdrs.set(name, securityHeaders[name]);
  })

  Object.keys(sanitiseHeaders).map(function(name, index) {
    newHdrs.set(name, sanitiseHeaders[name]);
  })

  removeHeaders.forEach(function(name){
    newHdrs.delete(name)
  })

  return new Response(response.body , {
    status: response.status,
    statusText: response.statusText,
    headers: newHdrs
  })
}
```

Once you've saved and deployed your service worker code, all that's left is to
create a route to the worker from your CloudFlare Dashboard > Workers page. Mine
routes `*.chrislockard.net/*` to point to the security headers worker and I can
verify that all is well using curl or [Security Headers][secheaders]! 

One last thing I want to point out is that, since Scott's original article was
published, CloudFlare has provided a generous Free (gratis) plan for Workers,
which as of this writing includes:

* 100k requests/day (excess requests return errors)
* Up to 10ms CPU time per request
* Up to 30 workers

For a small site like this one, this plan is perfect!

[cfworkers]: https://workers.cloudflare.com/ 
[owasp-injection]: https://owasp.org/www-project-top-ten/2017/A1_2017-Injection
[helme]: https://scotthelme.co.uk/security-headers-cloudflare-worker/
[reverthsts]: https://serverfault.com/questions/811346/ive-switched-back-from-https-to-http-now-the-page-doesnt-load-in-chrome/811376#811376
[secheaders]: https://securityheaders.com/
[hsts]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Strict-Transport-Security
