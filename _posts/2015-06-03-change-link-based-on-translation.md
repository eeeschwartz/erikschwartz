---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-06-03"
permalink: "2015-06-03-change-link-based-on-translation"
---

When you translate the page to Spanish, the link sends you to the Spanish survey. Same for French and English.

![Translated site](/images/google-translated-site.png)

I'm not particularly proud of [the brittle implementation*](https://github.com/lfucg/next/commit/55b99d29cf514384f87de8f3fb219e334be7c64e#diff-eacf331f0ffc35d4b482f1d15a887d3bL47) but works for now!

*At the very least it should use the currently selected language like 'es' or 'fr' to switch the link. But I didn't see the value in the Google Translation object.
