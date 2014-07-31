---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: ""
published: false
permalink: ""
---

Setup [VM](https://vagrantcloud.com/boxer/ubuntu-14.04-generic) with every dev environment known to humanity

```
$ vagrant init boxer/ubuntu-14.04-generic
...
$ vagrant up
...
$ vagrant ssh
..
#[boxer-ubuntu-14][17:45:15][~]$
```

### Install PostGIS

On the VM via `vagrant ssh`

[Built with](https://registry.hub.docker.com/u/helmi03/docker-postgis/) docker 0.7 but works with the VM's 0.12 version ...

```
$ sudo docker build -t postgis:2.1 github.com/helmi03/docker-postgis.git
...
Successfully built 315c76469b56
$ CONTAINER=$(sudo docker run -d -t postgis:2.1)
$ CONTAINER_IP=$(sudo docker inspect $CONTAINER | grep IPAddress | awk '{ print $2 }' | tr -d ',"')
$ psql -h $CONTAINER_IP -p 5432 -U docker -W postgres
... password: docker
```

Persist postgres data to ~/postgres_data/

```
$ mkdir -p ~HOME/postgres_data
$ sudo docker run -d -v $HOME/postgres_data:/var/lib/postgresql postgis:2.1
```

### Install Redis

```
sudo apt-get install redis-server
```

### Install Elasticsearch

From [docker build](https://registry.hub.docker.com/u/dockerfile/elasticsearch/)

```
$ sudo docker pull dockerfile/elasticsearch
$ sudo docker run -d -p 9200:9200 -p 9300:9300 dockerfile/elasticsearch
6ad89305b10b796286a01d3159ba00d35098f546642fd45eb0f62116a2e297df
```

### [Install Pelias](https://github.com/mapzen/pelias)

```
$ mkdir code && cd !$
$ git clone https://github.com/mapzen/pelias.git && cd pelias
$ bundle
...
An error occurred while installing debugger (1.6.5), and Bundler cannot continue.
$ vim Gemfile # comment out debugger gem
$ bundle
...
An error occurred while installing pg (0.17.1), and Bundler cannot continue.
```

Found [the answer](http://stackoverflow.com/a/20754173) to install pg

```
$ sudo apt-get install libpq-dev
$ bundle
... success
```



### Continue pelias install instructions

```
$ bundle exec rake synonyms:build
$ bundle exec rake index:create
rake aborted!
[500] {"error":"IndexCreationException[[pelias] failed to create index]; nested: FailedToResolveConfigException[Failed to resolve config path [/home/vagrant/code/pelias/config/synonyms.txt], tried file path [/home/vagrant/code/pelias/config/synonyms.txt], path file [/elasticsearch/config/home/vagrant/code/pelias/config/synonyms.txt], and classpath]; ","status":500}
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-transport-1.0.1/lib/elasticsearch/transport/transport/base.rb:132:in `__raise_transport_error'
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-transport-1.0.1/lib/elasticsearch/transport/transport/base.rb:227:in `perform_request'
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-transport-1.0.1/lib/elasticsearch/transport/transport/http/faraday.rb:20:in `perform_request'
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-transport-1.0.1/lib/elasticsearch/transport/client.rb:102:in `perform_request'
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-api-1.0.1/lib/elasticsearch/api/namespace/common.rb:21:in `perform_request'
/home/vagrant/.rvm/gems/ruby-2.1.2/gems/elasticsearch-api-1.0.1/lib/elasticsearch/api/actions/indices/create.rb:77:in `create'
/home/vagrant/code/pelias/lib/pelias/tasks/index.rake:9:in `block (2 levels) in <top (required)>'
/home/vagrant/.rvm/gems/ruby-2.1.2/bin/ruby_executable_hooks:15:in `eval'
/home/vagrant/.rvm/gems/ruby-2.1.2/bin/ruby_executable_hooks:15:in `<main>'
Tasks: TOP => index:create
(See full trace by running task with --trace)
```

I reckon we need to [mount the data](https://registry.hub.docker.com/u/dockerfile/elasticsearch/) dir in docker.


### Scrap all of this and try to install on host OSX machine

download kentucky osm http://download.geofabrik.de/north-america/us/kentucky.html

Install http://wiki.openstreetmap.org/wiki/Osm2pgsql#Mac_OS_X

```
brew install osm2pgsql
brew install protobuf-c
createdb lex-pelias
psql -d lex-pelias -c "CREATE EXTENSION postgis;"
... does not work
```

Bad idea (manually linking homebrew stuff):

```
ln -s /usr/local/opt/postgresql/share/postgresql/extension/postgres_fdw.control /usr/local/Cellar/postgresql/9.3.5/share/postgresql/extension/postgis.control
```

```
lex-pelias=# CREATE EXTENSION postgis;
ERROR:  could not load library "/usr/local/Cellar/postgresql/9.3.5/lib/rtpostgis-2.1.so": dlopen(/usr/local/Cellar/postgresql/9.3.5/lib/rtpostgis-2.1.so, 10): Library not loaded: /usr/local/lib/libspatialite.5.dylib
  Referenced from: /usr/local/lib/libgdal.1.dylib
  Reason: image not found
```
```
erik@escarole code/pelias [master●]  >> brew uninstall postgis
Uninstalling /usr/local/Cellar/postgis/2.1.3...
erik@escarole code/pelias [master●]  >> brew uninstall sqlite3
Uninstalling /usr/local/Cellar/sqlite/3.8.5...
erik@escarole code/pelias [master●]  >>
```

```
erik@escarole code/pelias [master●]  >> brew uninstall gdal
Uninstalling /usr/local/Cellar/gdal/1.11.0...
erik@escarole code/pelias [master●]  >> brew install gdal
```

Worked! PostGIS works again!

```
$ osm2pgsql -d lex-pelias -S config/osm2pgsql.style kentucky-latest.osm.pbf
... ERROR: PBF support has not been compiled into this version of osm2pgsql, please either compile it with pbf support or use one of the other input formats
e
```

The install command doesn't include PBF support

```
$ brew install osm2pgsql --with-protobuf-c=/usr/local/Cellar/protobuf-c/1.0.0
$ brew install osm2pgsql --build-from-source --with-protobuf-c=/usr/local/Cellar/protobuf-c/1.0.0
```

The latter brew command compiles but not with the with-protobuf-c flag


### Download osm data for lexington


use this to figure out bounding box http://www.birdtheme.org/useful/v3tool.html
lat: 38
long: 84

upper left: -84.689484, 38.229550
upper right: -84.236298, 38.229550
lower right: -84.236298, 37.842326
lower left: -84.704590, 37.842326

(min long, min lat, max long, max lat)
```
wget -O lexington.osm "http://api.openstreetmap.org/api/0.6/map?bbox=-84.23,37.84,-84.7,38.23"
```

This didn't download anything

Use mapzen 

https://mapzen.com/metro-extracts/

https://s3.amazonaws.com/metro-extracts.mapzen.com/lexington.osm.bz2

```
osm2pgsql -d lex-pelias -S config/osm2pgsql.style lexington.osm
```

### Cool, OSM data succesfully imported

### Install Elasticsearch

```
brew install elasticsearch
```

starter up

```
elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

### Start redis

```
redis-server /usr/local/etc/redis.conf
```

### Continue with install instructions

```
bundle exec rake synonyms:build
bundle exec rake index:create
bundle exec rake geonames:prepare
```

Oops I don't have wget so I downloaded manually...

```
mv ~/Downloads/allCountries.zip /tmp/mapzen
bundle exec rake geonames:prepare
... took 30 minutes or so
bundle exec rake quattroshapes:prepare_all
...
psql gis < /tmp/mapzen/qs_adm0.sql
psql: FATAL:  database "gis" does not exist

```

Change db name in config/postgres.yml to be 'lex-pelias'

