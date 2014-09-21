---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Install

```
git clone https://github.com/codeforamerica/citygram.git
cd citygram
cp .env.sample .env
gem install bundler
bundle install
rake db:create db:migrate
rake db:create db:migrate DATABASE_URL=postgres://localhost/citygram_test
rake # run the test suite
bundle exec foreman start -f Procfile.dev
```

```
psql
$ \list
                                       List of databases
            Name            | Owner | Encoding |   Collate   |    Ctype    | Access privileges
----------------------------+-------+----------+-------------+-------------+-------------------
 citygram_development       | erik  | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 citygram_test              | erik  | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 ....
```
 
```
$ \c citygram_development
You are now connected to database "citygram_development" as user "blah".
citygram_development=#
```

```
               List of relations
 Schema |         Name         |   Type   | Owner
--------+----------------------+----------+-------
 public | events               | table    | erik
 public | events_id_seq        | sequence | erik
 public | geography_columns    | view     | erik
 public | geometry_columns     | view     | erik
 public | publishers           | table    | erik
 public | publishers_id_seq    | sequence | erik
 public | raster_columns       | view     | erik
 public | raster_overviews     | view     | erik
 public | schema_info          | table    | erik
 public | spatial_ref_sys      | table    | erik
 public | subscriptions        | table    | erik
 public | subscriptions_id_seq | sequence | erik
(12 rows)
```

### Create a dummy publisher to subscribe to
```
$ rake console
2.1.2 :001 > create(:publisher)
 => #<Citygram::Models::Publisher @values={:id=>1, :title=>"Sequi et illo autem culpa illum cumque.", :endpoint=>"https://treutel.ca", :updated_at=>2014-07-24 01:44:51 UTC, :created_at=>2014-07-24 01:44:51 UTC, :active=>true, :city=>"City-1", :icon=>"balloons.png"}>
```


