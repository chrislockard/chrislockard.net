---
title: "iOS and Android Native Code Protections"
date: "2017-06-19T12:00:00-04:00"
url: "/posts/ios-android-code-protections"
categories:
- infosec
tags:
- appsec
- mobile
- android
- iOS
---

# iOS

## Secure Boot Chain

Each step of the startup process contains components that are cryptographically
signed by Apple to ensure integrity and that proceed only after verifying the
chain of trust. This includes the bootloaders, kernel, kernel extensions, and
baseband firmware. This secure boot chain helps ensure that the lowest levels of
software aren’t tampered with.

When an iOS device is turned on, its application processor immediately executes
code from read-only memory known as the Boot ROM. This immutable code, known as
the hardware root of trust, is laid down during chip fabrication, and is
implicitly trusted. The Boot ROM code contains the Apple Root CA public key,
which is used to verify that the iBoot bootloader is signed by Apple before
allowing it to load. This is the first step in the chain of trust where each
step ensures that the next is signed by Apple. When the iBoot finishes its
tasks, it verifies and runs the iOS kernel. For devices with an S1, A9, or
earlier A-series processor, an additional Low-Level Bootloader (LLB) stage is
loaded and verified by the Boot ROM and in turn loads and verifies iBoot.

If one step of this boot process is unable to load or verify the next process,
startup is stopped and the device displays the “Connect to iTunes” screen. This
is called recovery mode. If the Boot ROM isn’t able to load or verify LLB, it
enters DFU (Device Firmware Upgrade) mode. In both cases, the device must be
connected to iTunes via USB and restored to factory default settings. For more
information on manually entering recovery mode, go to
https://support.apple.com/kb/HT1808.

On devices with cellular access, the baseband subsystem also utilizes its own
similar process of secure booting with signed software and keys verified by the
baseband processor.

For devices with a Secure Enclave, the Secure Enclave coprocessor also utilizes
a secure boot process that ensures its separate software is verified and signed
by Apple.

## System Software Authorization

Apple regularly releases software updates to address emerging security concerns
and also provide new features; these updates are provided for all supported
devices simultaneously. Users receive iOS update notifications on the device and
through  iTunes, and updates are delivered wirelessly, encouraging rapid
adoption of the latest security fixes.

The startup process described above helps ensure that only Apple-signed code can
be installed on a device. To prevent devices from being downgraded to older
versions that lack the latest security updates, iOS uses a process called System
Software Authorization. If downgrades were possible, an attacker who gains
possession of a device could install an older version of iOS and exploit a
vulnerability that’s been fixed in the newer version.

On a device with Secure Enclave, the Secure Enclave coprocessor also utilizes
System Software Authorization to ensure the integrity of its software and
prevent downgrade installations. See “Secure Enclave” section that follows.

iOS software updates can be installed using iTunes or over the air (OTA) on the
device. With iTunes, a full copy of iOS is downloaded and installed. OTA
software updates download only the components required to complete an update,
improving network efficiency, rather than downloading the entire OS.
Additionally, software updates can be cached on a local network server running
the caching service on macOS Server so that iOS devices don’t need to access
Apple servers to obtain the necessary update data.

During an iOS upgrade, iTunes (or the device itself, in the case of OTA software
updates) connects to the Apple installation authorization server and sends it a
list of cryptographic measurements for each part of the installation bundle to
be installed (for example, iBoot, the kernel, and OS image), a random
anti-replay value (nonce), and the device’s unique ID (ECID).

The authorization server checks the presented list of measurements against
versions for which installation is permitted and, if it finds a match, adds the
ECID to the measurement and signs the result. The server passes a complete set
of signed data  to the device as part of the upgrade process. Adding the ECID
“personalizes” the authorization for the requesting device. By authorizing and
signing only for known measurements, the server ensures that the update takes
place exactly as provided  by Apple.

The boot-time chain-of-trust evaluation verifies that the signature comes from
Apple and that the measurement of the item loaded from disk, combined with the
device’s ECID, matches what was covered by the signature.

These steps ensure that the authorization is for a specific device and that an
old iOS version from one device can’t be copied to another. The nonce prevents
an attacker from saving the server’s response and using it to tamper with a
device or otherwise  alter the system software.

