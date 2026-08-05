---
title: "{{ replace .File.ContentBaseName `-` ` ` | title }}"
date: "{{ .Date }}"
url: "posts/post-url"
# Exactly one of: Cyber, Technology, Reflection, Career, Other.
# Cyber when the subject is an attack, a defense, or a risk; Technology when it
# is a tool, a workflow, or a platform. Other is the escape hatch for a topic
# none of the four reach -- use it rather than forcing a bad fit, but once it
# holds ~5 posts on one recurring theme, promote that theme to its own category
# and empty Other back out. The category also picks the post accent via
# data/postthemes.yaml.
categories:
- Technology
tags:
- tag1
- tag2
type: post
author: ""
postTheme: "" # optional accent override: reflection, security, build, roundup, personal
showToc: false
TocOpen: false
draft: false
hidemeta: false
comments: false
description: "Desc Text."
disableHLJS: true # to disable highlightjs
disableShare: false
hideSummary: false
searchHidden: false
ShowReadingTime: false
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: false
ShowRssButtonInSectionTermList: true
UseHugoToc: true
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: true # only hide on current single page
editPost:
    URL: "https://github.com/chrislockard/chrislockard.net"
    Text: "Suggest Changes" # edit text
    appendFilePath: true # to append file path to Edit link
---
