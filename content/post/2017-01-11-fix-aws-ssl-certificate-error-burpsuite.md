---
title: "Fix AWS SSL Certificate error in Burpsuite"
date: "2017-01-11T12:00:00-04:00"
url: "/posts/fix-aws-ssl-certificate-error-burpsuite"
categories:
- infosec
tags:
- appsec
- burpsuite
- aws
---

This morning, while I was trying to proxy traffic to [this site][chrislockard]
in Burpsuite, I ran across an SSL handshake error. Googling the issue returned
[this helpful article][anshuman] that got me started on the right path. The crux
of the problem was that the JRE didn't have the Java Cryptography Extension
(JCE) Unlimited Strength Jurisdiction Policy files installed. However, since
this article was published, Portswigger began bundling the JRE with Burpsuite
itself.

The solution to fix JCE-related issues (as evidenced in Burpsuite's *Alerts*
tab) was to search for the term "Java Cryptography Extension (JCE) Unlimited
Strength Jurisdiction Policy Files 8 Download" on which led to the [download
page for JRE 8's JCE Unlimited Strength Jurisdiction Policy][JCE]. You can
identify which version of the JRE Burpsuite is using by running:

```
/path/to/Burp\ Suite\ Professional.app/Contents/PlugIns/jre.bundle/Contents/Home/jre/bin/java -version
```

Download and unzip the JCE policy files and copy ```US_export_policy.jar``` and
```local_policy.jar``` to 

```
/path/to/Burp\ Suite\ Professional.app/Contents/PlugIns/jre.bundle/Contents/Home/jre/lib/security/
```

Start Burpsuite and your problem should be solved. If you've managed to
eliminate the JCE error message in *Alerts* but you still see an SSL handshake
error, try resetting Burpsuite's SSL options in *User Options* > *SSL* > *Java
SSL Options*. In my case, I had checked "Disable Java SNI extension". Unchecking
this (or selecting the gear icon in the "Java SSL Options" section and clicking
"Restore Defaults") and restarting Burpsuite solved the issue.

Now I can proxy traffic through Burp for sites implementing AWS's TLS
certificates.

[chrislockard]: https://chrislockard.net
[anshuman]: https://abhartiya.wordpress.com/2014/07/30/how-to-fix-received-fatal-alert-handshake_failure-for-burp/
[JCE]: http://www.oracle.com/technetwork/java/javase/downloads/jce8-download-2133166.html
