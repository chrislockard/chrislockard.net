---
title: "Fingerprinting Protection Revisited"
date: "2026-07-22T19:30:00-00:00"
url: "posts/fingerprinting-protection-revisited"
categories:
- Cyber
tags:
- Brave
- Firefox
- Safari
- Privacy
- Fingerprinting
author: "Chris"
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "I was wrong about the conclusion I reached in a recent post."
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
    image: "/images/2026/7-24-banner.jpeg"
    alt: "Oil painting of Brave, Firefox, and Safari browser icons with fingerprints"
    caption: ""
    relative: false
    hidden: true
---

**Update 2026-07-23**: Reviewed and revised for consistency and addded
"Gratitude" and "Privacy again?!" sections.

## Gratitude
First, I want to thank the companies developing [Brave][brave],
[Firefox][firefox], and [Safari][safari] for giving a damn about my privacy. I
respect this, and it has a material bearing on which products I choose to use.

Please continue to invest in and research privacy protections for users like me. As in the cybersecurity realm where attackers and defenders are constantly playing cat-and-mouse, so are the surveillance capitalists and yourselves. 

Thank you.

## Privacy again?!

Privacy isn't secrecy. It's control over who gets to know what about you. That
control is what lets you read, search, and think without editing yourself for an
audience you can't see. A person who assumes they're being catalogued behaves
like a person under review, and that's a quieter, narrower kind of person than
they'd otherwise be.

## I was wrong

[Recently I investigated fingerprint protection of three major browsers.]({{%
relref "/post/2026-07-01-fingerprinting-protection-brave-firefox-safari.md" %}})

My surprising conclusion was that **Safari was the only one of my
three browsers that defeated fingerprint.com's re-identification**. I'd expected
Firefox + [uBO][uBO] to be the most effective, and Safari's privacy protection
performance was so strong that it promoted Safari to my daily driver.

[Firefox 153 shipped yesterday][firefox153] with native Containers, which sent
me back to [fingerprint.com/demo][fingerprintdemo] to poke at the new feature.
That poking turned into several hours of testing, and I'm writing this now
because **I was wrong about my previous conclusion.**

I mentioned that I tested each browser in my "daily driver" configuration, and
this configuration includes using [Private Relay][privaterelay] in all Safari
browsing. I initially ascribed the result to Safari's fingerprint prevention
rather than to Private Relay, because I was also running Firefox's VPN and
assumed it was conceptually equivalent, so IP address didn't occur to me as the
differentiator.

**Safari didn't beat fingerprinting without Private Relay: Private Relay was
rotating my IP address, and fingerprint.com's demo weights IP addresses heavily
enough that even with other browser fingerprinting protections, a new IP address
generated a new Visitor ID, aka Fingerprint.**

## How to assemble a fingerprint

Fingerprint.com/demo hosts Fingerprint Pro, which their documentation describes
as fusing 100+ browser properties with TLS, cookies, visit history, and
geolocation. Independent research that I discovered after my last article — [Luo
et al., WWW26][LuoSavageRitterVoelker] — shows that IP address, display
properties (particularly "colorDepth" and "pixelDepth") and fixed device
properties ("hardwareConcurrency" and "deviceMemory") serve as critical
fingerprinting anchors for Fingerprint Pro. Many client-side defenses, such as
Brave's farbling and Firefox's ETP, fail to prevent Pro's
re-identification as a result because they don't or can't modify these
properties.

Luo et al.'s research underscores the importance of client-side cookies for
re-identification in Fingerprint Pro, especially the `_vid_t` and `_iidt`
cookies that can be tracked across sites. In fact, the paper's authors found
that the presence of these cookies *overrides all other browser properties* for
re-identification purposes. For this reason, I'm ensuring that "clear cookies
and site data every time I close Firefox" is enabled in Settings > Privacy &
Security (with exceptions for the sites I want to stay logged into). This will
at least prevent cross-session tracking via these cookies.

My testing was not nearly as rigorous as the paper's authors', but it does
support their findings: the change that broke re-identification was rotating my
IP address via Private Relay, working together with the browser's fingerprinting
protections. Neither Luo et al. nor my own testing supports IP address as the
sole anchor used to generate a fingerprint.

Combining my observations with the information in Luo et al., my understanding
is that Fingerprint Pro assembles a visitor ID based on the
following three signals:

