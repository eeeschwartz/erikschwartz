---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Create app

* Sign in to heroku and create lexington-geocoder
* Add CfA as collaborator
* Transfer ownership to CfA
* `heroku addons:add bonsai:production` # create elasticsearch service

### Create addresses index

curl -XPOST 'https://user:pass@elasticsearch_url/addresses'

### Populate elasticsearch index from heroku

push script to heroku to load pva data 

```
$ heroku run bash
heroku $ ruby index_addresses
# ~100 minutes to load 100k addresses
```

### Push sinatra app as api layer

Importing sinatra into an existing heroku app results in the following error:

```
2014-08-22T17:46:44.508149+00:00 heroku[router]: at=error code=H14 desc="No web processes running" method=GET path="/favicon.ico" host=lexington-geocoder.herokuapp.com request_id=5143861a-9463-42df-8b14-58503d3e423a fwd="74.131.206.84" dyno= connect= service= status=503 bytes=
```

```
heroku config:set RACK_ENV=production
heroku config:set ELASTICSEARCH_URL=foo
```

And the winning command is!

```
heroku ps
# no ouput
# we need to add a web dyno:
heroku ps:scale web=1
```

Load parcel table

```
pg_dump --no-acl --no-owner -h localhost -U erik -t parcels --data-only geocode_code_enforcement > parcels.dump
psql postgres://[from heroku config] < parcels.dump
```

chugs for 30 seconds and syntax error...

let's try the slow and steady approach

```
$ time csvsql --db postgres://[from heroku config] --insert --table parcels data/ParcelCentroids.csv
33.58s user 8.72s system 0% cpu 1:17:11.89 total
```


### Debug sql error

```
Sequel::DatabaseError - PG::UndefinedFunction: ERROR:  operator does not exist: character varying = integer
2014-08-22T21:19:02.748578+00:00 app[web.1]: LINE 1: SELECT * FROM "parcels" WHERE ("PVANUM" = 10259750) LIMIT 1
```

I haven't gotten this error locally because the local parcels table has PVANUM as an `integer`, where heroku has it as a `character varying(8)`


```
$ psql geocode_code_enforcement
alter table parcels alter column "PVANUM" set data type character varying(8);
```

Too late, we already lost leading zeros!

Try recreating the parcel table

```
psql geocode_code_enforcement -c 'drop table parcels'
time csvsql --db postgresql:///geocode_code_enforcement --insert --table parcels data/ParcelCentroids.csv
```