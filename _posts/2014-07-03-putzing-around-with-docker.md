---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---
install standard Ubuntu 12.04 LTS 32-bit box.

`vagrant box add hashicorp/precise32`

upgrade virtualbox to `VirtualBox-4.3.12-93733-OSX`

Not sure I need vagrant. I can run boot2docker and get a lighterweight vm to launch docker images from

### Install docker

Following docker [install guide for osx](https://docs.docker.com/installation/mac/).

Ran Boot2Docker from /Applications

Opened native osx terminal (white background, doof!)

It setup the docker host, did this `export DOCKER_HOST=tcp://192.168.59.103:2375` and returned me to the cli.

Then this downloads ubuntu and runs a command on it
`docker run ubuntu echo hello world`

I tried to run this in another terminal and it said this:

`2014/07/03 18:49:14 Post http:///var/run/docker.sock/v1.12/containers/create: dial unix /var/run/docker.sock: no such file or directory`. 

I manually dropped in the export of DOCKER_HOST above and it worked! I'm a genius for now.

### Run a few simple docker commands

```
$ docker run --rm -i -t -p 80:80 nginx
Unable to find image 'nginx' locally
Pulling repository nginx
...
```

This terminal is now running nginx in the foreground.

Now let's find out the ip address for the dockerized nginx.

```
$ boot2docker ssh ip addr show dev eth1
Warning: Permanently added '[localhost]:2022' (RSA) to the list of known hosts.
4: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP qlen 1000
    link/ether 08:00:27:fa:74:6a brd ff:ff:ff:ff:ff:ff
    inet 192.168.59.103/24 brd 192.168.59.255 scope global eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fefa:746a/64 scope link
       valid_lft forever preferred_lft forever
```

Open up a pseudo-tty in the container

```
(-t is open ptty, -i is interactive with access to the container's STDIN)
$ docker run -t -i ubuntu:14.04 /bin/bash
root@11c084697a2c:/#
```


Run a daemonized command, it returns the container id

```
$ docker run -d ubuntu:14.04 /bin/sh -c "while true; do echo hello world; sleep 1; done"
75223f6e530159f54c2e6f139f2c37450c55da5beb2e88f12624fe4062282fc7
```

```
$ docker logs
hello world
...

$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED              STATUS              PORTS               NAMES
75223f6e5301        ubuntu:14.04        /bin/sh -c 'while tr   About a minute ago   Up About a minute                       pensive_goldstine
b17d05d26d60        ubuntu:14.04        /bin/bash              3 minutes ago        Up 3 minutes                            loving_darwin
17f22402c4cd        ubuntu:14.04        /bin/bash              3 minutes ago        Up 3 minutes                            backstabbing_davinci

$ docker stop backstabbing_davinci
```


### Install a web app

`training/webapp` is an image of a flask app to download (from dockerhub?)

-P Publish all exposed ports to the host interfaces

```
$ docker run -d -P training/webapp python app.py
```

See details of last image started with `docker ps -l`. The container is mapped to 49000-49900 on the host machine. 

To map to a different port use 

```
$ docker run -d -p 5000:5000 training/webapp python app.py
```

To figure out the boot2docker VM's ip:

```
$ boot2docker ip
The VM's Host only interface IP address is: 192.168.59.103
```

Equivalent of `tail -f` for the app's logs

```
$ docker logs -f drunk_elion
* Running on http://0.0.0.0:5000/
192.168.59.3 - - [04/Jul/2014 02:39:09] "GET / HTTP/1.1" 200 -
```

Output all sorts of interesting config settings for the image

```
$ docker inspect nostalgic_morse
[{
    "Args": [
        "app.py"
    ],
    "Config": {
        "AttachStderr": false,
        "AttachStdin": false,
        "AttachStdout": false,
        "Cmd": [
            "python",
...
```


Request a specific key

```
$ docker inspect -f '{{ .NetworkSettings.IPAddress }}' nostalgic_morse
172.17.0.18

```


### Install Ckan from 6 month old [project](https://github.com/kindly/ckan_dockered)

```
$ docker run --name=myckan -i -t -p 5000:80 kindly/ckan_base /bin/bash
root@1636673af484:/tmp#
```

browsing to `root@1636673af484:/tmp#` is nothing so maybe myckan isn't running anything on port 80?

```
root@1636673af484:/tmp# python -m SimpleHTTPServer 80
```

Now `http://192.168.59.103:5000/` shows the files in the tmp directory. woot woot

### Install CKAN using brand new [official support](http://docs.ckan.org/en/latest/maintaining/installing/install-using-docker.html)!


```
$ docker run -d --name db ckan/postgresql
$ docker run -d --name solr ckan/solr
$ docker run -d -p 80:80 --link db:db --link solr:solr ckan/ckan
```

browse to `http://192.168.59.103` and play with CKAN. Goodness. Way easy.


### Working with Docker Images

show docker images locally (where are they stored?)

```
$ docker images
REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
ckan/ckan              latest              95cd0d9c87a4        14 hours ago        772.1 MB
ckan/postgresql        latest              192057470cf4        10 days ago         429.2 MB
ubuntu                 14.04               e54ca5efa2e9        2 weeks ago         276.5 MB
...
```
### Teardown

```
$ docker ps
CONTAINER ID        IMAGE                    COMMAND               CREATED             STATUS              PORTS                NAMES
d9336d828f71        ckan/ckan:latest         /sbin/my_init         13 hours ago        Up 3 hours          0.0.0.0:80->80/tcp   boring_einstein
21747b72aee8        ckan/solr:latest         java -jar start.jar   13 hours ago        Up 3 hours          8983/tcp             boring_einstein/solr,solr
291b0394ace6        ckan/postgresql:latest   /usr/local/bin/run    13 hours ago        Up 3 hours          5432/tcp             boring_einstein/db,db

$ docker stop 291b0394ace6
...
```