1. **Browser properties**: the stateless stuff like canvas, WebGL, audio,
fonts, and screen size/depth. This is what I *thought* I was testing.
2. **Cached Content**: Pro stashes identifiers in cookies / localStorage
   / sessionStorage to stabilize results.
3. **Server-side auxiliary signals**: chief among them my IP address, plus
   time-of-visit and request patterns.

Reviewing my original methodology with these in mind, my re-identification test
cleared history and storage between visits killing signal #2. For the Safari
tests, I had Private Relay enabled which rotates my IP address outside my
control, unknowingly varying signal #3. For the Firefox tests I used the
[built-in VPN][firefoxvpn], but it didn't rotate my IP address across the visits
I was comparing and I didn't pay attention to that. For the Brave tests my IP
address was unmodified because Brave doesn't rotate it unless I enter private
browsing with Tor enabled which breaks a large portion of sites, therefore it is
not part of my daily-driver config. 

So across these three browsers, the one variable I never controlled, IP address,
happened to be *rotating for Safari and static for the other two*. And the
browser that "won" was the one whose IP address was rotating. Oof. 

### JShelter enters the chat
A privacy enhancing tool I found since performing my original tests is
[JShelter][JShelter]. This tool advertises the capability to defeat
fingerprinting via its [JavaScript Shield][JSShield] and [Fingerprint
Detector][FPD].

I haven't had the time yet to scientifically test this extension's effects, but
I can confirm that enabling JavaScript Shield will break fingerprint.com/demo's
ability to render a fingerprint in Firefox. It also breaks the other tools I
used in my previous post, like https://amiunique.org/fingerprint and
https://coveryourtracks.eff.org/.

## Containers, or a tale of four different IP addresses

