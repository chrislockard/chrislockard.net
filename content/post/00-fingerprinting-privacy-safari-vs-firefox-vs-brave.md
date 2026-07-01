---
title: "Fingerprinting Privacy: Brave vs Firefox vs Safari"
date: "9999-01-01T00:00:01-00:00"
url: "posts/fingerprinting-privacy-brave-vs-firefox-vs-safari"
categories:
- Privacy
tags:
- Brave
- Firefox
- Safari
author: "Chris"
showToc: false
TocOpen: false
draft: true
hidemeta: false
comments: false
description: "How do Brave, Firefox, and Safari fare against fingerprinting?"
disableHLJS: true
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>"
    alt: "<alt text>"
    caption: "<text>"
    relative: false
    hidden: true
---

[Six years ago]({{% relref
"/post/2020-08-20-fingerprinting-privacy-brave-vs-firefox.md" %}}), I wrote
about the privacy of Brave and Firefox with respect to Fingerprinting. My
conclusion then was I felt comfortable using either Brave or Firefox because
they offered about equal fingerprinting protection.

In this 2026 installment I'm adding Safari. It's in the top five most used
desktop web browsers according to [CloudFlare Radar][CloudFlare Radar]. Apple
famously markets their products and services as Privacy-preserving and
maintains a strong [Privacy Policy][Apple Privacy Policy]. As an Apple customer,
I wanted to apply rigour to these claims instead of blindly trusting
them.

My last review was focused on "what fingerprinting resistance do Firefox and
Brave offer?" This review is focused on "which browsers can reliably prevent me
from being re-identified via fingerprinting as I browse the web?"

***Spoiler*: Safari was the only browser able to defeat fingerprint.com's
re-identification in my everyday browsing configuration!**

*I know*, I'm as surprised as you are. 

I expected privacy parity between these three browsers, with Firefox and uBO
edging out the competition, but fingerprint.com re-identified Brave and Firefox
across every condition tested. Safari was the only browser able to defeat
re-identification from a known commercial fingerprinter.

## Background 

I use three desktop web browsers: Brave, Firefox, and Safari. I want to know
whether Safari's privacy claims hold up under the same empirical tests I applied
to Brave and Firefox six years ago and whether any of these browsers can resist
commercial browser fingerprinting.

{{< callout type="info" title="What is a \"Browser Fingerprint?\"" emoji="❓" >}}
A Web Browser reveals information about the person using it via a mixture of
properties both under and outside of a user's control, such as operating system,
Internet Service Provider, and, crucially, JavaScript. 

JavaScript exposes these properties to scripts embedded inside of the websites
we visit. These scripts can describe our browser to the website owner with such
precision that you or I may be the only person *in the world* with that
particular set of properties. Site owners can use this information to send you
targeted ads or profile you.

