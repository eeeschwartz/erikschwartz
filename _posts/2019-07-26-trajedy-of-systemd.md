---
published: true
layout: post
category: blog
current-tab: blog
author: Erik Schwartz
date: '2019-07-26'
permalink: 2019-07-26-trajedy-of-systemd
---
https://www.youtube.com/watch?v=o_AIw9bGogo

## Summary

- Linux started simple, initd started a few daemons and mounted filesystems
	- Unfortunately it conflates system config (filesystems) with service bootstrap
    - This gets in way of automated service management.
    	- along comes upstart and systemd to handle things that need more active mgmt
- The web made things complicated
	- We can't fork processes to handle each connection anymore
    - We manage complicated databases that have all sorts of persistant processes
- Along came services which are superset of daemons
	- init.d is not great at keeping services running once they start
    
- Comparative systems
	- Windows NT: actually has great service model despite security weaknesses
    - MacOS: has great service delegation that receives well defined mgmt calls 
		- launchd took over for init.d, cron, etc 
        - can start service daeomons as needed by listening on TCP ports, unix sockets. Means they don't have to start at boot. They can be run and managed ad hoc.
        - this is super important for complicated systems like desktop envs
        
- systemd is based on launchd
	- Inventor (Lennart Poettering) [didn't think](http://0pointer.de/blog/projects/systemd.html) upstart had enough mechanisms for dependency ordering
    - wanted boot to start less and more in parallel
    - wanted an init system to listen for hardware/software changes like launchd does
    - you start thinking more in terms of handling events rather than system boot
    - Between 2011-2015 systemd was adopted across majority of linux distros
    
 - Systems are much more dynamic than they once were
 	- We need unified layer between kernal and userspace: kernal | system | userspace
    - this avoids cobbling together 15 different systems to manage system functions
    
 - Issues with systemd
 	- "violates Unix philosphy"
    - "bloated and monolithic"
    - "it's buggy!"
    - "I don't like the inventor"
    - "It's not portable" it's agressively linux-specific like cgroups
    	- UNIX is dead. You have Linux and rounding errors like FreeBSD
        - Went from pathological diversity to pathological monolithism
        - cgroups are even better than jails
        	- E.g. you can run user-level daemons
- systemd is change, super disruptive
	- We love change when we're doing it
    - We don't like outside systemd person forcing us to abandon our RC shell scripts we've run for 20 years
    - Contempt is not cool. We shouldn't send threats to systemd people. We should see it's utility. Adopt it or grow our own (speaker is from BSD)
    
- The promise of systemd
 	- Message Transport: Dbus e.g.
    - You need an RPC framework so you don't worry if your API call talks to kernal or user-space: e.g. "network interface, take this IP address" 
    - Service lifecycle
    - Automation via API
    - Containers and their encapsulation
    - Consistent device naming
    - Good logging: append only

- Catharsis
	- Cleansing. Let's get with it
    - Challenge: look at systemd and find one thing you like
    
    
- Questions
	- Q: Are containers DLL hell?
    	A: DLL hell is 5 diff libraries and your app chooses wrong one
