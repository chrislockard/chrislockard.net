---
title: "Password Manager Advice"
date: "2017-04-17T12:00:00-04:00"
url: "/posts/password-manager-advice"
categories:
- infosec
tags:
- passwords
- 1password
- lastpass
---

A developer at work asked a general question to the group: "I'm thinking about
using either LastPass or 1Password, anything I should know?" As the team's
newest "Security Guy", I answered with this brief response:

> LastPass is easier to get started with as someone who's never used a password
manager before. Their product is seamlessly >integrated into browsers and mobile
devices, although it's not the prettiest.  LastPass stores your encrypted
password vault on their servers. They've been breached or had other security
issues several times (https://en.wikipedia.org/wiki/LastPass), though they have
been transparent with their user community about the events and how they handled
them - this is a Good Thing™ when choosing a password manager.  1Password, by
default, stores your encrypted password vault locally. This is what led me to
originally use it over LastPass You have the option of syncing it across devices
via Dropbox or iCloud, so the security of your vault rests in these third
parties and in the strength of your master password. 1Password also easily
integrates into your browser via their bundled plugin, so it's equally easy to
use as LastPass.

Since I answered this question, I've found [this wonderful technical
writeup][lpvulns] posted by Martin Vigo. In brief, it outlines several
vulnerabilities Vigo discovered that have since been fixed by LastPass, though
more importantly, it describes architectural issues that prevent me from
recommending this password manager now. The most significant two are:

* LastPass does not fully encrypt your password vault, meaning some
  metadata is unencrypted. __Note: I am not saying your usernames and
  passwords are unencrypted__, however, the metadata associated with your
  accounts is not encrypted. Someone with access to your LastPass vault wouldn't
  be able to see your username and password combination, but they would be able
  to tell which (porn or other taboo) sites you've stored your password with.
  Also, Vigo found that the "Forgot password" URL sent by some sites was stored
  unencrypted in the user's vault. If the site owner did not properly code this
  password reset functionality, it's possible that the link still works ergo
  your account could be hijacked by an attacker resetting your password.
* Custom_JS is a javascript payload the LastPass plugin adds to users' password
  vaults in cleartext to handle the situation where the plugin cannot locate the
  username and password field. This code can be loaded and injected in every
  page under a domain. Furthermore, Vigo found that this javascript payload
  stores the user's username and password in cleartext on page load, making it
  possible for LastPass to steal the user's credentials. Storing a user's
  credentials in plaintext in JavaScript variables means a site is one XSS away
  from divulging one LastPass user's credentials if reflected, or possibly all
  LastPass users' credentials if the XSS is stored.

Summary: I retract my LastPass recommendation.

[lpvulns]: http://www.martinvigo.com/even-the-lastpass-will-be-stolen-deal-with-it/
