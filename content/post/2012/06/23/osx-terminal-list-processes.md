---
title: "OSX Terminal - List Processes"
date: "2012-06-23T12:00:00-04:00"
url: "/posts/osx-terminal-list-processes"
categories:
- infosec
tags:
- unix
- terminal
- macOS
summary: "An exploration of the ps command"
showtoc: true
---

The UNIX command for listing processes from the command line is:

```bash
ps
```

"ps" stands for "process status" and by default it will print a list of
processes identifiers, controlling terminals, CPU time (user and system), state,
and the associated command.  Here is the output I see when I type "ps" at the
terminal:

```bash
$ ps
PID   TTY           TIME CMD
17559 ttys000    0:00.05 -bash
23627 ttys000    0:00.01 man ps
23630 ttys000    0:00.00 sh -c (cd '/usr/share/man' && /usr/bin/gunzip -c '/usr
23631 ttys000    0:00.00 sh -c (cd '/usr/share/man' && /usr/bin/gunzip -c '/usr
23635 ttys000    0:00.00 sh -c (cd '/usr/share/man' && /usr/bin/gunzip -c '/usr
23638 ttys000    0:00.01 /usr/bin/less -is
18015 ttys001    0:00.14 -bash
23120 ttys001    0:00.09 /Library/Frameworks/Python.framework/Versions/2.6/Reso
23124 ttys001    0:00.01 less
22686 ttys002    0:00.01 -bash
22689 ttys002    0:00.11 /Library/Frameworks/Python.framework/Versions/2.6/Reso
23643 ttys004    0:00.02 -bash
```

This is neat, and it sort-of tells me what I want to know, but let's see what
else *ps* can be used for...

# Displaying information about a user's processes

Perhaps the most useful argument for *ps* is *-U*.  This will list the User ID,
Process ID, Terminal, System TIme, and Command associated with each 's
processes:

```bash
$ ps -U root
  UID   PID TTY           TIME CMD
    0     1 ??         8:27.52 /sbin/launchd
    0    10 ??         0:12.99 /usr/libexec/kextd
    0    11 ??         0:27.03 /usr/sbin/DirectoryService
    0    12 ??         0:05.74 /usr/sbin/notifyd
    0    13 ??         0:02.45 /usr/sbin/diskarbitrationd
    0    14 ??         0:34.34 /usr/libexec/configd
    0    15 ??         0:23.02 /usr/sbin/syslogd
    0    21 ??         0:02.53 /usr/sbin/securityd -i
    0    23 ??         0:01.38 /usr/sbin/blued
    0    27 ??         0:01.29 /usr/sbin/krb5kdc -n
...
```

If working with User IDs is more convenient, I can use "ps -u " to list the same
information by user ID instead of user name.

# Displaying detailed information about processes

To obtain detailed information about processes, supply the "-v" argument.  Note:
this argument prints more columns of information than the terminal is capable of
displaying if left at the typical 80x24 (80 columns, 24 rows) configuration.
This argument can be supplied with other arguments, such as "-u."  The following
will output detailed information about all of root's processes:

```bash
$ ps -vU root
  PID STAT      TIME  SL  RE PAGEIN      VSZ    RSS   LIM     TSIZ  %CPU %MEM COMMAND
17433 Ss    39:13.05   0   0      0  3226576 148012     -        0   0.6  1.8 /
   35 Ss     2:20.87   0   0      0  2649356  74160     -        0   0.0  0.9 /
   69 Ss     0:32.61   0   0      0  2507432  42324     -        0   0.0  0.5 /
   10 Ss     0:12.99   0   0      0  2458608  13352     -        0   0.0  0.2 /
17432 Ss     0:15.13   0   0      0  2798580  10820     -        0   0.0  0.1 /
   11 Ss     0:27.07   0   0      0  2452852   6076     -        0   0.0  0.1 /
   23 Ss     0:01.38   0   0      0  2461316   4348     -        0   0.0  0.1 /
   21 Ss     0:02.53   0   0      0  2459436   4116     -        0   0.0  0.0 /
   68 Ss     1:08.24   0   0      0  2461216   3596     -        0   0.0  0.0 /
   40 Ss     0:20.31   0   0      0  2453200   3440     -        0   0.0  0.0 /
   14 Ss     0:34.36   0   0      0  2474800   3436     -        0   0.0  0.0 /
  364 Ss     0:04.07   0   0      0  2450680   2468     -        0   0.0  0.0 /
   51 Ss    37:06.24   0   0      0   101452   2228     -        0   0.2  0.0 /
   27 Ss     0:01.30   0   0      0  2448456   1992     -        0   0.0  0.0 /
   39 Ss    12:27.64   0   0      0  2447776   1592     -        0   0.0  0.0 /
   13 Ss     0:02.45   0   0      0  2446968   1540     -        0   0.0  0.0 /
    1 Ss     8:29.82   0   0      0  2456848   1528     -        0   0.0  0.0 /
   93 Ss     0:04.38   0   0      0  2436424   1440     -        0   0.0  0.0 /
20523 Ss     0:05.39   0   0      0  2435292   1148     -        0   0.0  0.0 /
   37 Ss     0:02.34   0   0      0  2445904   1076     -        0   0.0  0.0 /
   48 Ss     0:00.98   0   0      0  2446832    988     -        0   0.0  0.0 a
   77 Ss     0:00.04   0   0      0  2438260    924     -        0   0.0  0.0 /
11253 Ss     0:00.38   0   0      0  2436128    900     -        0   0.0  0.0 /
   15 Ss     0:23.03   0   0      0  2457256    868     -        0   0.0  0.0 /
   42 Ss     0:00.04   0   0      0  2434864    788     -        0   0.0  0.0 /
   12 Ss     0:05.75   0   0      0  2444624    640     -        0   0.0  0.0 /
  366 S      0:00.00   0   0      0  2439212    336     -        0   0.0  0.0 /
```

