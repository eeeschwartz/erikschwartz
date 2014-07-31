---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: ""
published: false
permalink: ""
---


### Create a digital ocean droplet 

[for docker](https://www.digitalocean.com/community/tutorials/how-to-use-the-digitalocean-docker-application)

### SSH to droplet

Add the info that digital ocean emails you to ~/.ssh/config:

```
Host ckan
    HostName 123.123.123.123
    Port 22
    User root
```

Add ssh key to droplet

```
ssh ckan "echo `cat ~/.ssh/id_rsa.pub` >> ~/.ssh/authorized_keys"
```

http://docs.ckan.org/en/latest/maintaining/installing/install-from-package.html

### Abandon CKAN package install and use docker

```
apt-get update
apt-get install -y nginx apache2 libapache2-mod-wsgi libpq5
wget http://packaging.ckan.org/python-ckan_2.2_amd64.deb
dpkg -i python-ckan_2.2_amd64.deb
```

```
$ docker run -d --name db ckan/postgresql
$ docker run -d --name solr ckan/solr
$ docker run -d -p 80:80 --link db:db --link solr:solr ckan/ckan

014/07/24 21:26:49 Error response from daemon: Cannot start container 20c7c6d7db5cf66863e928381ddcf412be939a2f5348d0a73d43a267666ecbd1: listen tcp 0.0.0.0:80: bind: address already in use
r
```

Get rid of packages dorking up port 80

```
apt-get remove nginx apache2 libapache2-mod-wsgi libpq5
```

### The above stuff didn't install the datastore! boo no searching.

```
$ curl -X GET "http://107.170.70.146//api/3/action/datastore_search?resource_id=_table_metadata"
"Bad request - Action name not known: datastore_search"
```

### Try using a different CKAN image


`docker run -name=myckan -i -t -p 5000:80 kindly/ckan_base`

errors with no command specified

### Back to official ckan/ckan image

```
docker rm db
docker run -d --name db ckan/postgresql
docker rm solr
docker run -d --name solr ckan/solr
```

run ckan image interactively

```
docker run -i -p 80:80 --link db:db --link solr:solr ckan/ckan
```

Doesn't do much, just shows STDOUT

### Change vanilla ckan Dockerfile

docker build -t erik/ckan .