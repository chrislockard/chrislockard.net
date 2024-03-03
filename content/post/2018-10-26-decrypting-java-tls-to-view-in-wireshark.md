---
title: "Decrypting Java TLS to View in Wireshark"
date: "2018-10-26T10:00:25-04:00"
url: "posts/decrypt-java-tls-view-wireshark"
draft: false
categories:
- infosec
tags:
- java
- keylogging
- wireshark
summary: "Use this to recover TLS session keys for a java program."
---

Using Kali, grab this Library: [jSSLKeyLog](http://jsslkeylog.sourceforge.net/
"jSSLKeyLog"). Next, find the script you're testing that invokes java and add
the following parameter (or manually add the parameter if running java
directly):

```bash
$ java -javaagent:jSSLKeyLog.jar==/tmp/ssl-key-log.log -jar file.jar
```

Next, run `tcpdump` how you normally would:

```bash
$ tcpdump -i eth0 -w dump.cap -C 100m
```

Now you can run the java application whose SSL session keys you want to extract:

```bash
$ java -javaagent:jSSLKeyLog.jar==/tmp/ssl-key-log.log -jar app.jar
```

Once the app has generated the traffic you're interested in, open up Wireshark
and select `dump.cap`. Find the first SSL connection to the host you're
interested in decrypting traffic to and right-click > Protocol Preferences >
(Pre)-master-secret log filename and browse to `/tmp/ssl-key-log.log`

Hey, presto! Now you can right-click and select Follow > SSL stream to see the
decrypted traffic.

# References

* [Wireshark Wiki - SSL](https://wiki.wireshark.org/SSL "Wireshark Wiki - SSL")
* [Jim Shaver - decrypt tls traffic the easy
  way](https://jimshaver.net/2015/02/11/decrypting-tls-browser-traffic-with-wireshark-the-easy-way/
  "Jim Shaver - decrypt tls traffic the easy way") 
