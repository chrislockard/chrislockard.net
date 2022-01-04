---
title: "Fingerprinting Privacy: Brave vs Firefox"
date: 2020-08-20T17:00:00-04:00
draft: false
url: "posts/fingerprinting-privacy-brave-vs-firefox"
categories:
- privacy
tags: 
- web browser
- foss
- firefox
- brave
summary: "Brave and Firefox bill themselves as privacy champions. How do they fare at fingerprinting protection?"
---

__Update 2020-10-01__
This post now contains a comparison of fingerprinting protections of both
browsers based on interpreting the output of [Device Info](#deviceinfo).

[Brave](https://brave.com/rnr267 "Referrer link to download Brave")(Full
disclosure: that is a referrer link that will tell Brave I sent you) and
[Firefox](https://www.mozilla.org/en-US/firefox/ "Firefox Web Browser") both
bill themselves as privacy-championing browsers for consumers. I have a deep
appreciation for both projects: [Mozilla](https://www.mozilla.org/en-US/firefox/
"Mozilla organization")has been a champion of the open Internet for two decades,
and Brave is attempting to overthrow the incumbent revenue model of the
Internet.

In this post, I quickly compare the fingerprinting capability of these two
browsers by browsing to three fingerprinting demonstration sites:

* https://browserleaks.com/canvas (Canvas)
* https://audiofingerprint.openwpm.com/ (Audio)
* https://fingerprintjs.com/demo (FPJS)

I open each of these sites in a regular session and a private session for each
browser, then I reboot the browser and re-open each site in a regular and
private session for both browsers. Here's what I found:

The desired outcome is for the browser hash to be unique on each visit to the
page. A unique value on each page view means the tracking technology isn't
able to trace back multiple sessions to one user.

| Firefox                  | Canvas Fingerprint | Audio Fingerprint | FPJS Fingerprint |
|--------------------------|--------------------|-------------------|------------------|
| Normal Session           | Unique - ✅        | Shared - 🚫       | Shared - 🚫      |
| Private Session          | Unique - ✅        | Shared - 🚫       | Unique - ✅      |
| Normal Session Reloaded  | Unique - ✅        | Shared - 🚫       | Shared - 🚫      |
| Private Session Reloaded | Unique - ✅        | Shared - 🚫       | Unique - ✅      |

| Brave                    | Canvas Fingerprint | Audio Fingerprint | FPJS Fingerprint |
|--------------------------|--------------------|-------------------|------------------|
| Normal Session           | Unique - ✅        | Unique - ✅       | Shared - 🚫      |
| Private Session          | Unique - ✅        | Unique - ✅       | Unique - ✅      |
| Normal Session Reloaded  | Unique - ✅        | Unique - ✅       | Shared - 🚫      |
| Private Session Reloaded | Unique - ✅        | Unique - ✅       | Unique - ✅      |

<a name="deviceinfo"></a>
# Device Info

I recently discovered [device info][deviceinfo] which gives a comprehensive breakdown
of what information leaks from my browser. I decided to compare and contrast
Brave and Firefox using this tool as well to see how they stacked up. 

Because device info reveals so much information, I'm only going to point out
where I observed discrepancies so you can see the difference between the two
browsers. For this comparison, I used private browsing mode in Brave v1.14.84
and Firefox v81.0 on macOS 10.15.7.

| Detection              | Brave                                                                                                                          | Firefox                                                                                           |
| -------------------    | ----------------------------------------------------------------------------                                                   | ------------------------------------------------------------------------------------------------- |
| Operating System       | macOS version 10.15.7 (32-bit)                                                                                                 | Windows 10 version 10.0 (32-bit) or Windows Server 2016 or 2019 version 10.0 (32-bit)             |
| True OS Core           | Unkown (not supported or blocked)                                                                                              | Intel Mac OSX 10.15                                                                               |
| Browser                | Chrome version 85.0.4183.121 (32-bit) (Engine: Blink)                                                                          | Firefox version 78.0 (32-bit) (Engine: Gecko)                                                     |
| True Browser Core      | Chrome                                                                                                                         | Firefox                                                                                           |
| Browser Build          | 2003-01-07 / Unknown (detection blocked)                                                                                       | 2010-01-01 / 2018-10-01 00:00:00                                                                  |
| Speakers               | Number: 1, Label 1: Speaker 1                                                                                                  | None detected                                                                                     |
| CPU                    | Arch x86 (32-bit) Cores: 6 (correct)                                                                                           | Arch: x86 (32-bit) Cores: 2                                                                       |
| Battery                | Level: 100% Charging: Yes Time remaining: 0s                                                                                   | Unknown (not supported or blocked)                                                                |
| Fonts                  | Automatically detected                                                                                                         | Required user interaction to detect                                                               |
| Plugins                | Name, version, description, filename given for two plugins                                                                     | None detected (no supported plugins or detection blocked)                                         |
| Firefox Extensions     | Unknown/Detection not supported                                                                                                | None detected (no supported plugins or detection blocked)                                         |
| Flash                  | Partial block                                                                                                                  | Full block                                                                                        |
| Browser MIME Types     | application/pdf and application/x-google-chrome-pdf                                                                            | None detected                                                                                     |
| Tracking protection    | Disabled                                                                                                                       | Enabled                                                                                           |
| Pop-up Windows         | Allowed                                                                                                                        | Required user interaction to detect                                                               |
| Screen                 | Max resolution detected (browser window not fullscreen)                                                                        | Current window dimension                                                                          |
| Browser full screen    | Unknown (not supported or blocked)                                                                                             | Known (no)                                                                                        |
| Accepted content types | text/html, app/xhtml+xml, app/xml (q=0.9), image/avif, image/webp, image/apng, */* (q=0.8), app/signed-exchange (v=b3) (q=0.9) | text/html, app/xhtml+xml, app/xml (q=0.9), image/webp, */* (q=0.8)                                |
|                        |                                                                                                                                |                                                                                                   |

Some things to note from this table:

* Brave seems to reveal more accurate and specific info than Firefox for Browser
  type, Speakers, CPU, Battery, Fonts, and Plugins - 🚫
* Firefox required more user interaction to reveal info for Fonts and Pop-up
  windows - ✅
* Firefox revealed that tracking protection was enabled, which could itself
  contribute to more focused tracking - 🚫
* Both browsers made some effort to block or spoof the vast majority of
  detectors on the device info page. - ✅

# Summary

After performing this research, I feel comfortable using either browser. I'm
currently using Firefox as my daily driver because I want to support the project
in ways other than donating money. I want websites to see my ever-so-slight
indication that I reject a monoculture on the web. 

Now, if Brave used Gecko under the hood, would I switch to it permanently? 

[deviceinfo]: https://www.deviceinfo.me
