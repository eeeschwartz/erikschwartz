---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### As a Lexingtonian I want to click on a region and see a link to the point data so I can derp my city-county

### Docker image versus container

* Image: static descriptor of a container state (like a git sha)
* Container: a running docker process

### Run existing docker containers


```
$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ckan/ckan              latest              95cd0d9c87a4        2 weeks ago         772.1 MB
ckan/postgresql        latest              192057470cf4        4 weeks ago         429.2 MB
ubuntu                 14.04               e54ca5efa2e9        4 weeks ago         276.5 MB
ubuntu                 latest              e54ca5efa2e9        4 weeks ago         276.5 MB
ckan/solr              latest              3a9ee0bc7fe7        6 weeks ago         779 MB
ruby                   2.1                 011aa33ba92b        6 weeks ago         1.653 GB
```

```
$ docker start db # (assuming that earlier you ran: docker run -d --name db ckan/postgresql)
$ docker start solr # (run -d --name solr ckan/solr)
$ docker run -d -p 80:80 --link db:db --link solr:solr ckan/ckan
```

browse to `http://192.168.59.103` and play with CKAN. Goodness. Way easy.

### Insert data into local CKAN instance

* Upload resource from host machine to dataset fails with `Could not load preview: DataProxy returned an error (Data transformation failed. error: An error occured while connecting to the server: DNS lookup failed for URL: http://192.168.59.103/dataset/4dae6c9e-2667-4273-958b-fd7630c13c19/resource/0455c7ef-daad-436f-993d-e7d4e0fe450f/download/Childreneligibleforfreeorreducedpricemeals2.csv)`


### View CKAN logs in docker container

```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND               CREATED             STATUS              PORTS                NAMES
d44f22731054        ckan/ckan:latest         /sbin/my_init         3 minutes ago       Up 3 minutes        0.0.0.0:80->80/tcp   focused_franklin                                                                              
21747b72aee8        ckan/solr:latest         java -jar start.jar   2 weeks ago         Up 40 minutes       8983/tcp             backstabbing_fermat/solr,boring_einstein/solr,focused_franklin/solr,naughty_fermi/solr,solr   
291b0394ace6        ckan/postgresql:latest   /usr/local/bin/run    2 weeks ago         Up 41 minutes       5432/tcp             backstabbing_fermat/db,boring_einstein/db,db,focused_franklin/db,naughty_fermi/db             
```

```
$ docker logs focused_franklin
*** Running /etc/rc.local...
*** Booting runit daemon...
*** Runit started as PID 8
 * Starting Postfix Mail Transport Agent postfix
   ...done.
Distribution already installed:
  ckan 2.3a from /usr/lib/ckan/default/src/ckan
Creating /etc/ckan/default/ckan.ini
Now you should edit the config files
  /etc/ckan/default/ckan.ini
Initialising DB: SUCCESS
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.7. Set the 'ServerName' directive globally to suppress this message
tail: cannot open '/var/log/mail.log' for reading: No such file or directory
```

SELECT%20*%20from%20%22972c39a4-ce6e-42b4-8054-44bace50322f%22%20WHERE%20%22RECORD%20STATUS%22%20=%20'Issued'


encodeURI('SELECT * from "972c39a4-ce6e-42b4-8054-44bace50322f" WHERE "RECORD STATUS" = Issued')

www.civicdata.com/api/3/action/datastore_search_sql?resource_id=972c39a4-ce6e-42b4-8054-44bace50322f&sql=SELECT%20*%20from%20%22972c39a4-ce6e-42b4-8054-44bace50322f%22%20WHERE%20%22RECORD%20STATUS%22%20=%20'Issued'

```
copy
(select objectid as precinct_id,
  c.*
  from votingprecinct v left join ce_calls c ON(st_contains(v.geom, c.geom))
) TO STDOUT WITH CSV HEADER;
```

`cat ce_calls.sql | xargs -0 psql -d postgis_demo -c > ce_with_precinct.csv`

### Looks like CKAN needs a geojson file to enable the map preview


```
npm install -g csv2geojson
csv2geojson -lat geo_latitude -lon geo_longitude ce_with_precinct.csv  > ce_with_precinct.geojson
```

... Still doesn't work. I think the CKAN dockerfile needs to install the datastore to work.

### Using OpenLexington's test CKAN 2.0

http://ec2-184-73-141-129.compute-1.amazonaws.com/dataset/test-ce-calls