Sounds evil, and I generally believe that it is! In fairness, [here's an
article](https://fingerprint.com/blog/what-is-browser-fingerprinting/) from
fingerprint.com (an enterprise browser fingerprinting solution used in this
test) that explains some legitimate uses for websites to fingerprint users.
{{< /callout >}}

Specifically, I'm testing whether I can be re-identified across sessions. 

This re-identification is my primary threat model: **I don't want trackers and
fingerprinters to know who I am as I browse the web.** I'm less concerned about
how sensitive sites like my bank or mortgage lender identify me. In fact, I
would *prefer* they know that they're serving me and not an impostor. Instead,
I'm greatly concerned by my browsing habits being tracked and mined by
advertisers, data brokers, or other faceless miscreants.

### Herd Immunity

An important privacy property of a web browser is how well your specific
instance blends in with the corpus of global users. Trackers and fingerprinters
want to ID *your* browser as specifically as possible, so the more your
browser blends in by matching others, the more difficult it is for them to do this.

|Blending In|Standing Out|
|-------|---------|
|{{< figure src="/images/2026/yes.jpg" align=center >}}|{{< figure src="/images/2026/no.jpg" align=center >}}|

This is why, paradoxically, if you spend too much effort on customization for
privacy you could make yourself **more** fingerprint-able. 

In light of this consideration, I've tried to make the minimum number of
customizations for my desired privacy threat model, but the one factor that's
outside of my control — and yet heavily factors into it — is the total number of
global users of each browser. According to [CloudFlare Radar][CloudFlare Radar],
Firefox commands 7.8% of global desktop browser share, Safari 7.2%, and Brave
0.01%. I suspect Brave is under-represented because it tries to blend in with
Chrome/Chromium and this number is not accurate. These numbers place Firefox and
Safari users in a much larger "herd" in which they can blend.

### Farbling

Brave introduced (as far as I'm aware) the technique of ["farbling"][Farbling]
browser parameters to thwart fingerprinters and trackers. Farbling is the name
the Brave developers gave to their implementation of small, random adjustments
to Brave browser parameters to confuse fingerprinters. (Side quest: [This is an
interesting read][Defeat Farbling] on how farbling can be defeated in practice)

## Test Methodology

Since this isn't an out-of-box test, your results may vary from mine. That's
fine! I hypothesize the gap between browsers isn't overly affected by my
personal configurations, because to the best of my knowledge, none of my
personal configurations disable a meaningful privacy control such as Intelligent
Tracking Protection (ITP, Safari) or Enhanced Tracking Protection (ETP, Firefox)
that might otherwise be enabled.

**I'm using my three primary web browsers and my daily-browsing configuration for each. As such, Private/Private with Tor Browsing mode is not tested.**

{{< callout type="info" title="On Open Source" emoji="❓" >}}
Online privacy discussions typically point to Open Source as a defining privacy
characteristic of web browsers. Open Source web browsers theoretically allow
anyone to inspect their source code to validate the software doesn't unduly
violate user privacy.

(This topic is beyond the scope of this article, but I say "theoretically"
because it's possible that the source code published by a browser vendor isn't
the actual compiled code delivered to users via software distribution) 

Brave and Firefox are open source, but Safari is not (this becomes important
when we look at the protection technologies below). What better reason to put
these privacy claims to the test? Surely we could sniff out hints that Apple may
be saying one thing and doing another? 
{{< /callout >}}

### Brave

**Open Source?**: [Yes][Brave]

**Version:** Brave Browser 1.91.168 (Chromium 149.0.7827.54) 

**Extensions:** 
- 1Password – Password Manager 8.12.22.17
- Obsidian Web Clipper 1.6.1
- The Marvellous Suspender 8.1.3

**Primary Privacy Protection:** [Farbling][Farbling], [Shields][Shields]

**Privacy and Advanced Settings:**

{{< figure src="/images/2026/6-9-2.png" caption="Brave Privacy & Security Settings" align=center >}}

{{< figure src="/images/2026/6-9-2-1.png" caption="Brave Shields Settings" align=center >}}

### Firefox

**Open Source?**: [Yes][Firefox]

**Version:** Firefox 150.0.4 w/ Firefox VPN

**Extensions:**
- 1Password – Password Manager 8.12.22.17
- Reading List 2.4.10
- SleepyTabs 1.9.9
- uBlock Origin 1.71.0

**Primary Privacy Protection:** [Enhanced Tracking Protection (ETP)][ETP], [uBlock Origin request blocking][uBO]

**Privacy and Advanced Settings:** The modified privacy settings in about:config[^1]

### Safari

**Open Source?** Partial. [WebKit][WebKit], the browser engine, is, but Safari the application is closed source.

**Version:** Safari 26.5 (21624.2.5.11.4) 

**Extensions:**
- NetNewsWire 7.0.6
- 1password 8.12.12.44 on STABLE channel
- StopTheMadness Pro 26.3
- wBlock 2.1.0 

**Primary Privacy Protection:** [Advanced Tracking and Fingerprinting Protections, Intelligent Tracking Prevention, Private Relay][SafariProtections]

**Privacy and Advanced Settings:**

{{< figure src="/images/2026/6-9-3.png" caption="Safari Privacy Settings"
align=center >}}

{{< figure src="/images/2026/6-9-4.png" caption="Safari Advanced Settings"
align=center >}}

## Observations

My testing data is available [here][TestData]. It is from this data that I drew
the following observations.

### DeviceInfo.me

The same tool I used in my previous post, [DeviceInfo.me][DeviceInfo.me]
continues to provide robust browser privacy tooling because it identifies
browser parameters that trackers can use to create a fingerprint. In this test,
I assigned a value of '0' for any accurate browser parameter and '1' for a
spoofed, blocked, or otherwise unaccurate value. The browsers that score the
highest will be those that do the best job of spoofing their parameters.

Firefox had the strongest showing in this test because it provided the widest
range of generic parameters about my computer, edging Brave out over device
battery status and Safari out over device camera and microphone details.

Brave did the best job at hiding my actual screen size. This fingerprinting
parameter was more impactful than I expected as we'll see in the CoverYourTracks
section next.

### CoverYourTracks

The CoverYourTracks (CYT) tool provided by the EFF is one of the most-referenced
privacy tools online. CoverYourTracks assigns "entropy bits" based on how
similar your browser parameters are to the other browsers in their data set. The
crucial metric in CYT is the "One in *x* browsers" score because it's how
similar your browser parameter is to *x* other browsers. A lower "One in *x*
browsers" score represents better Herd Immunity.

I assigned points for each browser parameter based on how small the *x* in "One
in *x* browsers" score was for each parameter: 3 points if x <= 11, 2 points if
11 > x < 100, 1 point if 101 > x < 1000, and 0 points if x > 1001.

Brave has a good showing in CYT with the exception of the amount of information
disclosed about the WebGL renderer & version: it was very precise about the make
and model of my laptop versus the more generic parameters presented by Firefox
and Safari.

**Brave's Average Identifying Bits (lower is better):** 3.51
**Brave's Average "One in *x* Browsers" (lower is better):** 84.53
**Brave's Average "One in *x* Browsers" without outlier (lower is better):** 43

Firefox has a good showing in CYT as well, with two notable exceptions:

1. The actual size and color depth of my external monitor was reported. I use an
   ultra-wide Dell with a resolution and depth of 3840x1600x30. I was surprised
   that Firefox didn't report a generic screen size, as Brave did (Brave rounded
   my screen size up to 4K - a common size).
2. My audio context fingerprint was oddly specific. Perhaps this is randomized
   on a per-session or other periodic basis, but if that were the case, I would
   expect CYT to detect and report that as it does with Brave and Safari's audio
   context fingerprints.

**Firefox's Average Identifying Bits (lower is better):** 2.64
**Firefox's Average "One in *x* Browsers" (lower is better):** 1536.76
**Firefox's Average "One in *x* Browsers" without outlier (lower is better):** 12.53

Safari has a good showing in CYT and (surprisingly to me) reported that my
browser was randomized by first-party similar to Brave. However, I had to make a
very specific change to accomplish this.

{{< callout type="info" title="Safari's Screen Size Reporting" emoji="⚠️" >}}

Using CYT revealed that Safari doesn't spoof my screen size; it reports the
actual *window* size instead. As I mentioned, I use an ultra-wide with an
uncommon screen size and color depth. As a result, I configure my windows
usually in a three-column layout. The middle window is my browser, and since
Safari reports screen size based on its window size parameter, my Safari window
was showing up as the only browser in the entire CYT corpus with the unusual
size of 1246x1500x24.

SO many fingerprinting parameters are defeated by this one crucial outlier!

I removed that outlier by setting Safari's window size manually to 1920x1080. My
"One in *x* browsers has this value" score went from 1 in ~350k to **1 in
10.81!** Herd Immunity in action!

You can check Safari's reported window size by pasting this JavaScript snippet
in Safari's console (right-click > Inspect Element > Console)

```javascript
console.log(`${window.outerWidth} x ${window.outerHeight}`)
```

{{< /callout >}}

**Safari's Average Identifying Bits (lower is better):** 2.78
**Safari's Average "One in *x* Browsers" (lower is better):** 16065.20
**Safari's Average "One in *x* Browsers" without outlier (lower is better):** 10.31

### Am I Unique?

This tool works similarly to CYT by applying a "similarity ratio" of your
browser's parameters with those of all browsers that have visited
amiunique.org/fingerprint. A higher similarity ratio is better for privacy
because it means you blend in with the herd more.

I assigned points for each browser parameter based on how similar they were to the Am I Unique corpus: 2 points if the similarity ratio was 41% or better, 1 point if the similarity ratio was 11-40%, and 0 points for 0-10%.

### Fingerprint.com

The last test I ran is one I wasn't aware of (or didn't exist) the last time I
compared browsers - fingerprint.com/demo. This is the only commercial
fingerprinter I'm aware of with a public demonstration. This is crucial, because
it is the only real-world test of browser privacy that I know of: the other
sites included in these tests reveal a lot of information about my browsers'
parameters, but only fingerprint.com shows me whether these can be combined to
track me. Fingerprint.com best represents my threat model adversary and shows me how my browsers fare at keeping my browsing private.