## Secure Enclave

The Secure Enclave is a coprocessor fabricated in the Apple S2, Apple A7, and
later A-series processors. It uses encrypted memory and includes a hardware
random number generator. The Secure Enclave provides all cryptographic
operations for Data Protection key management and maintains the integrity of
Data Protection even if the kernel has been compromised. Communication between
the Secure Enclave and the application processor is isolated to an
interrupt-driven mailbox and shared memory data buffers.

The Secure Enclave runs an Apple-customized version of the L4 microkernel
family. The Secure Enclave utilizes its own secure boot and can be updated using
a personalized software update process that is separate from the application
processor. On A9 or later A-series processors, the chip securely generates the
UID (Unique ID). This UID is still unknown to Apple and other parts of the
system.

When the device starts up, an ephemeral key is created, entangled with its UID,
and used to encrypt the Secure Enclave’s portion of the device’s memory space.
Except on the Apple A7, the Secure Enclave’s memory is also authenticated with
the ephemeral key.

Additionally, data that is saved to the file system by the Secure Enclave is
encrypted  with a key entangled with the UID and an anti-replay counter.

The Secure Enclave is responsible for processing fingerprint data from the Touch
ID sensor, determining if there is a match against registered fingerprints, and
then enabling access or purchases on behalf of the user. Communication between
the processor and the Touch ID sensor takes place over a serial peripheral
interface bus. The processor forwards the data to the Secure Enclave but can’t
read it. It’s encrypted and authenticated with a session key that is negotiated
using the device’s shared key that is provisioned for the Touch ID sensor and
the Secure Enclave. The session key exchange uses AES key wrapping with both
sides providing a random  key that establishes the session key and uses AES-CCM
transport encryption.

## App Code Signing

Once the iOS kernel has started, it controls which user processes and apps can
be run.  To ensure that all apps come from a known and approved source and
haven’t been tampered with, iOS requires that all executable code be signed
using an Apple-issued certificate. Apps provided with the device, like Mail and
Safari, are signed by Apple. Third-party apps must also be validated and signed
using an Apple-issued certificate. Mandatory code signing extends the concept of
chain of trust from the OS to apps,  and prevents third-party apps from loading
unsigned code resources or using self- modifying code.

In order to develop and install apps on iOS devices, developers must register
with Apple and join the Apple Developer Program. The real-world identity of each
developer, whether an individual or a business, is verified by Apple before
their certificate is issued. This certificate enables developers to sign apps
and submit  them to the App Store for distribution. As a result, all apps in the
App Store have  been submitted by an identifiable person or organization,
serving as a deterrent to  the creation of malicious apps. They have also been
reviewed by Apple to ensure they operate as described and don’t contain obvious
bugs or other problems. In addition to the technology already discussed, this
curation process gives customers confidence in the quality of the apps they buy.

iOS allows developers to embed frameworks inside of their apps, which can be
used  by the app itself or by extensions embedded within the app. To protect the
system  and other apps from loading third-party code inside of their address
space, the system will perform a code signature validation of all the dynamic
libraries that a process links against at launch time. This verification is
accomplished through the team identifier (Team ID), which is extracted from an
Apple-issued certificate. A team identifier is a  10-character alphanumeric
string; for example, 1A2B3C4D5F. A program may link against any platform library
that ships with the system or any library with the same team identifier in its
code signature as the main executable. Since the executables shipping as part of
the system don’t have a team identifier, they can only link against libraries
that ship with the system itself.

Businesses also have the ability to write in-house apps for use within their
organization and distribute them to their employees. Businesses and
organizations can apply to the Apple Developer Enterprise Program (ADEP) with a
D-U-N-S number. Apple approves applicants after verifying their identity and
eligibility. Once an organization becomes a member of ADEP, it can register to
obtain a Provisioning Profile that permits in-house apps to run on devices it
authorizes. Users must have the Provisioning Profile installed in order to run
the in-house apps. This ensures that only the organization’s intended users are
able to load the apps onto their iOS devices. Apps installed via MDM are
implicitly trusted because the relationship between the organization and the
device is already established. Otherwise, users have to approve the app’s
Provisioning Profile in Settings. Organizations can restrict users from
approving apps from unknown developers. On first launch of any enterprise app,
the device must receive positive confirmation from Apple that the app is allowed
to run.

