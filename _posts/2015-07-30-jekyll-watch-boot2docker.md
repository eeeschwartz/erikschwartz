---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-07-30"
permalink: "2015-07-30-jekyll-watch-boot2docker"
---

### Finally got jekyll --watch to work with boot2docker on OSX

[Using](https://github.com/lfucg/next/commit/11e1a889824e64f9e07f8bc546882ee639804377) the undocumented jekyll flag: `--force_polling`

Caveat: [apparently](https://github.com/jekyll/docker-jekyll/issues/14#issuecomment-102879165) it can have ill side effects for larger sites

Now I can run jekyll efficiently (auto-regenerating when I make changes) without having to clutter my machine with extra ruby config!