I do not want to be re-identified when visiting fingerprint.com/demo on separate occasions. If my fingerprint value is the same across all browsing sessions, that means I have successfully been re-identified!

I tested each browser by performing an initial visit, then clearing history and storage (cookies, etc) and visiting again roughly five minutes later, then clearing history and storage and using private/incognito browsing and visiting roughly ten minutes later. In Safari (because I saw a re-identified session after seeing no re-identificatiaon) I performed a fourth visit after clearing history/storage, restarting the browser, opening a private browsing tab, changing the window size and then waiting 15 minutes.

|Browser|Visit 1|Visit 2 (cleared + restarted)|Visit 3 (cleared + restarted)|Visit 4 (cleared + restarted + private + resized)|
|-------|---------|---------|---------|---------|
|Brave|`06EO7vuas...`|`06EO7vuas...`❌|`06EO7vuas...`❌|-|
|Firefox|`5A002hl0ui...`|`5A002hl0ui...`❌|`5A002hl0ui...`❌|-|
|Safari|`cFoMGdadm0...`|`7gHhSD3jPK...`✅|`7gHhSD3jPK...`❌|`5pruBi5Nnp...`✅|

Brave and Firefox returned the same Visitor ID across every test after clearing
history, restarting the browser, and even switching to Firefox's new built-in
VPN. The tracker's confidence score stayed at 0.98–1.0 throughout. I was
re-identified every time, regardless of what I did. 