Unlike other mobile platforms, iOS doesn’t allow users to install potentially
malicious unsigned apps from websites, or run untrusted code. At runtime, code
signature checks of all executable memory pages are made as they are loaded to
ensure that an app has not been modified since it was installed or last updated.

### Runtime Process Security

Once an app is verified to be from an approved source, iOS enforces security
measures designed to prevent it from compromising other apps or the rest of the
system.

All third-party apps are “sandboxed,” so they are restricted from accessing
files stored by other apps or from making changes to the device. This prevents
apps from gathering or modifying information stored by other apps. Each app has
a unique home directory for its files, which is randomly assigned when the app
is installed. If a third-party app needs to access information other than its
own, it does so only by using services explicitly provided by iOS.

System files and resources are also shielded from the user’s apps. The majority
of iOS runs as the non-privileged user “mobile,” as do all third-party apps. The
entire OS partition is mounted as read-only. Unnecessary tools, such as remote
login services, aren’t included in the system software, and APIs don’t allow
apps to escalate their  own privileges to modify other apps or iOS itself.

Access by third-party apps to user information and features such as iCloud and
extensibility is controlled using declared entitlements. Entitlements are key
value pairs that are signed in to an app and allow authentication beyond runtime
factors like unix user ID. Since entitlements are digitally signed, they can’t
be changed. Entitlements are used extensively by system apps and daemons to
perform specific privileged operations that would otherwise require the process
to run as root. This greatly reduces the potential for privilege escalation by a
compromised system application or daemon.

In addition, apps can only perform background processing through system-provided
APIs. This enables apps to continue to function without degrading performance or
dramatically impacting battery life.

Address space layout randomization (ASLR) protects against the exploitation of
memory corruption bugs. Built-in apps use ASLR to ensure that all memory regions
are randomized upon launch. Randomly arranging the memory addresses of
executable code, system libraries, and related programming constructs reduces
the likelihood of many sophisticated exploits. For example, a return-to-libc
attack attempts to trick a device into executing malicious code by manipulating
memory addresses of the stack and system libraries. Randomizing the placement of
these makes the attack far more difficult to execute, especially across multiple
devices. Xcode, the iOS development environment, automatically compiles
third-party programs with ASLR support turned on.

Further protection is provided by iOS using ARM’s Execute Never (XN) feature,
which marks memory pages as non-executable. Memory pages marked as both writable
and executable can be used only by apps under tightly controlled conditions: The
kernel checks for the presence of the Apple-only dynamic code-signing
entitlement. Even  then, only a single mmap call can be made to request an
executable and writable page,  which is given a randomized address. Safari uses
this functionality for its JavaScript JIT compiler.

## Extensions

iOS allows apps to provide functionality to other apps by providing extensions.
Extensions are special-purpose signed executable binaries, packaged within an
app.  The system automatically detects extensions at install time and makes them
available  to other apps using a matching system.

A system area that supports extensions is called an extension point. Each
extension point provides APIs and enforces policies for that area. The system
determines which extensions are available based on extension point–specific
matching rules. The system automatically launches extension processes as needed
and manages their lifetime. Entitlements can be used to restrict extension
availability to particular system applications. For example, a Today view widget
appears only in Notification Center,  and a sharing extension is available only
from the Sharing pane. The extension points are Today widgets, Share, Custom
actions, Photo Editing, Document Provider, and Custom Keyboard.

Extensions run in their own address space. Communication between the extension
and the app from which it was activated uses interprocess communications
mediated by  the system framework. They don’t have access to each other’s files
or memory spaces. Extensions are designed to be isolated from each other, from
their containing apps, and from the apps that use them. They are sandboxed like
any other third-party app and have a container separate from the containing
app’s container. However, they share the same access to privacy controls as the
container app. So if a user grants Contacts access to an app, this grant will be
extended to the extensions that are embedded within the app, but not to the
extensions activated by the app.

