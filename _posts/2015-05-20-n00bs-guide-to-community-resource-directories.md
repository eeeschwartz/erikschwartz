---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-05-20"
permalink: "2015-05-20-n00bs-guide-to-community-resource-directories"
---

## Resource directories are harder than they appear

Building a community resource locator is deceptively easy to do. "Just scrape the data and make a nice interface!" Turns out it's thornier than that. Keeping the data fresh and correct is the ultimate challenge, otherwise people don't trust your fancy pants search interface. And to keep the data fresh requires all sorts of institutions and people to get on board. "What! It's a community building problem?" That's right developer, it's largely a people problem. Tech is a surprisingly small piece of the puzzle.

So I've pinged a few people with a lot more experience than I have to come up with a n00bs guide to piloting a treatment directory project:

### Focus on the hard part

The hard problem with a directory project is that keeping the information up to date takes a good deal of effort. Many people maintain their own scattered listings, whether front-line workers or professional aggregators, but don't have a good incentive to contribute to a larger project.

### Find reliable data maintainers

The key is finding a few of these people who are willing to work with you take on the role of data maintainer. This would mean they log in to your website as often as needed to keep the info current.

Hopefully you have some ideas about ways to appeal to them. Perhaps they'd be interested to search their listings on a user-friendly website, if only so that they can sync information with their co-workers.

### Start with a small resource domain

I also heard to start with a small service area so that the problem is more manageable. Focus on a handful of relationships, get a few reliable data maintainers, and slowly build a user base around good, trustworthy information.

### Find ways to prove the value

From there, you'll ideally have success stories. Hopefully this will be hard numbers from people who can show how much better they are able to serve clients with this rich source of information. It could also be stories from service recipients who are happier and healthier thanks to a service they wouldn't have found otherwise.

### Keep the long-game in mind

With good data maintainers, good institutional partners, and perhaps good press the directory could take on a life of its own and expand into new service areas. I've heard a vision for long-term success that that I'll share. Eventually politicians and service funders need to require that services make their information available in a public directory in a uniform format. If all services contribute to public databases, then the problem is much easier: build user-friendly websites to search the listings. With tightly-framed success stories you might be able to make the case to the powers that be.

### How tech can help

To kick things off, you'll need a database application to keep track of your listings and let people search them. At of May 21, 2015, I recommend using a flipping Google Spreadsheet (h/t [@allafarce](https://twitter.com/allafarce)). Data maintainers are keeping their data in spreadsheets anyway. Make their life easier. It could be said that making their life easy is the primary concern anyway.

A search application can pull listings from it like it's an API. Spreadsheets even have version control and user permissions to an extent. It's a great, low-overhead way to get the application out there. Wire up an interface like [finda](https://github.com/codeforboston/finda) and you're off to the races. Now keep that data pure and relevant!
