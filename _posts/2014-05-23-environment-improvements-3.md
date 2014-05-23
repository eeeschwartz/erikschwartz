---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-05-23"
published: true
permalink: "2014-05-23-environment-improvements-3"
---

##### Bash: <a name="sort-ruby-files-by-number-of-lines"></a> [sort ruby files by number of lines]({{page.url}}#sort-ruby-files-by-number-of-lines) (ascending)
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

##### Heroku: <a name="backup-postgres"></a> [backup postgres]({{page.url}}#backup-postgres)
* `heroku addons:add pgbackups:auto-month`
* `heroku pgbackups:capture` # backup right now!
* `heroku pgbackups` # show the backups
* load to local env ``curl -o latest.sql `heroku pgbackups:url``
* `pg_restore --verbose --clean --no-acl --no-owner -h localhost -U myuser -d mydb latest.dump` (via [heroku](https://devcenter.heroku.com/articles/heroku-postgres-import-export))

##### Bash: <a name="save-command-youve-typed-without-running-it"></a> [save command you've typed without running it]({{page.url}}#save-command-youve-typed-without-running-it)
* `Ctrl`+`a` to jump to beginning of line and comment it out :) `$ #echo 'this is a command for later'`

##### Zsh: <a name="save-command-youve-typed-without-running-it"></a> [save command you've typed without running it]({{page.url}}#save-command-youve-typed-without-running-it)
* "`Ctrl`+`Y` [will paste](http://unix.stackexchange.com/a/74187) the last item you cut (with `Ctrl`+`U`, `Ctrl`+`K`, `Ctrl`+`W`, etc.)"

##### Sed: <a name="remove-leading-chars"></a> [remove leading chars]({{page.url}}#remove-leading-chars)
* `echo 'this is a new new thing' | sed 's/^this //'` => "is a new new thing"
*  `echo 'this is a new new thing' | sed 's/.\{5\}//'` => "is a new new thing"
*  `echo '     remove leading whitespace' | sed 's/[ \t]*//'` => "remove leading whitespace"


##### Kimono: <a name="retrieving-crawled-pages-with-the-source-url-included"></a> [retrieving crawled pages with the source url included]({{page.url}}#retrieving-crawled-pages-with-the-source-url-included)
Add `&kimbypage=1` to the query string

```
"results": [
    {
      "page": 1,
      "url": "http://www.lexpublib.org/event/friends-of-library-booksale-uk-chandler-medical-center",
      "collection1": [
        {
          "title": "Friends of the Library Booksale: UK Chandler Medical Center",
          "venue": "Other Location",
          "access_notes": "See Description",
          "description": "Friends of the Library will be have books for sale at the UK Chandler Medical Center.",
          "start_time": "Wednesday, May 21st - 8:00 AM"
        }
      ]
    },
```

##### Ruby: <a name="regex-capture-syntax"></a> [regex capture syntax]({{page.url}}#regex-capture-syntax)
```
1.9.3-p484 :002 > 'xxfindmexx'.gsub(/xx(findme)xx/, '\1')
 => "findme"
# note that double quotes around \1 interprets it as a unicode escape
1.9.3-p484 :003 > 'xxfindmexx'.gsub(/xx(findme)xx/, "\1")
 => "\u0001"
 ```

##### Markdown: <a name="fix-the-fragment-fn-infer-behavior"></a> [fix the fragment fn-infer behavior]({{page.url}}#fix-the-fragment-fn-infer-behavior)

 * Now it drops in a named link:
 `<a name="do-some-cool-thing"></a> [do some cool thing]({{page.url}}#do-some-cool-thing) => <a name="do-some-cool-thing"></a>[do some cool thing](#do-some-cool-thing)`
 * It's borderline unreadable as markdown syntax but hey, what can you do?