Custom keyboards are a special type of extension since they are enabled by the
user for the entire system. Once enabled, a keyboard extension will be used for
any text field except the passcode input and any secure text view. To restrict
the transfer of user data, custom keyboards run by default in a very restrictive
sandbox that blocks access to the network, to services that perform network
operations on behalf of a process, and to APIs that would allow the extension to
exfiltrate typing data. Developers of custom keyboards can request that their
extension have Open Access, which will let the system run the extension in the
default sandbox after getting consent from the user.

For devices enrolled in mobile device management, document and keyboard
extensions obey Managed Open In rules. For example, the MDM server can prevent a
user from exporting a document from a managed app to an unmanaged Document
Provider, or using an unmanaged keyboard with a managed app. Additionally, app
developers can prevent the use of third-party keyboard extensions within their
app.

## App Groups

Apps and extensions owned by a given developer account can share content  when
configured to be part of an App Group. It is up to the developer to create  the
appropriate groups on the Apple Developer Portal and include the desired set  of
apps and extensions. Once configured to be part of an App Group, apps have
access to the following:

  * A shared on-disk container for storage, which will stay on the device as
    long as  at least one app from the group is installed
  * Shared preferences
  * Shared Keychain items

The Apple Developer Portal guarantees that App Group IDs are unique across the
app ecosystem.

## Reference:

