---
# Documentation: https://sourcethemes.com/academic/docs/managing-content/

title: "Add MFA to Fedora with Yubikey"
subtitle: ""
summary: "Add MFA to sudo and gnome in Fedora using a Yubikey and authselect"
url: "/posts/yubikey-mfa-fedora"
authors: []
categories:
- infosec
tags:
- fedora
- yubikey
- yubico
- mfa
- u2f
date: 2021-05-03T20:14:35-04:00
lastmod: 2021-05-03T20:14:35-04:00
featured: false
draft: false

# Featured image
# To use, add an image named `featured.jpg/png` to your page's folder.
# Focal points: Smart, Center, TopLeft, Top, TopRight, Left, Right, BottomLeft, Bottom, BottomRight.
image:
  caption: ""
  focal_point: ""
  preview_only: false

# Projects (optional).
#   Associate this post with one or more of your projects.
#   Simply enter your project's folder or file name without extension.
#   E.g. `projects = ["internal-project"]` references `content/project/deep-learning/index.md`.
#   Otherwise, set `projects = []`.
projects: []
---

This post is really meant to complement Willi Mutschler's [already
excellent][willi] guidance for enabling [mfa][mfa] in Fedora using Yubikey
hardware tokens. I enabled MFA authentication for my Fedora 34 installation just
moments ago following these steps using a Yubikey 5 NFC and a backup Yubikey 5C
Nano. 

The end result is that I need to present my yubikey when logging into my laptop
and when elevating privileges using `sudo`. 👏 

I'll reprint the relevant steps here in case Willi's site is lost:

READ ALL OF THE FOLLOWING STEPS CAREFULLY AND TRY THEM OUT IN A VIRTUAL MACHINE
BEFORE MODIFYING YOUR LIVE WORKSTATION! 

DO NOT CLOSE THE TERMINAL WINDOW DURING THIS PROCESS OR RISK LOSING ACCESS TO
YOUR COMPUTER! WAIT UNTIL YOU'VE VERIFIED EVERYTHING WORKS BEFORE CLOSING IT!

__Enabling MFA__

Install Prerequisites:

```
$ sudo dnf install yubikey-manager ykclient ykpers pam_yubico pam-u2f pamu2fcfg
```

Ensure PIV support is present on the Yubikey device:

```
$ ykman info 
```

Use [authselect][authselect] to preview and apply changes:

```
$ sudo authselect test sssd with-pam-u2f-2fa without-nullok
$ sudo authselect select sssd with-pam-u2f-2fa without-nullok
```

Create Yubikey config directory and enroll devices using `pamu2fcfg`:

```
$ mkdir ~/.config/Yubico
$ pamu2fcfg > ~/.config/Yubico/u2f_keys # When device flashes, press it to
confirm association
$ pamu2fcfg -n >> ~./config/Yubico/u2f_keys # Repeat enrollment with backup devices
```

LEAVE THIS TERMINAL OPEN TO TEST EVERYTHING WORKS AS EXPECTED OR RISK LOSING
ACCESS TO YOUR COMPUTER!

Open a second terminal to test that everything works by confirming you're
prompted to touch the Yubikey when elevating privileges:

```
$ sudo echo test
Please touch the device.
[sudo] password for chris: 
```

If this succeeds, then all is well and the first terminal can be closed. MFA
is now enabled at gdm auth and terminal sudo!

GDM doesn't do the best job walking one through login with U2F MFA enabled.

After selecting your username, you should see the yubikey blink (waiting for a
touch) and the text "Please touch the device" displayed. Once you've touched the
device, this message will disappear and you should now enter your password and
press enter.

If you don't see this message, unplug and re-plug your yubikey in.

__Disabling MFA__

If you need to disable MFA, use authselect to search for and select the minimal
auth configuration:

```
$ sudo authselect list
- minimal	 Local users only for minimal installations
- nis    	 Enable NIS for system authentication
- sssd   	 Enable SSSD for system authentication (also for local users only)
- winbind	 Enable winbind for system authentication
```

(Optional) Preview authselect changes:

```
$ sudo authselect test minimal 
```

Remove MFA:

```
$ sudo authselect select minimal
```

This command removes the MFA configuration and allows you to use your
workstation as you did previously.

# Recovering a System with MFA

Update 2021-05-23: Today, for whatever reason, Gnome and gdm wouldn't prompt me
for my YubiKey. Fedora 34 has a disabled root account, so I was effectively
locked out of my workstation.

The solution was to run a liveUSB of Fedora and perform the following:

1. Unlock the btrfs boot volume by opening Files > Other Locations > Encrypted
   volume
2. Right-click > Open in Terminal. This should place you in the path at the root
   of your btrfs file system. Using the Fedora 34 live image, this was
   `/run/media/liveuser/fedora_localhost-live/`. `@` and `@home` are my two
   btrfs subvolumes.
3. Elevate privileges to root using `su -`
4. As root, start a chroot to the system subvolume with `chroot
   /run/media/liveuser/fedora_localhost-live/@`
5. Remove the MFA configuration as performed above with `authselect select
   minimal`

Reboot, and you should be able to authenticate in Gnome using only your password.

[mfa]: https://en.wikipedia.org/wiki/Multi-factor_authentication
[willi]: https://mutschler.eu/linux/install-guides/fedora-post-install/#yubikey-two-factor-authentication-for-adminsudo-password
[authselect]: https://github.com/authselect/authselect
