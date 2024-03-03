---
title: "BSides DC 2013"
date: "2013-10-21T12:00:00-04:00"
url: "/posts/bsides-dc-2013"
categories: 
- infosec
tags:
- infosec
- crypto
- hackers
summary: "Notes from BSides DC 2013"
showtoc: true
---

Some thoughts of mine* from [BSides DC 2013][BSides]:

# Bruce Potter - Keynote

My takeaway from this discussion was that we should all strive to be better
hackers, and moreover, people in general.  Meh, that's simplified and cliche, so
let me expand:

This industry has grown large.  [Very large][Gartner].  What was once the realm
of what I'll call "true" blackhats and whitehats - those adventurers whose sole
purpose was to seek the thrill of hacking offensively and defensively - has had
billions of dollars infused into it over the past two decades.  Now, instead of
attracting people with genuine interest in information systems security, this
industry has swarms of people chasing six-figure incomes.

Mr. Potter asks: "How do we, as an industry, gauge each others' abilities?"  I
think this is a great question to be asking.  "Certifications!" I can hear all
of you HR reps shout.  Hah.  While I hold a couple myself, and I am proud to
have earned them, I agree that these are a poor measure of ability.  I have met
professionals with a CISSP who make it readily apparent they have very little
understanding of how computers, much less computer security works.
Fundamentally.

I've been in interviews with people for a "Senior" position who can't tell me
what the C-I-A triad is.  Look at that Wikipedia article, the triad is right
there at the top, under "Key Concepts."  For a senior position!  To my mind,
this is the equivalent of a "chef" showing up at an interview without an idea of
how an oven works.  The difference is that nobody shows up to an interview to be
a chef who isn't passionate about cooking because they want the luxurious salary
the position commands.  And think about the importance of this industry!  (Not
to say that the safe and tasty cooking of food isn't important!)

When you hear about a security breach at a company or Federal agency resulting
in terrible losses of Personally Identifiable Information (PII) or financial
records and think to yourself "How in the world did they allow THAT to
happen?!", think about the interview for the senior position.  These are (some
of) the people being hired and placed in positions of authority in a topic they
don't understand.

Higher education is another potential solution outlined by Mr. Potter.  I don't
remember the figure he gave, but the number of schools offering a degree with
the phrase "Information Security" is still relatively low.  (Side note: I
graduated with a degree in Information Security and Network Administration in
2008 from a program that was started in 2005) .  Not all degree programs are
created equally, and it's difficult for an interviewer to be able to gauge where
the candidate is by looking at a resume.  In my interviewing experience, we like
to bring the candidate in - largely based on the strength of his or her resume -
and then sit with them for an hour to gauge how well their personality meshes
with the team.  They are then given a practical examination with a handful of
flags to find in the next hour.

There have been a LOT of candidates with strong resumes and good personalities
who sit down and don't know how to use [Linux, Metasploit, Bash, etc] tools.  I
suppose either their education did a poor job of preparing them for actual
penetration testing work, or they've forgotten quite a lot since graduation.
(Another side note: my degree program was LARGELY theoretical; the only hands-on
was a Cisco networking class.  My hope is that institutions are now setting up
capture the flag tournaments and other scenarios to mimic the real world). So,
while higher education programs offering training in these courses is good, it
is still not ideal.

So, how can we, as an industry, fix this?  Mr. Potter mentioned word-of-mouth as
a potential solution.  I agree with him about this, and would go a step further:
my solution is apprenticeships.  I think a meritocracy is demanded in this
industry.  If someone wants to get into the industry, I think there should be a
way for them to meet and match up with someone who outclasses them in skill, and
studies with them for a period of time.  The mentor could, and should, in my
opinion, be paid for this mentorship.

Once the mentor is satisfied with their apprentice, the apprentice can be
entered into a pool of candidates for positions which roughly equate to their
skills.  But how about qualifying the mentors?  Well, that's a trickier problem,
but given the prevalence of information security conferences these days, I don't
see why a regular gathering of speakers and elders in the community couldn't
gather informally to determine these qualifications.  I realize that such a
system would potentially decimate the number of "qualified" information security
candidates, but I think that this is ultimately a Good Thing.

# Bob Weiss - Crypto for Hackers

Cryptography is extremely interesting to me.  The mathematics behind it are
outside of my ken.  The implementation of it, however, is something I like to
try and wrap my head around.  To paraphrase Bruce Schneier from his work,
Secrets and Lies, the development of cryptographic algorithms and the
implementation of cryptographic algorithms are two separate fields.  Mr. Weiss's
talk focused on the history of cryptography, the difference between Symmetric
and Asymmetric cryptography, and the various modes of Asymmetric cryptography
operation.

I had hoped that this talk would focus more on cryptanalysis and the methods by
which an opponent can "break" crypto.  I realize that this traditionally means
bypassing the cryptographic algorithm and attacking a vector that is much less
secure, such as key exchange mechanisms, but it's still interesting, to me, to
hear about how effective the mathematics behind the cryptography are at a
particular point in time.  Mr. Weiss did explain how, twenty years ago, DES was
considered secure because it would take "all of the computers on earth 90 or
more years" to break the encryption.  Well, in the past twenty years, computing
(both serial and parallel) has increased in capability quite dramatically.  A
successful attack on DES can now be completed in much, much less time.  A word
on how effective an attack on AES 128 is, or how to bypass common
implementations of crypto - OpenSSL, perhaps - would have made this talk even
better.

I did pick up a new interview question from it, though :)  Thank you, Mr. Weiss!

I want to thank all of the coordinators and speakers for putting on BSides.  I
hope to contribute to the industry someday soon, and I recognize the effort and
determination it takes to do so.

_Note: These thoughts are my OWN and represent my interpretation of what I
heard at this conference.  I do not claim to speak for any companies or
individuals mentioned._

[Bsides]: http://www.bsidesdc.org
[Gartner]: http://www.gartner.com/newsroom/id/2500115
