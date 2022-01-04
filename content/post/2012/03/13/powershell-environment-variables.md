---
title: "Powershell Environment Variables"
date: 2012-03-13T12:00:00-04:00
url: "/posts/powershell-environment-variables"
categories:
- infosec
tags:
- powershell
summary: "How to determine Powershell environment variables"
showtoc: true
---
Here, I will describe a couple of methods to determine Powershell's environment
variables.

Environment variables correlate names to values of special paths that the host
Operating System relies on for functionality.  For example, Windows hosts use an
environment variable called TEMP to label a folder as the place for applications
to place data that is temporary in nature - such as application installers.

# Method One

```powershell
ls env:
```

That's "ell-ess space env colon."  ls is a Powershell alias for Get-ChildItem,
Powershell's method of listing the child items of an object.  As Powershell
treats everything as an object, directories included, Get-ChildItem will list
the contents of a directory.  (UNIX fans out there will recognize ls - I
speculate that Microsoft added it to provide UNIX users with an intuitive method
to greet the new Powershell.  This was actually the very first command I typed
in Powershell when I first tried it years ago.)

Some might wonder, myself included what the "env:" is.  A few searches reveal
that this is a built-in Powershell folder provided by the Powershell Environment
Provider.  The first rule of tautology club is the first rule of tautology club.
I will cover these in a future article as I'm curious and want to learn more
myself.  For now, it's enough to know that Powershell treats "env:" as a
directory - go ahead and try it!

```powershell
PS C:UsersAdministrator> cd env:
PS Env:> ls
```

From here you can type ls, Get-ChildItem, gci, or whatever your preferred alias
for Get-ChildItem is, and you'll get the same results as our "ls env:"

Here's a TechNet article on managing Environment Variables:
[http://technet.microsoft.com/en-us/library/dd347713.aspx](http://technet.microsoft.com/en-us/library/dd347713.aspx)

# Method Two

```powershell
[Environment]::GetEnvironmentVariables() 
```

Method two uses the static method `GetEnvironmentVariables()` of the .NET class
`[System.Environment]` to list the same information as our `ls env:`  I've been
heavily using Powershell for three or four months now, and I already thought
very highly of it.  The features and scriptability of Powershell have rivaled
any I have used in other environments. I've known conceptually that Powershell
and .NET were intertwined, but it is only within the last week that the extent
of this commingling has made itself clear to me.

Powershell rocks!

More on .NET integration as I learn about it.  For now, note that the [System.]
part of [System.Environment] can be omitted.  For more fun, try piping
[Environment] to Get-Member.