[Apple iOS Security Guide - March 2017](https://www.apple.com/kr/business-docs/iOS_Security_Guide.pdf)

# Android

## Application Sandbox

The Android platform takes advantage of the Linux user-based protection as a
means of identifying and isolating application resources. The Android system
assigns a unique user ID (UID) to each Android application and runs it as that
user in a separate process. This approach is different from other operating
systems (including the traditional Linux configuration), where multiple
applications run with the same user permissions.

This sets up a kernel-level Application Sandbox. The kernel enforces security
between applications and the system at the process level through standard Linux
facilities, such as user and group IDs that are assigned to applications. By
default, applications cannot interact with each other and applications have
limited access to the operating system. If application A tries to do something
malicious like read application B's data or dial the phone without permission
(which is a separate application), then the operating system protects against
this because application A does not have the appropriate user privileges. The
sandbox is simple, auditable, and based on decades-old UNIX-style user
separation of processes and file permissions.

Because the Application Sandbox is in the kernel, this security model extends to
native code and to operating system applications. All of the software above the
kernel, such as operating system libraries, application framework, application
runtime, and all applications, run within the Application Sandbox. On some
platforms, developers are constrained to a specific development framework, set
of APIs, or language in order to enforce security. On Android, there are no
restrictions on how an application can be written that are required to enforce
security; in this respect, native code is just as secure as interpreted code.

In some operating systems, memory corruption errors in one application may lead
to corruption in other applications housed in the same memory space, resulting
in a complete compromise of the security of the device. Because all applications
and their resources are sandboxed at the OS level, a memory corruption error
will allow arbitrary code execution only in the context of that particular
application, with the permissions established by the operating system.

Like all security features, the Application Sandbox is not unbreakable. However,
to break out of the Application Sandbox in a properly configured device, one
must compromise the security of the Linux kernel.

## System Partition

The system partition contains Android's kernel as well as the operating system
libraries, application runtime, application framework, and applications. This
partition is set to read-only.

## Security-Enhanced Linux (SELinux)

The Android security model is based in part on the concept of application
sandboxes. Each application runs in its own sandbox. Prior to Android 4.3, these
sandboxes were defined by the creation of a unique Linux UID for each
application at time of installation. Starting with Android 4.3,
Security-Enhanced Linux (SELinux) is used to further define the boundaries of
the Android application sandbox.

As part of the Android security model, Android uses SELinux to enforce mandatory
access control (MAC) over all processes, even processes running with
root/superuser privileges (a.k.a. Linux capabilities). SELinux enhances Android
security by confining privileged processes and automating security policy
creation.

Contributions to it have been made by a number of companies and organizations;
all Android code and contributors are publicly available for review on
android.googlesource.com. With SELinux, Android can better protect and confine
system services, control access to application data and system logs, reduce the
effects of malicious software, and protect users from potential flaws in code on
mobile devices.

Android includes SELinux in enforcing mode and a corresponding security policy
that works by default across the Android Open Source Project. In enforcing mode,
illegitimate actions are prevented and all attempted violations are logged by
the kernel to dmesg and logcat. Android device manufacturers should gather
information about errors so they may refine their software and SELinux policies
before enforcing them.

### Mandatory Access Control

Security Enhanced Linux (SELinux), is a mandatory access control (MAC) system
for the Linux operating system. As a MAC system, it differs from Linux’s
familiar discretionary access control (DAC) system. In a DAC system, a concept
of ownership exists, whereby an owner of a particular resource controls access
permissions associated with it. This is generally coarse-grained and subject to
unintended privilege escalation. A MAC system, however, consults a central
authority for a decision on all access attempts.

SELinux has been implemented as part of the Linux Security Module (LSM)
framework, which recognizes various kernel objects, and sensitive actions
performed on them. At the point at which each of these actions would be
performed, an LSM hook function is called to determine whether or not the action
should be allowed based on the information for it stored in an opaque security
object. SELinux provides an implementation for these hooks and management of
these security objects, which combine with its own policy, to determine the
access decisions.

In conjunction with other Android security measures, Android's access control
policy greatly limits the potential damage of compromised machines and accounts.
Using tools like Android's discretionary and mandatory access controls gives you
a structure to ensure your software runs only at the minimum privilege level.
This mitigates the effects of attacks and reduces the likelihood of errant
processes overwriting or even transmitting data.

Starting in Android 4.3, SELinux provides a mandatory access control (MAC)
umbrella over traditional discretionary access control (DAC) environments. For
instance, software must typically run as the root user account to write to raw
block devices. In a traditional DAC-based Linux environment, if the root user
becomes compromised that user can write to every raw block device. However,
SELinux can be used to label these devices so the process assigned the root
privilege can write to only those specified in the associated policy. In this
way, the process cannot overwrite data and system settings outside of the
specific raw block device.

###  Enforcement Levels
 
Become familiar with the following terms to understand how SELinux can be
implemented to varying strengths.
 
```Permissive``` - SELinux security policy is not enforced, only logged.

```Enforcing``` - Security policy is enforced and logged. Failures appear as
EPERM errors.

This choice is binary and determines whether your policy takes action or merely
allows you to gather potential failures. Permissive is especially useful during
implementation.

* Unconfined - A very light policy that prohibits certain tasks and provides a
  temporary stop-gap during development. Should not be used for anything outside
  of the Android Open Source Project (AOSP).

* Confined - A custom-written policy designed for the service. That policy
  should define precisely what is allowed.

Unconfined policies are available to help implement SELinux in Android quickly.
They are suitable for most root-level applications. But they should be converted
to confined policies wherever possible over time to restrict each application to
precisely the resources it needs.

Ideally, your policy is both in enforcing mode and confined. Unconfined policies
in enforcement mode can mask potential violations that would have been logged in
permissive mode with a confined policy. Therefore, we strongly recommend that
device implementers implement true confined policies.

### Labels, Rules, and Domains

SELinux depends upon labels to match actions and policies. Labels determine what
is allowed. Sockets, files, and processes all have labels in SELinux. SELinux
decisions are based fundamentally on labels assigned to these objects and the
policy defining how they may interact. In SELinux, a label takes the form:
user:role:type:mls_level, where the type is the primary component of the access
decisions, which may be modified by the other sections components which make up
the label. The objects are mapped to classes and the different types of access
for each class are represented by permissions.

The policy rules come in the form: allow domains types:classes permissions;,
where:
 
* Domain - A label for the process or set of processes. Also called a domain
  type as it is just a type for a process.
* Type - A label for the object (e.g. file, socket) or set of objects.
* Class - The kind of object (e.g. file, socket) being accessed.
* Permission - The operation (e.g. read, write) being performed.

And so an example use of this would follow the structure:

```allow appdomain app_data_file:file rw_file_perms; `` 

This says that all application domains are allowed to read and write files
labeled app_data_file. Note that this rule relies upon macros defined in the
global_macros file, and other helpful macros can also be found in the te_macros
file, both of which can be found in the system/sepolicy directory in the AOSP
source tree. Macros are provided for common groupings of classes, permissions
and rules, and should be used whenever possible to help reduce the likelihood of
failures due to denials on related permissions.

In addition to individually listing domains or types in a rule, one can also
refer to a set of domains or types via an attribute. An attribute is simply a
name for a set of domains or types. Each domain or type can be associated with
any number of attributes. When a rule is written that specifies an attribute
name, that name is automatically expanded to the list of domains or types
associated with the attribute. For example, the domain attribute is associated
with all process domains, and the file_type attribute is associated with all
file types.

Use the syntax above to create avc rules that comprise the essence of an SELinux
policy. A rule takes the form:

`<rule variant> <source_types> <target_types> : <classes> <permissions>`

The rule indicates what should happen when a subject labeled with any of the
source_types attempts an action corresponding to any of the permissions on an
object with any of the class classes which has any of the target_typeslabel. The
most common example of one of these rules is an allow rule, e.g.:

`allow domain null_device:chr_file { open };`

This rule allows a process with any domain associated with the ‘domain’
attribute to take the action described by the permission ‘open’ on an object of
class ‘chr_file’ (character device file) that has the target_type label of
‘null_device.’ In practice, this rule may be extended to include other
permissions:

`allow domain null_device:chr_file { getattr open read ioctl lock append
write};`

When combined with the knowledge that ‘domain’ is an attribute assigned to all
process domains and that null_device is the label for the character device
`/dev/null`, this rule basically permits reading and writing to
`/dev/null`.

A domain generally corresponds to a process and will have a label associated
with it.
 
For example, a typical Android app is running in its own process and has the
label of `untrusted_app` that grants it certain restricted permissions.
 
Platform apps built into the system run under a separate label and are granted a
distinct set of permissions. System UID apps that are part of the core Android
system run under the system_app label for yet another set of privileges.
 
Access to the following generic labels should never be directly allowed to
domains; instead, a more specific type should be created for the object or
objects:

* `socket_device`
* `device`
* `block_device`
* `default_service`
* `system_data_file`
* `tmpfs`

## Accessing Protected APIs

All applications on Android run in an Application Sandbox. By default, an
Android application can only access a limited range of system resources. The
system manages Android application access to resources that, if used incorrectly
or maliciously, could adversely impact the user experience, the network, or data
on the device.

These restrictions are implemented in a variety of different forms. Some
capabilities are restricted by an intentional lack of APIs to the sensitive
functionality (e.g. there is no Android API for directly manipulating the SIM
card). In some instances, separation of roles provides a security measure, as
with the per-application isolation of storage. In other instances, the sensitive
APIs are intended for use by trusted applications and protected through a
security mechanism known as Permissions.

These protected APIs include:

* Camera functions
* Location data (GPS)
* Bluetooth functions
* Telephony functions
* SMS/MMS functions
* Network/data connections

These resources are only accessible through the operating system. To make use of
the protected APIs on the device, an application must define the capabilities it
needs in its manifest. When preparing to install an application, the system
displays a dialog to the user that indicates the permissions requested and asks
whether to continue the installation. If the user continues with the
installation, the system accepts that the user has granted all of the requested
permissions. The user can not grant or deny individual permissions -- the user
must grant or deny all of the requested permissions as a block.

Once granted, the permissions are applied to the application as long as it is
installed. To avoid user confusion, the system does not notify the user again of
the permissions granted to the application, and applications that are included
in the core operating system or bundled by an OEM do not request permissions
from the user. Permissions are removed if an application is uninstalled, so a
subsequent re-installation will again result in display of permissions.

Within the device settings, users are able to view permissions for applications
they have previously installed. Users can also turn off some functionality
globally when they choose, such as disabling GPS, radio, or wi-fi.

In the event that an application attempts to use a protected feature which has
not been declared in the application's manifest, the permission failure will
typically result in a security exception being thrown back to the application.
Protected API permission checks are enforced at the lowest possible level to
prevent circumvention. 

The system default permissions are described at
[https://developer.android.com/reference/android/Manifest.permission.html](https://developer.android.com/reference/android/Manifest.permission.html).
Applications may declare their own permissions for other applications to use.
Such permissions are not listed in the above location.

When defining a permission a protectionLevel attribute tells the system how the
user is to be informed of applications requiring the permission, or who is
allowed to hold a permission. Details on creating and using application specific
permissions are described at
[https://developer.android.com/guide/topics/security/security.html](https://developer.android.com/guide/topics/security/security.html).

There are some device capabilities, such as the ability to send SMS broadcast
intents, that are not available to third-party applications, but that may be
used by applications pre-installed by the OEM. These permissions use the
signatureOrSystem permission.

## Interprocess Communication

Processes can communicate using any of the traditional UNIX-type mechanisms.
Examples include the filesystem, local sockets, or signals. However, the Linux
permissions still apply.

Android also provides new IPC mechanisms:

* Binder: A lightweight capability-based remote procedure call mechanism
  designed for high performance when performing in-process and cross-process
  calls. Binder is implemented using a custom Linux driver. See
  [https://developer.android.com/reference/android/os/Binder.html](https://developer.android.com/reference/android/os/Binder.html).

* Services: Services (discussed above) can provide interfaces directly
  accessible using binder.

* Intents: An Intent is a simple message object that represents an "intention"
  to do something. For example, if your application wants to display a web page,
  it expresses its "Intent" to view the URL by creating an Intent instance and
  handing it off to the system. The system locates some other piece of code (in
  this case, the Browser) that knows how to handle that Intent, and runs it.
  Intents can also be used to broadcast interesting events (such as a
  notification) system-wide. See
  [https://developer.android.com/reference/android/content/Intent.html](https://developer.android.com/reference/android/content/Intent.html).

* ContentProviders: A ContentProvider is a data storehouse that provides access
  to data on the device; the classic example is the ContentProvider that is used
  to access the user's list of contacts. An application can access data that
  other applications have exposed via a ContentProvider, and an application can
  also define its own ContentProviders to expose data of its own. See
  [https://developer.android.com/reference/android/content/ContentProvider.html](https://developer.android.com/reference/android/content/ContentProvider.html).

While it is possible to implement IPC using other mechanisms such as network
sockets or world-writable files, these are the recommended Android IPC
frameworks. Android developers will be encouraged to use best practices around
securing users' data and avoiding the introduction of security vulnerabilities.

## Application Signing

Code signing allows developers to identify the author of the application and to
update their application without creating complicated interfaces and
permissions. Every application that is run on the Android platform must be
signed by the developer. Applications that attempt to install without being
signed will rejected by either Google Play or the package installer on the
Android device.

On Google Play, application signing bridges the trust Google has with the
developer and the trust the developer has with their application. Developers
know their application is provided, unmodified to the Android device; and
developers can be held accountable for behavior of their application.

On Android, application signing is the first step to placing an application in
its Application Sandbox. The signed application certificate defines which user
id is associated with which application; different applications run under
different user IDs. Application signing ensures that one application cannot
access any other application except through well-defined IPC.

When an application (APK file) is installed onto an Android device, the Package
Manager verifies that the APK has been properly signed with the certificate
included in that APK. If the certificate (or, more accurately, the public key in
the certificate) matches the key used to sign any other APK on the device, the
new APK has the option to specify in the manifest that it will share a UID with
the other similarly-signed APKs.

Applications can be signed by a third-party (OEM, operator, alternative market)
or self-signed. Android provides code signing using self-signed certificates
that developers can generate without external assistance or permission.
Applications do not have to be signed by a central authority. Android currently
does not perform CA verification for application certificates.

Applications are also able to declare security permissions at the Signature
protection level, restricting access only to applications signed with the same
key while maintaining distinct UIDs and Application Sandboxes. A closer
relationship with a shared Application Sandbox is allowed via the shared UID
feature where two or more applications signed with same developer key can
declare a shared UID in their manifest.

## Application Verification

Android 4.2 and later support application verification. Users can choose to
enable “Verify Apps" and have applications evaluated by an application verifier
prior to installation. App verification can alert the user if they try to
install an app that might be harmful; if an application is especially bad, it
can block installation.

##  Reference:

[https://source.android.com/security/][android-1]

[https://source.android.com/security/overview/app-security][android-2]

[https://source.android.com/security/selinux/][android-3]


[android-1]: https://source.android.com/security/
[android-2]: https://source.android.com/security/overview/app-security
[android-3]: https://source.android.com/security/selinux/
