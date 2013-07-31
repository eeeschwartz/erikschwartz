---
author: Erik Schwartz
date: 2013-07-25
layout: post
permalink: kindle-as-second-display
title: Convert a srsly olde kindle into a second display
categories:
- projects
---

Challenge:
-----
The life of a digital nomad/dork wanderer is great in every conceivable way* except that it places limits on your screen real estate. When you have an office/apartment you can set up 2-3 flat panel displays and a monochrome crt news-ticker for the sake of conversation. Not the case when you live out of a couple of carry-ons (schwartography).


<img src="/images/kindle.jpg">

With my latest test-driven development workflow I love being able to fire tests off to a second display without having to leave the editor. It makes me feel like a magician and it just so happens to boost my productivity quite a bit. Both are important, obviously, so I set off to enlist my old but wonderful kindle 3g as a secondary display.


Example Test Workflow with two monitors
I type `, e` in vim and it runs rspec against the most recently visited test file. The rspec output redirects to a log file that I `tail -f` in a terminal on my second display. There are a few bells and whistles that I'll skip but overall it's pretty simple (it's also a great example of treating the whole OS as an IDE, which is a fun and empowering concept - DAS).

So one way or another the kindle needs access to that log file.

First Approach (rejected by management)
Root that bad boy, install a terminal, and ssh to my development machine. A totally valid approach that I still want to play with this someday. But then I remembered that the kindle comes with a weird little experimental browser…

Second Approach (approved by management)
Run a websocket server on my development machine that basically publishes `tail -f test.log` over the web. Turns out that the kindle 3g browser is happy to talk over a websocket so this approach works perfectly. I even hacked together a couple of libraries to create a utility I call ducktail to `tail -f foo.file` over the web.

It's a fun project and a great lesson in the power of the web's open protocols. The websocket approach instantly interoperates with most any device with a browser. Let's say I change my mind and want to use a smartphone as a display instead of a kindle. Absolutely no problem. What kind of phone? Who cares.

It's kind of amazing. I don't have to do anything special to communicate with _the entire world_, just use an agreed upon protocol.
