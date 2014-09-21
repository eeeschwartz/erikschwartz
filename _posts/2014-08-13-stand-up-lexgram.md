---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---


Publisher
* Make visible: false

http://lexington-registry.herokuapp.com/code_enforcement

### Create publisher

```
$ heroku run "irb -r ./app"

Publisher.create! do |pub|
 pub.title = 'Lexington Building Permits'
 pub.endpoint = 'http://localhost:9393/code_enforcement'
 pub.visible = false
 pub.active = true
 pub.city = 'Lexington'
 pub.icon = 'needs-an-icon.png'
end
```

### Update existing publisher

```
$ heroku run "irb -r ./app"

Publisher.where(title: 'Code Violations').first.update(endpoint: 'http://lexington-registry.herokuapp.com/code_enforcement')

Publisher.where(title: 'Building Permits').first.update(endpoint: 'http://lexington-registry.herokuapp.com/building_permits')
```

### Schedule background workers

In heroku scheduler

`bundle exec rake publishers:update` | `Every 10 Minutes`

Test it manually

`heroku run "bundle exec rake publishers:update"`

now pop into irb

```
$ heroku run "irb -r ./app"
irb(main):001:0> Event.count
=> 50
```

### Update CE and Building permit data


### Install pgadmin to query notifications

### Monitor health

I've been getting one sms when I update a big batch of changes in my area.
Is the app just sending the first purposefully?

### Set up Twilio number

in twilio ui:
* select the phone number
* set messaging request url to `https://lexgram.herokuapp.com/protected/unsubscribes`

### Citygram deduplicates events based on which fields?

* publisher_id and feature_id
* So updates to a feature do not trigger an sms
* feature_id should probably be a composite key

### Sync dev environment to heroku

```
dropdb citygram_development
heroku pg:pull HEROKU_POSTGRESQL_CRIMSON_URL citygram_development -a lexgram
```

### Start the apps
```
cd ~/code/lexgram
bundle exec foreman start -f Procfile.dev
```

```
cd ~/code/citygram_data
# create a single code enforcement event
shotgun app.rb
```

### Does an alpha feature_id cause a problem in citygram db?

### Start with fresh install

```
dropdb citygram_development
rake db:create db:migrate
```

Add publisher

```
$ irb -r ./app


Publisher.create! do |pub|
 pub.title = 'Lexington Building Permits'
 pub.endpoint = 'http://localhost:9393/code_enforcement'
 pub.visible = true
 pub.active = true
 pub.city = 'Lexington'
 pub.icon = 'needs-an-icon.png'
end

This seems to kill sidekiq
```


Don't forget to kill the jobs already queued in redis! Otherwise jobs will retry and point at rows in postgres tables that don't exist

### Reset the db and selectively upload code enforcement complaints in an area I subscribe to

```
heroku pgbackups:capture
curl -o latest.dump `heroku pgbackups:url`
````

reset db

```
heroku run "rake db:reset"
# open heroku db
psql `heroku config | grep DATABASE_URL | sed 's/DATABASE_URL:[ ]*//'`
```

The above commands had no effect on the db.

Try cleaning out existing state in irb

```
$ heroku run "irb -r ./app"
Event.truncate
Subscription.truncate
```

Remove heroku's scheduled publisher polling for now. We'll do manually

Heroku scheduler > remove the following (set to run 1x every 10 minutes):

```
bundle exec rake publishers:update
```

Activate the code enforcement publisher in irb:

Publisher.where(id: 1).first.update(active: true)

Upload a [single event](https://github.com/codeforamerica/lexington-citygram-etl/commit/c9c2e0e4a9d1f50e39bac0351fad2a9d7b2a661e)

### Poll an event

push to heroku and...

```
heroku run "bundle exec rake publishers:update"
```

Success! I got the sms

### Add another event to my area

https://github.com/codeforamerica/lexington-citygram-etl/commit/88ade8f63b54e0f7c7f6d8bf88d8b878fbf8e5ba


```
heroku run "bundle exec rake publishers:update"
```

### Add two events in range, one out of range

https://github.com/codeforamerica/lexington-citygram-etl/commit/4cddd0d005b5641f9a159609043f68c00b37d5dc

manually trigger publisher update

```
heroku run "bundle exec rake publishers:update"
```

### Pull last week of Code Enforcement from CKAN

The query:

```
select * from "complaints-2" where "StatusDate" > (now() - '7 day'::interval)

http://104.131.23.252/api/action/datastore_search_sql?sql=select%20*%20from%20%22963cf23f-90be-479f-a7d7-7cb7fb29d45d%22%20where%20%22DateOpened%22%20%3E%20(now()%20-%20'12%20day'::interval)
```

### Install Heroku logging

```
heroku addons:add papertrail
```

### Test email

```
$ irb -r './app'
email = Citygram::Services::Channels::Email.new(OpenStruct.new(email_address: 'eschwartz+inline@codeforamerica.org'), OpenStruct.new(title: 'foo title'))
e.call
```

### Potential Bugs

* I got an sms about 341 MLK but it doesn't show up on the lexgram map. I got a text but now is outside of my geometry?

This is empty if I include ST_Intersects
```
SELECT
  subscriptions.phone_number,
  events.*
---  COUNT(events.id) AS notifications_count
FROM subscriptions
INNER JOIN publishers
  ON subscriptions.publisher_id = publishers.id
INNER JOIN events
  ON events.publisher_id = publishers.id
  -- AND ST_Intersects(subscriptions.geom, events.geom)
WHERE events.created_at >= subscriptions.created_at
 -- AND events.updated_at >= '2014-09-03'
 AND events.feature_id = '20671218-5_Reinspection'

--  AND events.created_at <= COALESCE(subscriptions.unsubscribed_at, now())
-- GROUP BY subscriptions.phone_number
 -- AND event.id
ORDER BY updated_at DESC
LIMIT 1000
```

