---
title: "Manage o365 mail with emacs, mbsync, and mu4e"
date: "2019-11-14T14:45:28-05:00"
url: "posts/o365-mail-emacs-mbsync-mu4e"
draft: false
categories:
- foss
tags: 
- linux
- macOS
- foss
- gnu
- liberty
summary: "Access Office 365 email from (Doom) Emacs with mbsync and mu4e!"
---

One of these days, this blog will be used for more than just notes to myself
again.

# Why?

For the past year, I have been enraptured with Emacs. I've embraced the idea of
extending it into as many facets of my workflow as possible. This post details
how I was able to get my work email setup in mu4e for easy task creation via
org-mode.

For several years, I've been using my inbox as a todo list, filing email into a
complex folder hierarchy. Once I discovered [org-mode](https://orgmode.org/), I
realized that I should use email as an interface for correspondence only. If a
message came in that I should act on at some future point, it should be captured
in my org todo and then discarded. I believe this follows in the principles of
[GTD](https://gettingthingsdone.com/what-is-gtd/).

I'm using:

- [mbsync](http://isync.sourceforge.net/mbsync.html) - mailbox synchronizer
- [mu4e](https://www.djcbsoftware.nl/code/mu/mu4e.html) - mail client
- [Doom Emacs](https://github.com/hlissner/doom-emacs) - Text editor and
  org-mode host

## mbsync

`mbsync` is a mailbox synchronizer that retrieves messages via IMAP from a
remote mailstore and saves them as flat files locally.

### mbsync Configuration

mbsync configuration is performed in `~/.mbsyncrc` (and in fact requires
this file to run). Here's my `~/.mbsyncrc`:

```
IMAPAccount work
Host outlook.office365.com
User user@work.com
PassCmd "security find-generic-password -s NoMAD -w"
SSLType IMAPS
SSLVersion TLSv1.2
AuthMechs PLAIN
# Increase timeout to avoid o365 IMAP hiccups
Timeout 120
PipelineDepth 50

IMAPStore work-remote
Account work

MaildirStore work-local
# Note the trailing slash on the Path statement!
Path ~/.mail/work/
Inbox ~/.mail/work/Inbox
SubFolders Legacy

Channel work
Master :work-remote:
Slave :work-local:
#Include everything
Patterns *
# Sync changes (creations/deletions) with the server
Create Both
Expunge Both
Sync All
```

Verify mbsync is working correctly with `$ mbsync work`.
This will pull down work mail to `~/.mail/work/` with a folder layout
mimicking Exchange's mail folder structure.

Some items to note:

- `Create Both` and `Expunge Both` means mbsync can **delete** messages on your
  mailserver. If you want to try this configuration out in read-only mode, set
  these values to `Create Slave` and `Expunge Slave` instead.
- The trailing slash on the local `MaildirStore` `path` statement is critical!
- My experience with Exchange 365 has been chaotic. I've set a `Timeout 120`
  value to try to ensure there are no sync hiccups. This value has proved useful
  to me, but you can change it or remove it as you see fit.
- mbsync will _not_ delete mail folders on the server. Before you use this tool,
  it might be wise to ensure your Exchange folder hierarchy is as flat as
  possible. This can be done using the Outlook or OWA client.
- `PassCmd` allows you to retrieve credentials from a CLI password manager tool

Now email can be synced and retrieved from the mailserver.

## mu4e

`mu` is a command-line mail client that provides superior mail search
capabilities. Installing this package will automatically pull down mu4e (mu 4
Emacs) as well.

### mu4e Prerequisites

On macOS, install `mu` (which includes mu4e) and `mbsync`. Note that
`mbsync` is part of the _isync_ homebrew collection. These are both
installed in the terminal using homebrew:

```
brew install mu
brew install isync
```

Installing from homebrew should place the required files in
`/usr/local/share/emacs/site-lisp/mu/mu4e` that will be loaded in the
configuration below.

### Run mu

Before using `mu4e` it's a good idea to verify that `mu` works as expected,
after all, `mu4e` uses `mu` as its engine.

To validate, `mu` must first create a mail index. Run:

`$ mu index --maildir=~/.mail/work`

Once this completes, give `mu` a spin:

`$ mu find timecard`

`$ mu find from:myboss`

At this point, mail is synced, indexed, and searchable from Exchange.

## Doom Emacs

I am thoroughly impresed with [Doom
Emacs](https://github.com/hlissner/doom-emacs), and use it as my base.
Configuring this distribution is slightly different from configuring `mu4e` in
vanilla Emacs.

First, security:

### Securely Store SMTP Credentials

SMTP is used to transfer outbound messages. I store my o365 creds in a
gpg-encrypted file, `~/.emacs.d/.authinfo.gpg`

#### Create authinfo file

Enter the credentials for the SMTP server in `~/.authinfo` using the format:

`machine mail.example.com login myusername port 587 password mypassword`

**Use quotes to contain the password**, for instance:

`machine smtp.office365.com login work@email.com password "mypassword" port 587`

#### Encrypt authinfo file

Use gpg to encrypt the authinfo file. (macOS users, install
https://gpgtools.org/. This will place a symlink to the `gpg` CLI tool in your
`/usr/local/bin` so make sure that's in your shell's `$PATH`.

I won't cover the process of creating a keypair in this article, but you can
find more information [here](https://www.gnupg.org/gph/en/manual/c14.html) and
[here.](https://help.runbox.com/creating-key-pair-on-os-x/)

Find the gpg key you want to encrypt this file with using `$ gpg --list-keys`:

```
----------------------------------
...
pub   rsa4096 2019-01-22 [SC] [expires: 2023-01-22]
      315998993D8B8B1BA4AD5D209332E13A9A79C3D5
uid           [ultimate] Chris Lockard <work@email.com>
sub   rsa4096 2019-01-22 [E] [expires: 2023-01-22]
sub   rsa4096 2019-09-09 [S] [expires: 2023-09-08]
sub   rsa4096 2019-09-09 [E] [expires: 2023-09-08]
sub   rsa4096 2019-09-09 [A] [expires: 2023-09-08]
```

Now encrypt `~/.authinfo` using the following:

`$ gpg -se ~/.authinfo`

This prompts for the key to use, so either enter `work@email.com` or
the key signature - `A9A79C3D5`. The output of this program is an
encrypted file, `~/.authinfo.gpg`. For added security, set the permissions on
this file to `chmod 600 ~/.authinfo.gpg`.

Finally, move this file with `mv .authinfo.gpg ~/.emacs.d`
and cleanup the file containing cleartext credentials with `rm .authinfo`.
Emacs will automatically know to look for `~/.emacs.d/authinfo.gpg` which will
help later when configuring SMTP.

### Doom Emacs Configuration

I store my Doom configuration files in my github and link them thusly:

`ln -s ~/Documents/dotfiles/Emacs/.doom.d ~/.doom.d`

Doom defines packages in `~/.doom.d/init.el` with user configuration in
`~/.doom.d/config.el` (or `config.org` for literate config-ers like me :))

### ~/.doom.d/init.el

As `mu4e` is a package only available on the local filesystem, Doom needs to
know from where to load it. The following line is added at the top of the file:

```
;; enabled and in what order they will be loaded. Remember to run 'doom refresh'
;; after modifying it.
;;
;; More information about these modules (and what flags they support) can be
;; found in modules/README.org.

;; This is needed because emacs won't pick up mu4e otherwise:
(add-to-list 'load-path "/usr/local/share/emacs/site-lisp/mu/mu4e/")
(doom! :input

       :completion
...
```

This mu4e path is where Homebrew installed mu4e (from the `mu` package) by
default on macOS Mojave.

Further down `init.el`, uncomment mu4e from the `:email` block:

```
...
       :email
       mu4e       ; WIP
...
```

### ~/.doom.d/config.org{el}

mu4e configuration is placed in `config.org` or `config.el`. Mine looks like this:

```
(after! mu4e
  (setq! mu4e-maildir (expand-file-name "~/.mail/work") ; the rest of the mu4e folders are RELATIVE to this one
         mu4e-get-mail-command "mbsync -a"
         mu4e-index-update-in-background t
         mu4e-compose-signature-auto-include t
         mu4e-use-fancy-chars t
         mu4e-view-show-addresses t
         mu4e-view-show-images t
         mu4e-compose-format-flowed t
         ;mu4e-compose-in-new-frame t
         mu4e-change-filenames-when-moving t ;; http://pragmaticemacs.com/emacs/fixing-duplicate-uid-errors-when-using-mbsync-and-mu4e/
         mu4e-maildir-shortcuts
         '( ("/Inbox" . ?i)
            ("/Archive" . ?a)
            ("/Drafts" . ?d)
            ("/Deleted Items" . ?t)
            ("/Sent Items" . ?s))

         ;; Message Formatting and sending
         message-send-mail-function 'smtpmail-send-it
         message-signature-file "~/Documents/dotfiles/Emacs/.doom.d/.mailsignature"
         message-citation-line-format "On %a %d %b %Y at %R, %f wrote:\n"
         message-citation-line-function 'message-insert-formatted-citation-line
         message-kill-buffer-on-exit t

         ;; Org mu4e
         org-mu4e-convert-to-html t
         ))
(set-email-account! "work@email.com"
                    '((user-mail-address      . "work@email.com")
                      (user-full-name         . "Chris Lockard")
                      (smtpmail-smtp-server   . "smtp.office365.com")
                      (smtpmail-smtp-service  . 587)
                      (smtpmail-stream-type   . starttls)
                      (smtpmail-debug-info    . t)
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-refile-folder     . "/Archive")
                      (mu4e-sent-folder       . "/Sent Items")
                      (mu4e-trash-folder      . "/Deleted Items")
                      (mu4e-update-interval   . 1800)
                      ;(mu4e-sent-messages-behavior . 'delete)
                      )
                    nil)
```

## Usage

Everything is in place to use Doom Emacs as a mail client!

Start Emacs and run `M-x mu4e`:

![Doom mu4e](/images/2019/11-14-1.png)

### Compose a message

Press `C` to bring up the message composition window:

![Compose message](/images/2019/11-14-2.png)

To send a message, place the cursor in the header section (`gg <ESC>`) and then
`SPC m s`. You'll be prompted to enter the passphrase for your gpg key
(sometimes twice) and then your message will send once Emacs decrypts your
`~/.emacs.d/authinfo.gpg` to retrieve SMTP credentials.

### Reply to a message

From the inbox view, press `R` to reply to a message. Fill out your response,
then send the message by again placing point in the message header section
(`gg <ESC>`) and then `SPC m s`.

### Capture a message as a task in orgmode

From the inbox view, select a message with `<Enter>` to open the message view.
With point in the header section (it should be there by default) and press `SPC X` or `M-x org-capture`. With an appropriate [capture
template](https://orgmode.org/manual/Capture-templates.html),
this message will be linked into org mode for use in your GTD workflow.

# References

This specific configuration required referencing many resources. I've included
these below:

Doom Emacs configurations:

- [https://github.com/ragone/.doom.d/blob/master/config.org](https://github.com/ragone/.doom.d/blob/master/config.org)
- [https://gitlab.com/agraul/dotfiles/blob/master/emacs-doom/.doom.d/config.org](https://gitlab.com/agraul/dotfiles/blob/master/emacs-doom/.doom.d/config.org)
- [https://github.com/syl20bnr/spacemacs/issues/4669#issuecomment-232273131](https://github.com/syl20bnr/spacemacs/issues/4669#issuecomment-232273131)

Mbsync configurations:

- [https://unix.stackexchange.com/questions/122773/mbsync-move-subfolders-to-root](https://unix.stackexchange.com/questions/122773/mbsync-move-subfolders-to-root)
- [https://pastebin.com/h5iW6j87]
- [https://www.reddit.com/r/emacs/comments/8q84dl/tip_how_to_easily_manage_your_emails_with_mu4e/](https://www.reddit.com/r/emacs/comments/8q84dl/tip_how_to_easily_manage_your_emails_with_mu4e/)
- [https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/](https://www.reddit.com/r/emacs/comments/bfsck6/mu4e_for_dummies/)
- [http://pragmaticemacs.com/emacs/migrating-from-offlineimap-to-mbsync-for-mu4e/](http://pragmaticemacs.com/emacs/migrating-from-offlineimap-to-mbsync-for-mu4e/)
- [http://pragmaticemacs.com/emacs/master-your-inbox-with-mu4e-and-org-mode/](http://pragmaticemacs.com/emacs/master-your-inbox-with-mu4e-and-org-mode/)
- [https://groups.google.com/forum/#!topic/mu-discuss/ezd3Wyghhgc](https://groups.google.com/forum/#!topic/mu-discuss/ezd3Wyghhgc)
- [https://github.com/kzar/davemail/blob/master/.mbsyncrc](https://github.com/kzar/davemail/blob/master/.mbsyncrc)
