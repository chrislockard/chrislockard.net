---
title: "URL Encoding"
date: "2014-10-06T12:00:00-04:00"
url: "/posts/url-encoding"
categories:
- coding
tags:
- appsec
- syntax
- url
---

# URL Syntax

`https://admin:pass123@www.example.com:80/bio.txt;pp=1&qp=2#Three`

| URL Part | URL Data |
|:--------:|:--------:|
| Scheme   | https    |
| User     | admin    |
| Password | pass123  |
| Subdomain| www      |
| Domain   | example.com |
| Port | 80 |
| Path | /bio.txt |
| Path Parameter |  pp=1 |
| Query Parameter| qp=2 |
| Fragment | Three |

## Safe Characters

[RFC1738 section 2.2][RFC1738] outlines the safe characters to use in an HTTP
URL Scheme:

`abcdefghijklmnopqrstuvwxyz0123456789$-_.+!*'(),`

Safe characters can be used in URLs without any form of encoding as they aren't
reserved for special use in the construction of the URL.

Unsafe Characters

Per [RFC1738 section 2.2][RFC1738], the following characters are unsafe for use
in an HTTP URL Scheme:

```
space < > " # % { } | \ ^ ~ [ ] `
```

[RFC1738 section 2.2][RFC1738] also states that the following characters are
reserved in an HTTP URL Scheme:

```
; / ? : @ = &
```

[RFC3986 section 2.2][RFC3986] additionally specifies _reserved_ characters in
URI schemes:

```
space % : / ? # [ ] @ ! $ & ' ( ) * + , ; =
```

Unsafe and reserved characters are reserved for use in constructing the URL
scheme. These characters must be encoded so the URL can be constructed without
ambiguity. Fortunately, RFC1738 has us covered.

# URL Encoding

URL, or _percent_, encoding substitutes the percent (%) sign and two hexadecimal
characters to represent unsafe characters in a URL. Here are the encodings for
unsafe and reserved characters per RFCs 1738 and 3986:

| Unsafe Character | URL(Percent) Encoding |
|:-:|:-:|
| space | %20 |
| % | %25 |
| : | %3A |
| / | %2F |
| ? | %3F |
| # | %23 |
| [ | %5B |
| ] | %5D |
| @ | %40 |
| ! | %21 |
| $ | %24 |
| & | %26 |
| ' | %27 |
| ( | %28 |
| ) | %29 |
| * | %2A |
| + | %2B |
| , | %2C |
| ; | %3B |
| = | %3D |
| < | %3C |
| > | %3E |
| " | %22 |
| { | %7B |
| } | %7D |
| pipe |  %7C |
| \ | %5C |
| ^ | %5E |
| ~ | %7E |
| ` | %60 |

## URL ENCODING "GOTCHAS"

Stéphane Épardaud describes several pitfalls to URL encoding at the [Lunatech
Blog][Lunatech] (go read his post!). In summary, reserved characters differ for
each part of the URL:

### Path

spaces must be encoded to `%20`, not `+` `: @ - . _ ~ ! $ & grave ( ) * + , ; =`
are allowed unencoded

### Path Parameter

`=` is allowed unencoded

### Query

spaces may be encoded to `+` (for backward compatibility) or `%20`. `+` must be
encoded to `%2B` `? , /` are allowed unencoded

### Fragment

`/ ? : @ - . _ ~ ! $ & grave ( ) * + , ; =` are allowed unencoded

# For more information

[RFC1738][RFC1738] - Uniform Resource Locators  
[RFC3986][RFC3986] - Uniform Resource Identifiers  
[What every web developer must know about URL encoding][Lunatech]  

[RFC1738]: http://tools.ietf.org/html/rfc1738#section-2.2
[RFC3986]: http://tools.ietf.org/html/rfc3986#section-2.2
[Lunatech]: http://blog.lunatech.com/2009/02/03/what-every-web-developer-must-know-about-url-encoding