Safari was the only browser where clearing data and restarting produced a new
Visitor ID. Interestingly, Visits 2 and 3 shared an ID suggesting Safari's
protection re-randomizes once per browser launch, not on every single page load.
The cleared history/storage + browser restart + private window + resize in Visit
4 produced a third, distinct ID. I was only re-identified once by the tracker.

### On Simplicity
Stepping back from the test data... I've been a computer nerd for almost 40
years. I live and breathe obscure configuration settings. But I get it: most
people don't. 

Therefore, it's important to point out that while all three browsers offer
strong privacy protection out-of-the-box, Safari and Brave are better than
Firefox from the jump, though Firefox catches up and in many ways surpasses the
others when `about:config` tweaks are applied.

## Conclusion

Safari won on my tests that most directly map to the real-world threat of
fingerprinting re-identification. That doesn't make it the best browser — that
depends on your specific threat model and feature preferences.

I was surprised by this. I thought Firefox and Brave would have been able to
defeat fingerprinting re-identification, but fingerprint.com was able to
successfully re-identify them. 

What likely drove this is Safari's combination of Herd Immunity with Farbling in
a kind of "best of both worlds" scenario. Safari's Advanced Fingerprinting
Protection (AFP) injects noise into canvas, WebGL, and audio APIs specifically
for scripts Apple has classified as fingerprinters. Fingerprint.com is almost
certainly on that list. ITP also blocks fingerprint.com from writing persistent
storage as a fallback. 

Firefox's failure was specific: CoverYourTracks showed my AudioContext
fingerprint as a stable, unrandomized value, not the "randomized by first-party
domain" result Brave and Safari showed. uBO blocks known tracking requests, but
fingerprint.com runs as first-party JavaScript on its own domain — there's no
request to block.

However, it seems that some of Safari's protections rely upon Apple knowing of,
and classifying trackers. [This webkit.org announcement][WebKit 26 Privacy]
discusses Advanced Fingerprinting Protection (AFP) – separate from Advanced
Tracking and Fingerprinting Protection (ATFP). I don't know how many trackers
might exist that Apple doesn't know about, or classify as trackers. In these
situations, Firefox + uBO will offer better privacy protection by not loading
the tracking domain in the first place!

In any case, I'm glad there are three great privacy-focused browsers for users. 

