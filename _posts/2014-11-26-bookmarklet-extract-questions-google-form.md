---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: true
date: 2014-11-26
permalink: "2014-11-26-bookmarklet-extract-questions-google-doc"
title: A Bookmarklet to extract questions from a google form
---

Generally speaking I prefer to write Google Forms outside of the browser, usually in Evernote. The writing is stored automatically and is availble across devices. I also find that I concentrate better outside of the form. Sometimes the questions require some real chin scratching and I find that the Google Forms interface lends itself to rush. I just want to take it [nice and slow](https://www.youtube.com/watch?v=RQeZZnwmuMo) like Usher.

### Bookmarklet to rescue the questions from the Google Form

Drag this bad boy to the bookmarks toolbar: <a href="javascript:void(function () {
var jsCode = document.createElement('script');
jsCode.setAttribute('src', 'https://gist.githubusercontent.com/eeeschwartz/6086efb174d6dc076fc6/raw/main.js');
document.body.appendChild(jsCode);
}())">Extract Qs</a>. Give it a click when you're on the form page. Source [here](https://gist.github.com/eeeschwartz/6086efb174d6dc076fc6).

### The unsuspecting form beforehand:

![image](/images/google-form.png)

### The fully shocked form afterwards, questions extracted big time:

![image](/images/google-form-extracted.png)
