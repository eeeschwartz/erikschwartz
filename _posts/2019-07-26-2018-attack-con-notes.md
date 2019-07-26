---
published: true
layout: post
category: blog
current-tab: blog
author: Erik Schwartz
date: '2019-07-26'
permalink: 2019-07-26-2018-attack-con-notes
---

## [2018 Keynote talk: advancing infosec](https://www.youtube.com/watch?v=yslLIqfOKCU&list=PLkTApXQou_8JrhtrFDfAskvMqk97Yu2S2&index=2&t=0s)

By John Lambert, Microsoft 

[Traditional versus advanced defense concepts](https://youtu.be/yslLIqfOKCU?list=PLkTApXQou_8JrhtrFDfAskvMqk97Yu2S2&t=246)

![Conventional Wisdom in Defense]({{site.baseurl}}/images/Screen Shot 2019-07-26 at 10.51.26 AM.png)

### Ideas

- Reverse mentorship, where less experienced person explains concept to more experienced 
- How to increse rate of learning
	- Promote community
	- Organized knowledge
	- Executeable Know-how
    - Repeatable Analysis
- "Githubification" of Infosec: important for community to share vendor-neutral learnings that any tool can pull in. So that we can all benefit for any other team's incident response, just just our own. Multiply our power.


### Selected tools mentioned

- [Mimikatz](https://github.com/gentilkiwi/mimikatz) tool to explore windows security
- [Virustotal](https://www.virustotal.com/gui/home/upload) to analyze files and URLs for maliciousness
- [Yara](https://virustotal.github.io/yara/) database of metadata to identify malware samples
- [snort](https://www.snort.org/) analyze packets; intrusion detection
- [Atomic Red Team](https://github.com/redcanaryco/atomic-red-team) test cases that simulate attacks to verify Blue Team alerts
- [Jupyter notebooks](https://jupyter.org/) hyper popular datascience toolset in python. Great way to share infosec analysis. E.g. visualize netblocks that a machine connects to.
- [Papermill](https://github.com/nteract/papermill) parameterize and run jupyter notebooks in automated fashion 
- [Binder](https://mybinder.org/) platform as a service that quickly hosts a jupyter GitHub repo so you can interact with it in your browser.
