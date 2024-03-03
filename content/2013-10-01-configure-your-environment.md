---
title: "Configure Your Environment"
date: "2013-10-01T12:00:00-04:00"
url: "/posts/configure-your-environment"
categories: 
- infosec
tags:
- pentesting
- shell
- configuration
- customization
summary: "Customize your working environment to your liking"
showtoc: true
---

In my last post on Reverse Shell Methods, I discussed the shell a lot.  As a
penetration tester, I spend the majority of my actual "work" time in a shell.  I
leverage Windows, OSX, and Linux about evenly throughout the day, so I've tried
to customize my environment in all three, though I have had substantially more
success tweaking OSX and Linux to my liking.  Today, I want to discuss the way
I've configured my OSX, Kali, and Metasploit  prompts to give me the information
I need when I need it - for example, when you are writing your penetration test
report.

Besides, it's always a good idea to keep track of what you're doing and when
you're doing it!  Always C.Y.A.!

# OSX and Kali

These two Operating Systems rely on the BASH (Bourne-Again SHell), though they
are two different versions.  (OSX 10.8.5 uses version 3.2.48 while Kali uses
4.2.37)  Editing the configuration file for each of these environments is
largely similar, though on OSX I've edited the `~/.bash_history` file, while the
same configuration in Kali is made to the `~/.bashrc` file.  See [Cos's
explanation][StackOverflow] at StackOverflow of when to use `~/.bashrc` versus
`~/.bash_history`.

## Set Vi Mode

This changes the mode of the terminal from Emacs to Vi.  (See [this
article][hypexr] [hypexr.org] for a brief comparison of the two)

```bash
#Changes from Emacs mode to Vi mode.
set -o vi
```

## Update Window Size and Line Wrappings

This checks the window size after each command and, if necessary, updates the
value of LINES and COLUMNS.

```bash
shopt -s checkwinsize
```

## Aliases

I've created a number of aliases that make my day-to-day life easier:

```bash
#Aliases
#Default "list" replacement.  List long, all files, sort by time
#OSX
alias ll="ls -talF"
#Kali
alias ll="ls -alhF"

#Screen aliases
#List screens
alias sl="screen -list"
#Detach/Reattach to a screen
alias sdr="screen -dr"

#list groups
alias groupl="cut -d: -f1 /etc/group"

#Kali - Netstat Numeric
alias nsn="netstat -at --numeric-hosts --numeric-ports"
```

## Customized Terminal Prompt

I get teased a lot at work about the amount of information I have in my prompt,
but it has come in handy on more than one occasion.  Without endeavoring to
explain each of these commands here, I invite you to read up on [Bash Prompt
Customization][GoogleBash].  The following is mine:

OSX Terminal:

```bash
export PS1="\[$(tput bold)\]\[$(tput setaf 161)\]\D{%Y-%m-%d} \[$(tput setaf 126)\] \t \[$(tput setaf 103)\] \! \[$(tput setaf 60)\] \u@\h \[$(tput setaf 250)\]\n \w \$ \[$(tput sgr0)\]"
```

Kali Terminal:

```bash
ip=$(hostname -I)
export PS1="\[$(tput bold)\]\[$(tput setaf 161)\] \D{ %Y-%m-%d} \[$(tput setaf 126)\] \t \[$(tput setaf 103)\] \! \[$(tput setaf 60)\] \u@$ip \[$(tput setaf 250)\]\n \w \$ \[$(tput sgr0)\]"
```

## Terminal Activity Logging

Use the `script` utility to log all terminal command activity.  This, combined
with a prompt that includes your IP and a timestamp, will support your activity
and can prevent a lot of unpleasantness if your activities are called into
question.

```bash
script ~/assessment/notes/<date>.txt
```

If you are using multiple tabs or windows, or you come back to your assessment
after a few days, be sure to add -a to script to append your findings:

```bash
script -a ~/assessment/notes/<date>.txt
```

Always remember to log your activity!  It sucks, I know, but it's very
important.

# Metasploit Framework - msfconsole

The Metasploit Framework's msfconsole can have its prompt customized as well.
The configuration file for this is stored at `~/.msf4/msfconsole.rc`.  (Note: if
this file doesn't exist, you can create it)

```bash
setg PROMPT %clr%T%clr %und%L%und%clr msf%clr
```

This will add the day, time (to the second) and your current IP address to your
msfconsole prompt.

## Spooling

Spooling will log the output of your msf session to a file you specify.  This is
super handy, and can be invaluable when someone comes to you asking why you
brought their system down.

Enable Spooling:

```bash
msf> spool ~/assessment/msflog.txt
```

Disable Spooling:

```bash
msf> spool off
```

Note that spooling can only track one msf instance per screen session.  If you
have multiple screens containing multiple instances of msf on the same host,
only one will reliably log with spool.

[StackOverflow]: http://stackoverflow.com/questions/415403/whats-the-difference-between-bashrc-bash-profile-and-environment
[hypexr]: http://www.hypexr.org/bash_tutorial.php#emacs
[GoogleBash]: https://www.google.com/search?q=bash+prompt+customization&oq=bash+prompt+customization