[^1]: They're quite long:
| Property | Value |
|--------- | ------|
|pref.privacy.disable_button.cookie_exceptions	|false		|
|pref.privacy.disable_button.tracking_protection_exceptions	|false		|
|privacy.annotate_channels.strict_list.enabled	|true		|
|privacy.bounceTrackingProtection.hasMigratedUserActivationData	|true		|
|privacy.bounceTrackingProtection.mode	|1		|
|privacy.clearHistory.formdata	|true		|
|privacy.clearOnShutdown_v2.browsingHistoryAndDownloads	|false		|
|privacy.clearOnShutdown_v2.formdata	|true		|
|privacy.fingerprintingProtection	|true		|
|privacy.globalprivacycontrol.enabled	|true		|
|privacy.globalprivacycontrol.was_ever_enabled	|true		|
|privacy.history.custom	|true		|
|privacy.purge_trackers.date_in_cookie_database	|0		|
|privacy.purge_trackers.last_purge	|1750741289688		|
|privacy.query_stripping.enabled	|true		|
|privacy.query_stripping.enabled.pbmode	|true		|
|privacy.resistFingerprinting.randomization.daily_reset.enabled	|true		|
|privacy.resistFingerprinting.randomization.daily_reset.private.enabled	|true	|
|privacy.sanitize.clearOnShutdown.hasMigratedToNewPrefs3	|true		|
|privacy.sanitize.cpd.hasMigratedToNewPrefs3	|true		|
|privacy.sanitize.pending	|`[{"id":"shutdown","itemsToClear":["cache","formdata","cookiesAndStorage"],"options":{}},{"id":"newtab-container","itemsToClear":[],"options":{}}]`	|
|privacy.sanitize.sanitizeOnShutdown	|true		|
|privacy.trackingprotection.allow_list.baseline.enabled	|false		|
|privacy.trackingprotection.allow_list.convenience.enabled	|false		|
|privacy.trackingprotection.allow_list.hasMigratedCategoryPrefs	|true		|
|privacy.trackingprotection.allow_list.hasUserInteractedWithETPSettings	|true	|
|privacy.trackingprotection.consentmanager.skip.pbmode.enabled	|false		|
|privacy.trackingprotection.emailtracking.enabled	|true		|
|privacy.trackingprotection.enabled	|true		|
|privacy.trackingprotection.socialtracking.enabled	|true		|
|privacy.userContext.enabled	|true		|
|privacy.userContext.ui.enabled	|true		|
|privacy.window.maxInnerHeight	|1080		|
|privacy.window.maxInnerWidth	|1920		|
|services.sync.prefs.sync-seen.pref.privacy.disable_button.cookie_exceptions	|true		|
|services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.browsingHistoryAndDownloads	|true		|
|services.sync.prefs.sync-seen.privacy.clearOnShutdown_v2.formdata	|true		|
|services.sync.prefs.sync-seen.privacy.globalprivacycontrol.enabled	|true		|
|services.sync.prefs.sync-seen.privacy.sanitize.sanitizeOnShutdown	|true		|
|services.sync.prefs.sync-seen.privacy.trackingprotection.enabled	|true		|
|services.sync.prefs.sync-seen.privacy.userContext.enabled	|true|


[CloudFlare Radar]: https://radar.cloudflare.com/explorer?dataSet=http&groupBy=browser&filters=botClass%253DLIKELY_HUMAN%252CdeviceType%253DDESKTOP&dt=52w
[Apple Privacy Policy]: https://www.apple.com/legal/privacy/en-ww/
[DeviceInfo.me]: https://www.deviceinfo.me
[Farbling]: https://brave.com/privacy-updates/4-fingerprinting-defenses-2.0/
[Defeat Farbling]: https://dl.acm.org/doi/epdf/10.1145/3696410.3714713
[Shields]: https://brave.com/shields/
[ETP]: https://support.mozilla.org/en-US/kb/enhanced-tracking-protection-firefox-desktop 
[uBO]: https://github.com/gorhill/uBlock
[SafariProtections]: https://webkit.org/blog/category/privacy//apple-announces-powerful-new-privacy-and-security-features/
[WebKit]: https://github.com/WebKit/WebKit
[Brave]: https://github.com/brave/brave-core
[Firefox]: https://github.com/mozilla-firefox/firefox
[TestData]: https://github.com/chrislockard/
[WebKit 26 Privacy]: https://webkit.org/blog/17333/webkit-features-in-safari-26-0/#privacy
[BillyGrace AFP ATFP]: https://medium.com/billy-grace/safari-on-macos-ios-26-tracking-changes-whats-really-changing-31e2d26cb727