It can be easier to deal with this much information by outputting it to a file
and opening it with a text editor:

```bash
$ ps -vU root > rootprocs.txt
$ open rootprocs.txt
```

The detailed information provided includes:

* Process ID - The identifier assigned to this process
* State - Indicated by a sequence of characters, the first character indicates
  the run state of the process:

~~~~
I - Idle process (sleeping > 20 seconds)
R - Runnable process
S - Sleeping process ( < 20 seconds )
T - Stopped process
U - Process in uninterruptible wait
Z - Dead (or "Zombie") process
~~~~

Any characters following these indicate additional state information:

~~~~
+ - Process is in foreground process group of its control terminal
< - Process has raised CPU scheduling priority
> - Process has a specified soft limit on memory
A - Process has asked for random page replacement
E - Process is trying to exit
L - Process has pages locked in core (raw Input/Output)
N - Process has reduced CPU scheduling priority
S - Process has asked for First In, First Out page replacements - Process is a session leader
V - Process is suspended during a vfork(2)
W - Process is swapped out
X - Process is being traced or debugged
~~~~

* Time - Real time during which the process has been running
* VSZ - Virtual memory usage of of the process.
* RSS - The real memory (resident set) size of the process in 1024-byte units.
* LIM - The soft limit on memory used specified by the "setrlimit()" system
  call.  The soft limit is the value enforced by the kernel for memory allocated
  to this process.
* %CPU - The CPU utilization of the process; this is a decaying average over up
  to a minute of previous (real) time.  It is possible for the sum of all
  processes to exceed 100%.
* %MEM - The percentage of physical memory used by this process.
* COMMAND - The command that originated the process.

I am not sure what the SL, RE, PageIn, and TSIZ categories stand for.  Any
ideas?

# Usefulness

After the research that went into writing this, I've determined that the most
useful usage of *ps* for me is going to be to supply the "aux" arguments.  These
will display all processes belonging to all users including processes which do
not have a controlling terminal.  This means that typing

```bash
$ ps -aux
```

will display all processes running on the system including information about:

USER - The user account that originated the process PID - Process Identifier
%CPU - See above - CPU utilization of the process %MEM - See above - Percentage
of real memory used by the process VSZ - See above - Virtual memory usage by the
process RSS - See above - Real memory usage of the process TT - Abbreviation for
the pathname of the controlling terminal, if any.  This consists of the three
letters following /dev/tty.  STAT - See above - the current state of the process
STARTED - When the process was started, parsed for humans TIME - See above - how
long the process has been running COMMAND - See above - the command that spawned
the process

Again, it might be useful to output the results of `ps -aux` to a file for
easier viewing than in the terminal window, or for reporting purposes.

I can supply parameters to `ps -aux` to narrow my search, for instance, to
retrieve information about the process with ID 1, I would type

```bash
$ ps aux 1
USER   PID  %CPU %MEM      VSZ    RSS   TT  STAT STARTED      TIME COMMAND
root     1   0.4  0.0  2456852   1532   ??  Ss    9Jun12   8:38.87 /sbin/launch
```

Since I cannot supply a username to `ps -aux` I've found the easiest way to find
information relevant to a particular username would be to pipe the results to
grep and then output the results to a file for reviewing.

```bash
$ ps aux | grep root > rootprocs.txt
```

To wrap this up, `ps` is a very flexible and powerful command.
