---
title: "How to create a Metasploit module"
date: "2013-12-13T12:00:00-04:00"
url: "/posts/how-to-create-a-metasploit-module"
categories: 
- infosec
tags:
- metasploit
- pentesting
- coding
summary: "Learn how to create a metasploit module"
---

Today I want to review how to create a metasploit module.  This process was
entirely new to me, so I decided to start from scratch, using the [Metasploit
Unleashed][MetasploitUnleashed] site as a guide.  My aim was to create an
auxiliary scanner to look for Dropbox listeners running on the default ports of
TCP/17500 and UDP/17500.  I use Kali Linux, so all of my examples will reflect
such.

# Where to begin?

I decided to start by identifying the conditions my module would search for.  Having just installed the Dropbox package for Debian - upon which Kali is based - I thought I should create a module to search for default Dropbox instances.  

To check which ports I should be looking for, I issued the following commands:

```bash
~ $ netstat -anup |grep dropbox
udp    0  0 0.0.0.0:17500   0.0.0.0:* 4616/dropbox
and

~ $ netstat -antp |grep dropbox
tcp    0  0 0.0.0.0:17500  0.0.0.0:* LISTEN 4616/dropbox
...
```

Alright, this tells me I should be writing a scanning module to look for TCP and
UDP port 17500 listeners.  I've never written a module for Metasploit before, so
I first need to find out where the existing ones are so I can get some ideas

# Finding modules
To get an idea about how a Metasploit scanning module is written, I wanted to use an existing module as a starting point.  But how did I find out where the existing modules were located?  

I thought of a protocol I normally search for and which should be fairly
straightfoward, so I settled on telnet.   I started up the Metasploit console
and searched for "telnet":

```bash
~ $ msfconsole
...
msf > search telnet
...
auxiliary/scanner/telnet/telnet_version        normal    Telnet Service Banner Detection
...
```

Alright!  This looks promising.  I'm familiar enough with Metasploit to know
that the modules follow a similar directory structure as they're stored on the
filesystem and that they're written in Ruby.  Back to bash:

```bash
~ $ locate auxiliary/scanner/telnet/telnet_version.rb
/usr/share/metasploit-framework/modules/auxiliary/scanner/tftp/tftpbrute.rb
```

Sane enough.  Time to copy and modify for my own purposes:

```bash
~ $ cp /usr/share/metasploit-framework/modules/auxiliary/scanner/telnet/telnet_version.rb msfmodules/dropbox.rb
~ $ vi dropbox.rb
```

## Note on Module Locations

Now is a good time to mention that the canonical directory for Metasploit
modules in Kali Linux is under the `/usr/share/metasploit-framework/` directory.
Metasploit will also look in the user's home folder in the `~/.msf4/` directory
which makes things great for you and for me!  We can write a scanner or other
module, place it in our home directory, and not worry about it!  Metasploit can
merrily update itself with the latest modules from msfupdate and our custom
modules won't be touched!

For the remainder of this entry, the file I will be modifying is

```bash
~/.msf4/modules/auxiliary/scanner/misc/dropbox.rb
```

This means that when I go to use this scanner in Metasploit, I will type:

```bash
msf > use auxiliary/scanner/misc/dropbox
```

# Oh, Crap...

Since this module was a template for my own purposes, I decided to leave as much of it intact as I thought I would need to accomplish my goal.   After reading through the telnet_version.rb file, I decided that this was not the right information I needed.  Ruby is new to me - as is writing Metasploit modules - and although it is similar to Python, _it is just different enough that I realized I would have to build this from the ground up to really appreciate what was going on._  

After some googling, I ended up where I should probably have checked at first:
[Metasploit Unleashed][Metasploit2] (Note: the [Metasploit Development
Reference][MSFReference] was also extremely handy!)

So, backtracking, and with a blank file and a couple of references, I set about re-writing my Dropbox scanner.  

# No More UDP Scanning

Unfortunately, I decided not to scan for UDP port 17500 in this version of the
scanner.  UDP scanning is another learning endeavor for another time.  Besides,
as far as I know, it is not possible to change the ports Dropbox works on,
although you can fiddle with proxy settings in the network proxy settings dialog

# Yeah..

Feeling a bit disheartened that my scanner was reducing in what was already some
basic functionality, I re-set about my task.  Time to put on the thinking cap!

Any Metasploit module will include the following:

```ruby
require 'msf/core'
```

This line is needed because the Metaploit core library is required by all
modules, scanners, exploits, etc.

