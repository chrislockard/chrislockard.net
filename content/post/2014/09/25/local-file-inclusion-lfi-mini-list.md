---
title: "Local File Inclusion Mini-list"
date: "2014-09-25T12:00:00-04:00"
url: "/posts/local-file-inclusion-mini-list"
categories:
- infosec
tags:
- appsec
- lfi
- windows
- unix
- linux
summary: "A mini-list reference for interesting LFI targets"
---

# Version 0.1

## Linux files

```bash
/etc/passwd
/etc/group
/etc/hosts
/etc/motd
/etc/issue
/etc/bashrc
/etc/apache2/apache2.conf
/etc/apache2/ports.conf
/etc/apache2/sites-available/default
/etc/httpd/conf/httpd.conf
/etc/httpd/conf.d
/etc/httpd/logs/access.log
/etc/httpd/logs/access_log
/etc/httpd/logs/error.log
/etc/httpd/logs/error_log
/etc/init.d/apache2
/etc/mysql/my.cnf
/etc/nginx.conf
/opt/lampp/logs/access_log
/opt/lampp/logs/error_log
/opt/lamp/log/access_log
/opt/lamp/logs/error_log
/proc/self/environ
/proc/version
/proc/cmdline
/proc/mounts
/proc/config.gz
/root/.bashrc
/root/.bash_history
/root/.ssh/authorized_keys
/root/.ssh/id_rsa
/root/.ssh/id_rsa.keystore
/root/.ssh/id_rsa.pub
/root/.ssh/known_hosts
/usr/local/apache/htdocs/index.html
/usr/local/apache/conf/httpd.conf
/usr/local/apache/conf/extra/httpd-ssl.conf
/usr/local/apache/logs/error_log
/usr/local/apache/logs/access_log
/usr/local/apache/bin/apachectl
/usr/local/apache2/htdocs/index.html
/usr/local/apache2/conf/httpd.conf
/usr/local/apache2/conf/extra/httpd-ssl.conf
/usr/local/apache2/logs/error_log
/usr/local/apache2/logs/access_log
/usr/local/apache2/bin/apachectl
/usr/local/etc/nginx/nginx.conf
/usr/local/nginx/conf/nginx.conf
/var/apache/logs/access_log
/var/apache/logs/access.log
/var/apache/logs/error_log
/var/apache/logs/error.log
/var/log/apache/access.log
/var/log/apache/access_log
/var/log/apache/error.log
/var/log/apache/error_log
/var/log/httpd/error_log
/var/log/httpd/access_log
```

## Windows files

```cmd
C:\boot.ini
C:\apache\logs\access.log
C:\apache\logs\error.log
C:\Program Files\Apache Software Foundation\Apache2.2\conf\httpd.conf
C:\Program Files\Apache Software Foundation\Apache2.2\logs\error.log
C:\Program Files\Apache Software Foundation\Apache2.2\logs\access.log
C:\nginx-1.7.4\nginx.conf
C:\nginx-1.7.4\conf\nginx.conf
C:\wamp\apache2\logs\access.log
C:\wamp\apache2\logs\access_log
C:\wamp\apache2\logs\error.log
C:\wamp\apache2\logs\error_log
C:\wamp\logs\access.log
C:\wamp\logs\access_log
C:\wamp\logs\error.log
C:\wamp\logs\error_log
C:\xampp\apache\logs\access.log
C:\xampp\apache\logs\access_log
C:\xampp\apache\logs\error.log
C:\xampp\apache\logs\error_log
```

## Mac OS X files

```bash
/etc/apache2/httpd.conf
/Library/WebServer/Documents/index.html
/private/var/log/appstore.log
/var/log/apache2/error_log
/var/log/apache2/access_log
/usr/local/nginx/conf/nginx.conf
```

## BSD files

```bash
/usr/pkg/etc/httpd/httpd.conf
/usr/local/etc/apache22/httpd.conf
/usr/local/etc/apache2/httpd.conf
/var/www/conf/httpd.conf
/var/www/logs/error_log
/var/www/logs/access_log
/etc/apache2/httpd2.conf
/var/apache2/logs/error_log
/var/apache2/logs/access_log
/var/log/httpd-error.log
/var/log/httpd-access.log
/var/log/httpd/error_log
/var/log/httpd/access_log
```

## Web application files

```bash
/robots.txt
/humans.txt
/style.css
/configuration.php
/wp-login.php
/wp-admin.php
/wp-content/plugins
/include/config.php
/inc/config.php
/include/mysql.php
/inc/mysql.php
/sites/defaults/settings.php
/phpmyadmin/changelog.php
```