Firefox 153's native Containers gave me a clean way to test whether another
browser with rotating IP addresses could defeat re-identification, because with
[Firefox's VPN][firefoxvpn] enabled, each container received a different VPN IP
address address in my testing. I opened the Fingerprint Pro demo in four
containers, back to back, with JShelter's JavaScript Shield disabled so that it
wouldn't modify the browser properties that would prevent a Visitor ID from
displaying. The only things that changed were the storage jar (fresh per
container) and my observed IP address.

| Container | IP address (63.245.222.x) | Visitor ID |
| --------- | ---------------------- | ---------- |
| Default   | `.112`                 | new ✅     |
| Shopping  | `.17`                  | new ✅     |
| Work      | `.34`                  | new ✅     |
| Vacation  | `.9`                   | new ✅     |

Here I have four containers, four different IP addresss, and four different
Visitor IDs. I reproduced the "Safari effect" inside a browser I'd claimed
*couldn't* do it.

Two things I found interesting:

- The demo's caption says *"Try revisiting on VPN or incognito mode, your
  visitor ID will be the same."* In my testing that's demonstrably false: a new
  Firefox VPN IP address produced a new Visitor ID every time I opened a new
  container tab. Refreshing the demo page would result in the same Visitor ID.
  Either the demo weights IP addresses far more than its marketing implies, or
  the device fingerprint alone isn't confident enough to override the IP address
  change.
    - I should note all four of my Firefox VPN IP addresses were in the same /24
      (63.245.222.0/24), yet each produced a new Visitor ID. Luo et al. found
      the opposite on production Fingerprint Pro — same-/24 IP address changes
      produced no new identifier; only a different subnet did. So either the
      public demo weights IP address more crudely than the production product,
      or the fresh per-container storage jar was doing more of the work than the
      IP, or something else. My test changed both at once and can't separate
      them. This is itself the point: the demo is not a faithful stand-in for
      production Pro. This is corroborated by the disclaimer on
      fingerprint.com/demo that states production accuracy is higher.
- I reviewed [my original Safari
  data](/files/2026-Fingerprinting-Protection-Brave-Firefox-Safari.pdf) with 
  this new information. Visits 2 and 3 shared a Visitor ID while visits 1 and 4
  differed. I originally explained that as "Safari re-randomizes once per
  browser launch" but I *restarted the browser* between visits 2 and 3 and the
  Visitor ID didn't change. Private Relay held the same IP address across visits
  2–3 and assigned different ones for 1 and 4. 

I can't fully rule out that Safari's Advanced Fingerprinting Protection
contributed *something*, but my testing couldn't isolate it, so attributing the
result to AFP was unsupported. I simply came to the wrong conclusion previously,
and it seems that **the dominant, uncontrolled variable was my IP address, and
this threw off my original comparison. However, the browsers' fingerprinting
protections matter too, as Luo et al.'s stable-IP address results show. My IP
address is what differed across my three browsers, so it's what skewed the
ranking, not their fingerprinting defenses alone.**

## What might actually break a fingerprint: JShelter

The original post tested Firefox with uBO and ETP but *not*
[JShelter][JShelter]. I wasn't aware of JShelter until well after testing was
performed. Once I allowed fingerprint.com through uBO (which I had to, to run
the test at all), it executes as first-party JavaScript and uBO can no longer
protect me. The fact that I was re-identified supports this.

JShelter provides a different layer of defense: with its **JavaScript Shield
enabled**, fingerprint.com never computes a Visitor ID at all. The script errors
out, because JavaScript Shield farbles my browser properties so no stable hash
can be formed. At least, that's what I can surmise from the client-side: it's
possible the Visitor ID is still calculated on the server and JavaScript Shield
prevents the client from displaying it properly. The other privacy-checking
tools I used in my previous post similarly error out when JavaScript Shield is
enabled. I *think* this conveys a strong privacy posture.

Disabling JavaScript Shield un-breaks these sites. With JShelter's **Fingerprint
Detector enabled** and **JavaScript Shield disabled**, [EFF's Cover Your
Tracks](https://coveryourtracks.eff.org/) reports my Firefox browser as having a
*randomized fingerprint*, the same result I'd only previously seen from Brave
and Safari. This is first-party fingerprint defense that uBO doesn't provide
against client-side fingerprinting, though, as noted above, farbling doesn't stop server-side fingerprinting.

Unfortunately, with JShelter's JavaScript Shield on, I get Cloudflare CAPTCHAs
on a noticeable fraction of sites, and the CAPTCHA mechanism sometimes breaks,
requiring me to manually disable JavaScript Shield. This tells me that
aggressive farbling makes me *conspicuous* even as it makes me *unlinkable*.
More on that trade-off below.

## Two ways to hide: randomize vs. standardize

I previously discussed **Herd Immunity**, the idea that blending in with a large
crowd of identical browsers beats standing out. It turns out that's one of two
opposed schools of fingerprinting defense:

| | Standardization (homogenize) | Randomization (farble) |
| --- | --- | --- |
| **Idea** | Make everyone look *identical* | Make *you* look different every session |
| **Examples** | Tor Browser, Firefox RFP; much of Safari | Brave, JShelter JS Shield |
| **Pros** | Low uniqueness: you vanish into a huge herd | Unlinkability: no stable value to chain across visits |
| **Cons** | Requires a straitjacket (fixed window size, disabled APIs) and breaks on customization | Conspicuousness, e.g. CAPTCHAs. You're the only one in a disguise |
| **Metaphor** | Every customer in the store wears the same disguise | You wear a different disguise each visit to the store|

My "Herd Immunity" describes the *standardization* approach. JShelter and Brave
use the *randomization* approach. They achieve the same goal of preventing
tracking across sessions by opposite means: you can't be singled out from the
crowd, versus you can't be connected to yourself.

The [research I linked last time on defeating
farbling](https://dl.acm.org/doi/epdf/10.1145/3696410.3714713) makes an
important point: against a determined statistical adversary, *standardized*
(fixed) outputs are more robust than *randomized* ones. However, the naive
"sample the canvas many times and average out the noise" attack is defeated by
both Brave and JShelter, because they seed the farbling per-session and
per-eTLD+1, so repeated reads return the *same* fake value. 

## What this all means

- With my home ISP IP address, Firefox + uBO + JShelter, Brave, or Safari are
  re-identifiable. With the same IP address assigned to Firefox by its VPN or to
  Safari with Private Relay, I'm re-identifiable. 
  - Luo et al. indicate that against Fingerprint Pro at a stable IP address,
    Brave, Firefox ETP, and farbling extensions all fail to prevent
    re-identification. Only Firefox's `privacy.resistFingerprinting` and Tor
    defend against this. So the farbling defenses (JShelter, Brave) require IP
    address rotation as well to defeat fingerprinting re-identification. RFP and
    Tor are the exception: they hold up even at a stable IP address. That's why
    the built-in VPN (below) is more effective in my setup than JShelter alone
    is. Note: I did not test Firefox's `privacy.resistFingerprinting` because
    the increased site breakage again defeats the daily-driver purpose.
- fingerprint.com/demo is a composite test dominated by IP address and stored
  state, such as the cookies identified by Luo et al. The most significant
  browser properties impacting this fingerprinting appear to be IP address,
  device screen dimensions and color depth, and device memory. These are more
  stable anchors that are unlikely to change much.
- **For my stated threat model, commercial cross-session re-identification by ad
  networks and data brokers, all three browsers are "private enough"** if I
  rotate my IP. Privacy-neutral browser choice between Brave, Firefox + uBO +
  JShelter, and Safari more closely matches my hypothesis when I started this
  testing. The farbling defenses catch up to `privacy.resistFingerprinting` when
  IP address rotation is available.

In this way, the conclusion of my previous article stands: all three browsers
are great options for the privacy conscious. My primary browser choice was based
on privacy protection. Now, I can choose which browser based on other
characteristics that matter to me, including engine diversity, novel features,
extension power, transparency, and who controls my IP.

## What I've learned

Through my own testing, I've learned that IP address remains a critical anchor
in calculating my fingerprint. I suspected this, given how stable IP addresses
tend to be. I've learned to question my own conclusions and find more research.

I've also learned that there isn't a browser that perfectly preserves privacy,
but there are at least three that do a damn good job of thwarting
fingerprinting. 

I'm moving my daily driver back to Firefox, though not because it "won
on privacy." The whole point of this post is that it didn't, and neither did
Safari. I'm going back because once privacy is good enough, Firefox wins on the
things I care about: a non-Chromium engine, uBO at full power (Firefox is the
[one browser where it still runs
unhobbled](https://github.com/gorhill/uBlock/wiki/uBlock-Origin-works-best-on-Firefox)),
per-site JShelter control (a newfound superpower), and a **built-in VPN that
covers my IP address exposure for free**. 

The Firefox VPN masks my real home IP address and pools my traffic behind a
typically-shared [egress][egress] with other users. This is a genuine benefit,
since a shared IP address is a weaker anchor than my static residential one. But
Firefox's VPN tends to hold a stable IP address for a while, and a stable IP
address is what re-identified me in my original test. The per-container exits
are what gave me distinct IP addresses, so the Firefox VPN raises my privacy
floor for free. Deliberate rotation — such as new containers, or reconnecting to
the VPN — is what I've found breaks re-identification. In Firefox 153, all I
have to do is long-click the "New Tab" button to easily open a new container tab
with these benefits.

Brave and Safari are fine browsers, and I will periodically use them, but to me,
Firefox has felt like "home" since 2004. I'm happy that I can now open native
container tabs to isolate sites with significantly less friction than before.

## Conclusion

My previous post wasn't wrong about the data. Safari really did defeat the demo
in my configuration. It was wrong about the *why*, and the *why* was the whole
point. I discounted the importance of my IP address as a fingerprinting anchor.

My adversary is commercial re-identification, and as such Brave, Firefox + uBO +
JShelter, and Safari are all adequate, and my decision is a *feature* decision.
Safari and Brave remain excellent; if you're happy on either, this post gives
you no reason to move, though consider using Private Relay with Safari or
Brave's private browsing with Tor for extra fingerprinting protection.

I still think it's a good time to be privacy-conscious on the web. We have at
least three genuinely capable options, and enough transparency (in two of the
three, anyway) to check the vendors' claims instead of trusting them. Which,
apparently, includes checking my own.

## Related Posts
- [Fingerprinting Protection: Brave vs Firefox vs Safari]({{% relref
  "/post/2026-07-01-fingerprinting-protection-brave-firefox-safari.md" %}})
- [Fingerprinting Privacy: Brave vs Firefox]({{% relref
  "/post/2020-08-20-fingerprinting-privacy-brave-vs-firefox.md" %}})

[fingerprintdemo]: https://fingerprint.com/demo
[safari]: https://www.apple.com/safari/
[privaterelay]: https://support.apple.com/en-us/102602
[brave]: https://brave.com/
[firefox]: https://www.firefox.com/
[firefox153]: https://www.firefox.com/en-US/firefox/153.0/releasenotes/
[LuoSavageRitterVoelker]: https://www.sysnet.ucsd.edu/~voelker/pubs/server-fp-www26.pdf
[egress]: https://search.brave.com/search?q=egress+IP&conversation=095b7cbd410ed919de57765a68f816efc9e5&summary=1
[firefoxvpn]: https://support.mozilla.org/en-US/kb/built-in-vpn
[JShelter]: https://jshelter.org/
[JSShield]: https://jshelter.org/levels/
[uBO]: https://github.com/gorhill/uBlock
[FPD]: https://jshelter.org/fpd/