Next, the scanner needs to tell the Metasploit class that it is an Auxiliary
subclass.  For more information on what this means, see some guides on Ruby
programming and the [Metasploit API][MSFAPI].  I'm still learning this myself.
Anyway, the line you'll see in modules, and in this Auxilary module is:

```ruby
class Metasploit3 < Msf::Auxiliary
```

Wonderful.  Moving on, it is time to include the "mixins" that extend the ability of your Metasploit module by using some pre-built functionality that you can find in the Metasploit API.  

The three mixins I used for this module were:

```ruby
Msf::Exploit::Remote::Tcp # Used to attempt a TCP connection to the target
Msf::Auxiliary::Scanner   # Used to specify a range of hosts (RHOSTS) instead of a specific host (RHOST)
Msf::Auxiliary::Report    # Used to include host, port, and a label in the Metasploit database
```

__Note: I found that the order of mixins is important!__  Originally, I declared
the Scanner mixin before TCP, and my module was requiring both RHOSTS and RHOST.
[HD Moore explains][HD] that the options required by your module are dependent
on the mixins you specify on Seclists.

# Initialize

Next I defined the initialization of the module.  I need to read up on exactly
what the data structure "super" is, but its reminiscent of a Python tuple.  It
contains information about the module which is included when you run `info` in
the Metasploit console.

```ruby
def initialize
    super(
      'Name'        => 'Dropbox scanner',
      'Version'     => '$Revision: 1 $',
      'Description' => 'This module scans for a dropbox listener on TCP port 17500',
      'Author'      => '@Dagorim (http://www.dagorim.com)',
      'License'     => MSF_LICENSE
```

The "register_options" data structure (array with a class reference?) allows you
to specify what the user will be presented with when she types `__show
options__` in the Metasploit console.  I want the default port option to be
17500, so I specify it by setting it thus:

```ruby
register_options(
      [
        Opt::RPORT(17500)
      ], self.class)
```

# Scanning

To perform the actual scanning, I define a function to take the ip address
passed in by RHOSTS, all handled by Metasploit behind the scenes, and only print
a status message if the `Msf::Exploit::Remote::Tcp` class was actually able to
open a connection to it.  The report_service function will add any hosts to the
current workspace and add Dropbox as a service associated with port 17500:

```ruby
def run_host(ip)
  begin
    if(connect)
      print_status("#{ip}:#{rport} DROPBOX")
      report_service(:host => rhost, :port => rport, :name => "Dropbox")
      disconnect
    end
  end
```

## Error Handling

Handling connection or general errors in this module will prevent Metasploit
from spitting out verbose messages to the user, muddying actual results.  This
is my initial method of handling a general connection error and any raised
exceptions:

```ruby
rescue ::Rex::ConnectionError
rescue ::Exception => e
    print_error("#{e},#{e.backtrace}")
```

# The final version

Putting everything together, here is the Dropbox scanner, version 1:

```ruby
require 'msf/core'

class Metasploit3 < Msf::Auxiliary
  include Msf::Exploit::Remote::Tcp
  include Msf::Auxiliary::Scanner
  include Msf::Auxiliary::Report

  def initialize
    super(
      'Name'        => 'Dropbox scanner',
      'Version'     => '$Revision: 1 $',
      'Description' => 'This module scans for a dropbox listener on TCP port 17500',
      'Author'      => '@Dagorim (http://www.dagorim.com)',
      'License'     => MSF_LICENSE
    )

    register_options(
      [
        Opt::RPORT(17500)
      ], self.class)
  end

  def run_host(ip)
    begin
      if(connect)
        print_status("#{ip}:#{rport} DROPBOX")
        report_service(:host => rhost, :port => rport, :name => "Dropbox")
        disconnect
      end
    end
    rescue ::Rex::ConnectionError
    rescue ::Exception => e
        print_error("#{e},#{e.backtrace}")
  end
end
```

And that completes it!  There are likely several bugs in this, but for my
purposes, it worked.  I think it speaks to the power and efficiency of both the
Metasploit framework and Ruby that I was able to approach this topic and, in
just under four hours, have a working scanner built from the ground up.

[MetasploitUnleashed]: http://www.offensive-security.com/metasploit-unleashed/Creating_Our_Auxiliary_Module
[Metasploit2]: http://www.offensive-security.com/metasploit-unleashed/Writing_Your_Own_Scanner
[MSFReference]: https://dev.metasploit.com/api/Msf/Auxiliary/Scanner.html
[MSFAPI]: https://dev.metasploit.com/api/
[HD]: http://seclists.org/metasploit/2010/q2/30
