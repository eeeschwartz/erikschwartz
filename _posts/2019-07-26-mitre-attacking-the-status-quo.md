---
published: true
layout: post
category: blog
current-tab: blog
author: Erik Schwartz
date: '2019-07-26'
permalink: 2019-07-26-mitre-attacking-the-status-quo
---

## Summary of "(2018) ATT&CKing the Status Quo: Improving Threat Intel and Cyber Defense with MITRE ATT&CK"

Katie Nickels & John Wunder

[video](https://www.youtube.com/watch?v=p7Hyd7d9k-c), [slides](https://www.slideshare.net/KatieNickels/bsideslv-2018-katie-nickels-and-john-wunder-attcking-the-status-quo) 

ATT&CK helps answer these common questions from SOC

- How effective are my defenses
- Do I have a chance of detecting APT[123] for example
- is my data useful?
- Do I have overlapping tool coverage
- Will this shiny XYZ product improve my defenses?

The difficult task of detecting Tactics, Techniques, and Procedures (TTPs)

- Pinnacle of David Biancos [pyramid of pain](http://detect-respond.blogspot.com/2013/03/the-pyramid-of-pain.html)
- It's easy for attackers to change things like Hash values, IP addresses, Domain names, etc.
- Much harder for them to change their attach _behavior_
- ATT&CK is here to help with TTPs, it's a knowledge base of adversary behavior

ATT&CK

- based on real-world observations in MITRE red/blue team experiments
- A common language. When you say the attacker moved laterally, it defines what that means
- Community driven

Focus on adversary lifecycles

- assume they'll break your perimeter
- lifecycle
	- pre-att&ck
	    - Gaining network access
        - laying groundwork for spearphishing
    - enterprise
        - Move laterally
        - Exfiltration

Technique example: [New Service](https://attack.mitre.org/techniques/T1050/)

- Install program that starts on system boot
- ATT&CK describes common defenses, mitigation, logs where this appears

Example software: [Chopstick](https://attack.mitre.org/software/S0023/)
 
   
### How to use ATT&CK

- Detect, Threat intel, Assess and Engineer, Adversary emulation 
- More important: how to coordinate between these 4
- ATT&CK is available in [STIX (Structured Threat Information eXpression) json format](https://oasis-open.github.io/cti-documentation/stix/gettingstarted.html) for communicating cyber threat intel (CTI)
- [ATT&CK navigator](https://mitre-attack.github.io/attack-navigator/enterprise/) to help you focus on what's relevant to your org

Status Quote in Threat Intel

- So many reports
- Not clear how to apply intel to defense
- Over-reliance on indicators like IPs and domains. Because they're quantifiable. But it's just wack-a-mole.

How to use ATT&CK

- Use ATT&CK to structure tech intel
- Example from Palo Alto 42 that consumes ATT&CK data to construct [TTP playbooks](https://pan-unit42.github.io/playbook_viewer/?pb=oilrig) describing attack campaigns. Shows a given groups evolution over time. 
- Tailor your existing threat intel repo. Many are starting to support ATT&CK like [MISP](https://www.misp-project.org/index.html), ThreatQ, etc
- Have the threat intel originator do it
- Start at the tactic level
- Use existing website examples
- Work as a team

Detection and Analytics

- Now that we get reports from ATT&CK we can prioritize defense
- Once we have indicators of known malicious IPs, hashes for malware, etc
	- Follow the TTP to what would be next from this indicator
- How to avoid false positives? Move towards analytics
	- Indicators like file hashes, IP addresses, are effectively infinite
    - Analytics follow credential dumping, or process persistence which have many fewer signatures to track
- Analytics
	- Look at observable events and artifacts. E.g. what's it look like RDP is used for lateral movement? Analytic: it shows up in Windows Event Log. 
    - Then the work is to build evidence to separate good from bad and alert on bad. Windows example: process tries to elevate priv by riding on admin process. Attacker wants to bypass system dialog popup that asks for Admin priv.
	- Important to understand the attack goal. Try the attack yourself. How to pinpoint bad logs without overfitting the attack. It's iterative. New products will create new false positives and new attack techniques will need new analyics.
    - It's hard. Each OS requires totally different expertise to monitor effectively.
    - Orgs that help define detection
    	- NH-ISAC
        - SIGMAQ
        - [Cyber Analytic Repository](https://car.mitre.org/)
        - MISP
	- How to deal with false positives
    	- Look at chains of events: graphs. Neo4j
        - Machine learning for classifications
        - Tighten the feedback loop: learn from your analysts 
        - Focus on issues that lead to most important biz impacts
        - Adversaries are good a hiding in noise of normal logs
        	- Agile logging: can we collect fewer logs until we notice something bad then ramp up?
    - Roadmap for getting started on your own
    	- [Detection Lab](https://github.com/clong/DetectionLab) 
        - Be bad: [Atomic Red Team](https://atomicredteam.io) to mimic red team 
        - Write some detections. Use [ThreatHunter-Playbook](https://github.com/Cyb3rWard0g/ThreatHunter-Playbook) for inspiration
        - Share what you've learned with community
        - Have your red team focus on techniques from you analytics: use what's real for your org
        - Use consistent naming conventions so you can communicate with your red team
            
