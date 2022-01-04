---
title: "PHP, MySql, and Injection"
date: "2014-11-26T12:00:00-04:00"
url: "/posts/php-mysql-injection"
categories:
- infosec
tags:
- appsec
- php
- mysql
- injection
- coding
---
Inspired by Jack Daniel's ["Shoulders of InfoSec Project"][Shoulders], this post
will be focused on the people and technologies behind one of the most prevalent
attacks on web sites: SQL injection.

According to OWASP, injection is the number one attack vector for web
applications. Injection attacks can target many different contexts in a web
application: HTML, PHP, ASP, Javascript, SQL, etc. Any context in which an
interpreter parses input to execute instructions is potentially vulnerable to an
injection attack. There are several - many, rather - excellent tutorials on
[Injection attacks][OWASP-Injection] available on the web. Here's a brief
selection of SQL injection attacks for reference:

* [Mavituna's SQLi Cheat Sheet][Mavituna]
* [Pentest Monkey's SQLi Cheat Sheet][PentestMonkey]
* [OWASP - SQL Injection][OWASP-SQL]

I will describe the background of the technologies that came together to make
SQL Injection attacks so prevalent on the web, since I believe [context is
important][context]. I will focus primarily on PHP and its connectivity to MySQL
as a database back-end [due to the ubiquity with which this technology stack
drives the current web][phpusage].

# Background

The early World Wide Web served static content. This content was served in the
form of text and images glued together using [Tim Berners-Lee's][TBL-W3C] Hyper
Text Markup Language (HTML).

{{< figure src="/images/2014/11-26-1.jpg" caption="Sir Tim Berners-Lee" >}}

He and his friends [Dave Raggett][DR-W3C], [Roy Fielding][RF-W3C], [et.
al][RFC2616] created the HyperText Transfer Protocol (HTTP) that we all rely
upon so much today.

A typical early web browsing session looked like this, logically:

~~~~
Client-side|    User (Browser)<===> HTTP <===> Static Content (HTML, JPG, etc) | Server-side
~~~~

> Clients (web browsers) make requests to web servers for HTML files and images
> using HTTP as the communication protocol.

This is fundamentally how the web works today.

During the early web, most user sessions with a web site were non-interactive.
Users would browse to a website, read its content and view its images, then move
on to the next. Any interaction with the site consisted of e-mailing the
"webmaster" - an archaic term for the site's owner or operator. This worked well
for small sites owned and operated by individuals and hosted for free (_cough_
[GeoCities][GeoCities], _cough_ [Angelfire][AngelFire]).

Owners of large sites, companies, and visionaries soon realized the need for a
website to be interactive. Companies wanted their customers to make purchases
directly from an online catalog rather than staffing a phone center to handle
customer calls. Large sites wanted their users to interact with each other
directly, rather than via e-mail or newsgroups, so that the owners could reap
advertising revenues.

These types of dynamic interaction with a website just weren't prevalent in the
days of the early web because of the static nature of a user's session with a
website.

# What Changed?

So, how did the gap between static content and dynamic interaction get bridged?

CGI.

Not the imagery effects in movies, but the [Common Gateway Interface][CGI-W3C].
The Common Gateway Interface allows an HTTP server and a CGI script to share the
responsibility of responding to client requests. These client requests are made
up of:

* A [Uniform Resource Identifier (URI)][URI] - typically a Uniform Resource
  Locator (URL)
* A request method as outlined in the [HTTP specification][RFC2616] - typically
  GET, or POST, but there also exist HEAD, PUT, DELETE, TRACE, and CONNECT, and 
* Various ancillary information about the request provided by the Transport
  Protocol.

Let's look at an example client request to a webserver:

~~~~
GET /index.php HTTP/1.1
Host: penetrate.io
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Firefox/31.0 Iceweasel/31.2.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
~~~~

* On the first line, `GET` indicates the request method
* The `/index.php` on the first line, along with the second line define the URL,
  or resource being requested from the web server
  (http://penetrate.io/index.php)
* Lines 3-7 include the ancillary information making up the rest of the request

Web server software receives requests like these and returns the corresponding
resource to the user's web browser. Together with a programmatic interface, such
as PHP, CGI allows programmers to use requests like these to return custom
tailored responses to the user's web browser.

CGI is the "glue" that allows a web server to return dynamic content to the
user's web browser instead of static content.

[RFC 3875](http://www.ietf.org/rfc/rfc3875) outlines these rules which allow
systems programmers to implement the CGI.

Today, Apache and other web servers have implemented their own, more efficient,
modules to perform the duties of CGI. You can configure these parameters in your
apache `httpd.conf` files.

Now, what about the "Programmatic Interface" I mentioned? This is where PHP
comes into play.

# PHP: Better, Faster, Stronger.... not harder

The basis of PHP was created by Rasmus Lerdorf in 1995. He wrote a CGI binary in
the C programming language for use with the Apache web server with the intent of
displaying his resume on his personal web site (PHP used to stand for "Personal
Home Page", [but no longer][php-not-php]). The major advantage of Lerdorf's
Personal Home Page application was that his code could be embedded directly in
the HTML file calling it, reducing complexity for the programmer and overhead
for the web server.

In 1997, Zeev Suraski and Andi Gutmans re-wrote and extended the capability of
the PHP parser, and this became the basis of php3, and modern PHP running on the
so-called "Zend engine." This is the name of the guts of the PHP binary that
interprets PHP code and tells the web server how to process it - aka. the
interface. Very quickly, the maintainers of the Apache Server Foundation
(including Mr. Fielding) realized the importance of this rising language.

This was HUGE. Ease of development of web applications was tremendously helped
by the advent of PHP on the Zend engine. LAMP and WAMP (Windows, Apache, MySQL,
and PHP) servers began shooting up with the Zend library included. Developers no
longer had to worry about configuration and compiling the correct PHP binary
against the proper Apache binary, they could just work on coding the
application.

Note that: 
* PHP was not the only language rising in popularity at the time
for web: MSFT was developing ASP running on their IIS web server.
* The Apache Server software began incorporating the functionality of CGI and its
successors into modules for the server 
* Today, instead of a CGI application handling requests for files in the
/cgi-bin/ directory, Apache itself parses
PHP requests using "libphp5.so" found in /etc/httpd/modules 
* Many major sites are built upon PHP, including
[Wordpress](https://www.wordpress.org), [Wikipedia](https://www.wikipedia.org),
and [Facebook](https://salimvirani.com/facebook/).

# Popularity Problems

But what does all of this have to do with SQL Injection attacks? A lot!

The ease with which PHP allowed developers to build dynamic web sites was
unprecedented. More and more dynamic sites were popping up on the web As I
mentioned earlier, the major difference between a static site and a dynamic site
is user interaction. The results of this interaction were often stored in a
relational database, and, in PHP's case, the database of choice was (and is)
[MySQL][MySQL].

MySQL's combination of performance, feature set, and open source ideology (not
to mention the price: free) made it the leading database of choice to group with
Linux, PHP, and Apache. These technologies are also free and mostly open-source
(except PHP). Site owners and developers took to using this technology stack en
masse. Sites running PHP and MySQL began shooting up as more and more site
owners were learning to deploy PHP to create sites with dynamic content.
[PHP.net keeps a rough estimate][phpusage] of the number of sites running PHP
technology - note the chart is logarithmic.

What can go wrong with a technology that allows users to interact with web
servers through their web browser over the Internet?

# PHP and MySQL: Injection Heaven (potentially...)

Let's take a look at how PHP communicates with MySQL from the standpoint of a
web site owner, Paul, who knows enough to be dangerous and has Google. Paul
wants to create a member login for his web site's visitors. After searching
Google for "php mysql user login" he's found a nice tutorial on [one of the top
search results][phptut].

This tutorial includes reassuring information for Paul, such as

> Why we are using POST not GET method?  We are using POST method because it is
> secure...

Reassured, Paul begins to implement his new user login. After getting MySQL and
Apache set up, Paul sets about writing his login page. Here's the code Paul's
managed to get working:

```php
<?php
define('DB_HOST', 'localhost');
define('DB_NAME', 'test');
define('DB_USER','root');
define('DB_PASSWORD','');

$connection = mysql_connect(DB_HOST,DB_USER,DB_PASSWORD) or die("Error connecting to MySQL:" .  mysql_error());
$databse = mysql_select_db(DB_NAME, $connection) or die("Error connecting to MySQL:" .  mysql_error());

/*
$ID = $_POST['user'];
$Password = $_POST['pass'];
*/
function SignIn()
{
session_start();
if(!empty($_POST['user']))
{
    $query = mysql_query("SELECT * FROM UserName where userName = '$_POST[user]' AND pass =     '$_POST[pass]'") or die(mysql_error());
    $row = mysql_fetch_array($query) or die(mysql_error());

    if(!empty($row['userName']) && !empty($row['pass']))
    {
        $_SESSION['userName'] = $row['pass'];
        echo "SUCCESSFUL LOGIN!";
    }
    else
    {
        echo "ERROR LOGGING IN!";
    }
}
}
if(isset($_POST['submit']))
{
    SignIn();
}
?>
```

Everything seems to be working well, as Paul can enter his username and password
here:

{{< figure src="/images/2014/11-26-2.png" caption="sqli-login" >}}

And is successfully logged in here: successful-login

{{< figure src="/images/2014/11-26-3.png" caption="successful login" >}}

PHP's ease of use and widespread popularity has lead to countless websites being
developed in a similar fashion: slapdash and without much thought with security
in mind. (My colleagues and I refer to them as "StackOverflow" sites) Besides
the "POST is a secure method" chestnut from this site, what else is wrong with
this code?

* The PHP file connects to MySQL using the "root" or superuser login.
* There is no sanitization of the data being passed into the "$query" variable -
  we'll see how to exploit, then fix, this vulnerability shortly.
* The deprecated mysql_connect() function is being used - this is systemic of
  these slapdash tutorials: the easiest method to get things working is used,
  and even when the listed functionality [has been deprecated][php-deprecation],
  tutorials are often not revised.

How can this be exploited?

# Injection Exploitation

Let's focus on the core functionality of this code, this line here:

```sql
$query = mysql_query("SELECT * FROM UserName where userName = '$_POST[user]' AND pass =     '$_POST[pass]'") or die(mysql_error());
```

This PHP code is telling the PHP CGI to take the value submitted by the user's
browser, stored in `$_POST[user]` and pass it to the MySQL context using the
`mysql_query()` function. The MySQL context executes an instruction and returns
the result to `$query` At the start of this post, I said "Any context in which
an interpreter parses input to execute instructions is potentially vulnerable to
an injection attack." This code fits the bill.

This code presents the user with the opportunity to inject valid SQL commands
into the login page instead of a username or password, though Paul doesn't
realize this. We want to bypass the username requirement altogether. The
application expects us to enter a username and password here:

{{< figure src="/images/2014/11-26-4.png" caption="sqli login" >}}

Instead, let's enter ' or 1=1; --:

{{< figure src="/images/2014/11-26-5.png" caption="sqli login bypass" >}}

{{< figure src="/images/2014/11-26-6.png" caption="sqli-login-bypass-success" >}}

What we've done is _injected_ a valid SQL command into the MySQL context,
through the PHP CGI. The PHP CGI sent the MySQL backend our injection through
the ancillary information stored in `$_POST[user]`. Paul only expected users to
enter valid usernames and passwords like "admin" and "supersecret" in the login
page. The PHP CGI stores these in the `$_POST[user]` and `$_POST[pass]`
variables, so Paul expected his application to send the MySQL server this query:

```php
$query = mysql_query("SELECT * FROM UserName where userName = 'admin' AND pass = 'supersecret") or die(mysql_error());
```

Instead, our injection has sent the MySQL server this query:

```php
$query = mysql_query("SELECT * FROM UserName where userName = '' or 1=1; -- AND pass = '') or die(mysql_error());
```

This is a valid query, so the MySQL context doesn't throw an error up. The
condition `or 1=1` always evaluates to `true` and the `; --` characters tell the
MySQL context that the query ends after `1=1` and the rest of the command is
commented out, invalidating it.

This is a classic, old-as-dust example of a SQL injection attack against PHP and
MySQL, but it still works based on a tutorial written _about one month ago_.
In 2014. These types of attacks are far too common!

# Let's Remediate This Injection

Following in the "easiest solution gets implemented" mindset I criticized this
vulnerable code of, Paul could add the `addslashes()` function to his code like
this:

```php
$query = mysql_query("SELECT * FROM UserName where userName = . addslashes('$_POST[user]') . AND pass = . addslashes('$_POST[pass]')") or die(mysql_error());
```

Now, when we attempt to enter `' or 1=1; --` as the username, we are greeted
with the following error:

{{< figure src="/images/2014/11-26-7.png" caption="sqli addslashes" >}}

The easiest method isn't the most complete, and I've already spent several
paragraphs pointing this out.

# A More Robust Solution: Prepared Statements using PDO

[PHP Data Objects (PDO)][PDO] is a robust database driver allowing PHP to
communicate with several database backends, including MySQL. One of the key
security features offered by PDO is the ability to create Prepared Statements.
Prepared statements separate SQL code from data by building a valid SQL query
(the code) and inserting data only into parameters specified by the developer.
PDO takes a little more effort to construct, but Paul could just as easily use
the following code to better implement his login:

```php
<?php
    $dbh = new PDO('mysql:host=localhost;dbname=test','root','');
    $dbh->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    $dbh->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $query = $dbh->prepare( "SELECT * FROM UserName WHERE userName = :username AND pass = :password");
    $query->bindValue( ':username', $_POST['user'] );
    $query->bindValue( ':password', $_POST['pass'] );

    if( $query->execute() ) {
        $num_rows = $query->fetchAll( PDO::FETCH_ASSOC );
    }

    echo '<pre>';
    print_r( $num_rows );
    echo '</pre>';
?> 
```

Paul uses PDO to construct the SQL query and parameterizes the data he expects,
using the `bindValue` method. PDO thus constructs the executable portion of the
query as:

```php
"SELECT * FROM UserName WHERE userName = :username AND pass = :password"
```

`bindValue` tells PDO that the values substituted for `:username` and
`:password` are the data portion of the query and are not to be treated as valid
SQL commands. As a bonus, PDO escapes the input it binds to `:username` and
`:password`, so even if we tried entering valid SQL commands, PDO would tell the
PHP CGI it has encountered an error and the attempted SQL injection will not
work.

Additional solutions for remediating this vulnerability in PHP include:

* [Using stored procedures][StoredProcedures]
* [Sanitizing user input][Sanitize User Input]
* [Database connectivity using "least privilege" principle][Least Priv]
* [White listing user input][Whitelist]

Combining several of these options would provide for the ideal defense-in-depth
characteristic that would successfully help keep Paul's site secure. However, no
defense is perfect, and critical functionality - such as user login and
authorization - should be reviewed periodically to ensure that the current best
practices for defense are being applied. Implementing these defenses take time
and expertise, two things Paul may or may not have, which is why so many
vulnerable sites exist on the web.

# Summary

I've discussed the history of several technologies that have brought the web to
its current state, and the SQL Injection vulnerabilities present in one of the
most influential. I hope this post has been educational to you, not just in the
technique of SQL injection, but in providing some situational awareness so you
can better understand how this rose to be the top attack against websites today.

[Shoulders]: http://blog.uncommonsensesecurity.com/2014/10/introducing-shoulders-of-infosec-project.html
[OWASP-Injection]: https://www.owasp.org/index.php/Top_10_2013-A1-Injection
[Mavituna]: http://ferruh.mavituna.com/sql-injection-cheatsheet-oku/
[PentestMonkey]: http://pentestmonkey.net/cheat-sheet/sql-injection/mysql-sql-injection-cheat-sheet
[OWASP-SQL]: https://www.owasp.org/index.php/SQL_Injection
[context]: http://tinypic.com/view.php?pic=j8k0mp&s=5
[phpusage]: http://php.net/usage.php
[TBL-W3C]: http://www.w3.org/People/Berners-Lee/
[DR-W3C]: http://www.w3.org/People/Raggett/
[RF-W3C]: http://en.wikipedia.org/wiki/Roy_Fielding
[RFC2616]: http://tools.ietf.org/html/rfc2616
[GeoCities]: http://en.wikipedia.org/wiki/GeoCities
[AngelFire]: http://en.wikipedia.org/wiki/Angelfire
[CGI-W3C]: http://www.w3.org/CGI/
[URI]: http://en.wikipedia.org/wiki/Uniform_resource_identifier
[RFC3875]: http://www.ietf.org/rfc/rfc3875
[php-not-php]: http://php.net/manual/en/faq.general.php#faq.general.acronym
[Wikipedia]: https://www.wikipedia.org
[Wordpress]: https://www.wordpress.org
[Facebook]: https://www.facebook.com
[MySQL]: http://www.mysql.com
[phptut]: http://mrbool.com/how-to-create-a-login-page-with-php-and-mysql/28656
[php-deprecation]: http://php.net/manual/en/function.mysql-connect.php
[PDO]: http://php.net/manual/en/class.pdo.php
[StoredProcedures]: https://www.owasp.org/index.php/SQL_Injection_Prevention_Cheat_Sheet#Defense_Option_2:_Stored_Procedures [Sanitize User Input]: http://codex.wordpress.org/Validating_Sanitizing_and_Escaping_User_Data [Least Priv]: https://www.owasp.org/index.php/SQL_Injection_Prevention_Cheat_Sheet#Least_Privilege
[Whitelist]: https://www.owasp.org/index.php/SQL_Injection_Prevention_Cheat_Sheet#White_List_Input_Validation
