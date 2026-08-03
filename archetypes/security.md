---
title: "{{ replace .File.ContentBaseName `-` ` ` | title }}"
date: "{{ .Date }}"
url: "posts/post-url"
categories:
- InfoSec
tags:
- tag1
- tag2
type: post
author: ""
postTheme: "" # accent comes from the category; set to override
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
ShowReadingTime: true
ShowBreadCrumbs: true
ShowPostNavLinks: true
ShowWordCount: true
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
