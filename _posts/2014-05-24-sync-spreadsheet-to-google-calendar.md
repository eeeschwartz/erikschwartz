---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-06-24"
published: false
permalink: "2014-06-27-foo"
---

* Create new spreadsheet with the columns
	* date
	* title
	* start time
	* stop time
	* location
	* status
	* id
	* sync'd to calendar?
						

* Create new calendar* 
* [Follow instructions](http://stackoverflow.com/a/15790894) for dumping sync script into spreadsheet.
* Insert calendar id into script where it says "YOUR_CALENDAR_ID"
* Get calendar id from "Calendar Settings > default tab (Calendar Details) > Calendar Address row"


Spreadsheet

* Set timezone to eastern. File > Spreadsheet Settings > Time Zone > Set to 'Eastern Time'
* Add sheet named 'Settings' 
	* | calendarId | codeforamerica.org_jlsdkjflksjflsjflsjdk@group.calendar.google.com | 
	
Gotchas

* Some events will show the following warning when you delete them `Would you like to delete only this event, all events in the series, or this and all future events in the series?` The event is not actually a series so you can select `Only this instance`. (Programmer note: google apps script does not allow you to update the date/time for a single event so you have to treat it as a series.)


