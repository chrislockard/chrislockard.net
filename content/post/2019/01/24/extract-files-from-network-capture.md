---
title: "Extract files from network capture"
date: "2019-01-24T10:00:25-04:00"
url: "posts/extract-files-from-network-capture"
draft: false
categories:
- infosec
tags:
- wireshark
summary: "Extract files from tcpdump or wireshark captures"
---

From time-to-time, it's a requirement to grab a firmware image, binary, or other
file from a captured network stream. This page outlines several methods of
achieving this.

**Note:** These will not work if the files were transferred via TLS. That's the
whole point of TLS.

# From Wireshark

* Find the start of the transfer if it’s obvious - GET request, server sending
  massive packets, etc.
* Right-click the first packet and select Follow > TCP stream
* Save the entire conversation as RAW
* Open your hex editor and trim any fat (HTTP response headers, etc) from the
  file, using the Wireshark Follow TCP stream window as a guide. Save this as
  output.file

# Using Binwalk

(https://github.com/ReFirmLabs/binwalk)

Using output.file from the previous section, run binwalk -e output.file. If
possible, binwalk will extract files from the network capture if it correctly
identifies magic bytes.

# Using Tcpflow and Foremost

(Included in Kali)

* Make sure your traffic capture file is not compressed
* Create a directory to put tcpflow artifacts in:

```bash
$ mkdir tcpflow
```

and run

```bash
$ tcpflow -r traffic.capture.pcapng -o tcpflow/
```

Concatenate all tcpflow output together:

```bash
$ cd tcpflow/ && cat ./* > ./dump
```

Run foremost:

```bash
$ foremost -i ./dump -o ./foremost
```

If successful, review the artifacts from the foremost directory

# Using Chaosreader

(https://github.com/brendangregg/Chaosreader)

Set up chaosreader:

```bash
$ git clone https://github.com/brendangregg/Chaosreader.git
$ ln -s ~/Chaosreader/chaosreader /usr/bin/chaosreader
```

Ensure the packet capture is in tcpdump format, not pcapng:

```bash
$ editcap -F pcap traffic.capture.pcapng traffic.capture.pcap
```

Run chaosreader:

```bash
$ mkdir chaos/(chaosreader generates a lot of clutter)
$ chaosreader -e traffic.capture.tcpdump -D chaos/
```

Open chaos/index.html
