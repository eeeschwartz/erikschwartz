---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-05-23"
published: false
permalink: "2014-05-23-environment-improvements-3"
---

##### Bash: sort ruby files by number of lines (ascending)
* `find . -name '*.rb' -exec wc -l {} \; | sort`
* I used this to find a few hotspots in calagator

```
...
     333 ./spec/controllers/venues_controller_spec.rb
     333 ./spec/models/source_parser_ical_spec.rb
     350 ./spec/models/venue_spec.rb
     411 ./spec/controllers/sources_controller_spec.rb
     550 ./app/models/event.rb
     867 ./spec/controllers/events_controller_spec.rb
     982 ./spec/models/event_spec.rb
```

##### Heroku: backup postgres
* `heroku addons:add pgbackups:auto-month`
* `heroku pgbackups:capture` # backup right now!
* `heroku pgbackups` # show the backups
* load to local env ``curl -o latest.sql `heroku pgbackups:url``
* `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump` (via [heroku](https://devcenter.heroku.com/articles/heroku-postgres-import-export))

##### Bash: save command you've typed without running it
* `Ctrl`+`a` to jump to beginning of line and comment it out :) `$ #echo 'this is a command for later'`

##### Zsh: save command you've typed without running it
* "`Ctrl`+`Y` [will paste](http://unix.stackexchange.com/a/74187) the last item you cut (with `Ctrl`+`U`, `Ctrl`+`K`, `Ctrl`+`W`, etc.)"

##### Sed: remove leading chars
* `echo 'this is a new new thing' | sed 's/^this //'` => "is a new new thing"
*  `echo 'this is a new new thing' | sed 's/.\{5\}//'` => "is a new new thing"
*  `echo '     remove leading whitespace' | sed 's/[ \t]*//'` => "remove leading whitespace"
