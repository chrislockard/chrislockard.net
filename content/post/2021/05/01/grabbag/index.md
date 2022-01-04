---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Grabbag"
subtitle: ""
summary: "RMS, Dan Kaminsky, FLoCS, Fedora"
authors: []
categories:
- infosec
tags:
- rms
- kaminsky
- floc
- fedora
date: 2021-05-01T19:31:41-04:00
lastmod: 2021-05-01T19:31:41-04:00
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

It's been an active six months since my last post. Between the quarantines, work
projects, and the holidays, life has been busy. Much has happened in this time,
but I wanted to write about four events of note:

# RMS re-added to the board of the FSF

Richard Stallman (rms) has [rejoined the board of the FSF][fsf].
[This][fedoramag]👏 [was][zdnet]👏 [a][antirms]👏 [controversial][greer]👏 
[event][prorms], to say the least.

I don't know rms, but if half of what is on
[stallmansupport.org][stallmansupport]
is accurate, then this seems to be a case of cancel-culture character
assassination taking place.

I hope the FSF can survive this stronger than it was before, because it's
mission of computer user freedom is more important now than it's ever been.

# Death of Dan Kaminsky

Dan Kaminsky passed away at 42. [Dark Reading][darkreading] and the [New York
Times][nyt] posted tributes.

I never knew Dan Kaminsky personally, but I was in the room when he [turned on
DNSSEC][gcn] for the root DNS servers at BlackHat 2010 and I witnessed firsthand
his benevolence, patience, and good nature.

What struck me about his passing was how unanimous the affection for him was. He
was praised on twitter as a friend and mentor. It is that sort of legacy that I
hope to one day leave. He is missed and the infosec community is worse off for
his absence.

# Federated Learning of Cohorts (FLoC)

Google is rolling out new targeted advertisement technology. Since the [looming
death of the third-party cookie][hubspot], Google has decided to roll out an
in-browser targeted advertising scheme known as [Federated Learning of
Cohorts][FLoC].

[The EFF is against it][eff] and after discussing it with privacy-focused folks
from work, I decided I'm opposed to it as well. I anticipated that the death of
the third-party cookie would herald new means of tracking individuals, and FLoC
appears benign (in that it can be disabled by website owners), but I'm afraid of
what is to come after it. 

We must remain vigilant in protecting our right to privacy. If you haven't done
so already, I recommend reading [Permanent Record by Edward Snowden][Snowden].
In addition to the [security headers I set on this site]({{< relref
"/content/post/2020/10/09/security-headers-cloudflare-workers/index.md" >}}),
I've added the following to [disable FLoC][disablefloc]:

```
Permissions-Policy: interest-cohort=()
```

# Fedora

While on spring break with the family, I bought an inexpensive laptop with the
intent to learn [FreeBSD][freebsd]. I use it on the NAS at home, where it has
been a wonder and rock-solid OS for over seven years. [The recent
release of FreeBSD 13][fbsd13] inspired me to put it on a laptop where I hoped
it would become my daily driver after moving off of MacOS.

[Unfortunately, this didn't pan out too well.][mytoots] Now, I'm writing this
post from my [Fedora 34][getfedora] workstation. Do I like [systemd][systemd]? I don't
know. [Is Red Hat corporatizing GNU/Linux?][unixsheikh] I could be convinced. Does Fedora make
for one of the best distros I've ever used? Yes. I hate to love it, but it seems
as though fedora unexpectedly won me over. It is nice to have a
GNU/Linux system that Just Works.


[fsf]: https://www.fsf.org/news/statement-of-fsf-board-on-election-of-richard-stallman
[fedoramag]: https://fedoramagazine.org/fedora-council-statement-on-richard-stallman-rejoining-fsf-board/ 
[zdnet]: https://www.zdnet.com/article/free-software-foundation-leaders-and-supporters-desert-sinking-ship/ 
[antirms]: https://rms-open-letter.github.io/
[greer]: https://geoff.greer.fm/2019/09/30/in-defense-of-richard-stallman/
[prorms]: https://rms-support-letter.github.io/
[stallmansupport]: https://stallmansupport.org/
[darkreading]: https://www.darkreading.com/vulnerabilities---threats/in-appreciation-dan-kaminsky/d/d-id/1340830
[nyt]: https://www.nytimes.com/2021/04/27/technology/daniel-kaminsky-dead.html
[gcn]:https://gcn.com/articles/2010/07/28/dnssec-black-hat-update.aspx 
[hubspot]: https://blog.hubspot.com/marketing/third-party-cookie-phase-out
[FLoC]: https://en.wikipedia.org/wiki/Federated_Learning_of_Cohorts
[eff]: https://www.eff.org/deeplinks/2021/03/googles-floc-terrible-idea
[Snowden]: https://archive.org/details/edwardsnowdenpermanentrecordmetropolitanbooks2019
[disablefloc]: https://plausible.io/blog/google-floc
[freebsd]: https://www.freebsd.org/
[fbsd13]: https://www.freebsd.org/news/newsflash/#2021-04-13:1
[mytoots]: https://fosstodon.org/@unl0ckd/106089334129128108
[getfedora]: https://getfedora.org/
[systemd]: https://github.com/systemd
[suckless]: https://suckless.org/sucks/systemd/
[unixsheikh]: https://unixsheikh.com/articles/the-real-motivation-behind-systemd.html
