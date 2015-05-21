---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-05-21"
permalink: "2015-05-21-prototyping-with-turf-merge"
---

### Rapid prototyping to figure out where to focus outreach for your survey

In the process of analyzing resident surveys, we need a way to code free-text neighborhoods to areas on the map.

I created a simple protype that includes neighborhood(-ish) datasets. As you select areas on the map, they are merged together (turf.merge) and output as geojson.

Then you copy that geometry into a spreadsheet where it is compared to census tracts. The analyzer spits out demographics and regions that your survey reaches, and those it does not.

This builds on the [cool work](http://www.codeforamerica.org/our-work/initiatives/digitalfrontdoor/oakland-phase1-report/#geography-process) that Code for America has been doing around resident surveys.

<iframe src="http://eeeschwartz.github.io/resident-web-use-research/survey-page-code-neighborhoods.html"></iframe>
