---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### [update] [Newer installation instructions](https://github.com/lfucg/lexington-pentaho-etl)

### Set up machine

```
adduser foouser sudo
```

Login as foouser

```
sudo apt-get update
sudo apt-get install git
sudo apt-get install unzip
sudo apt-get install default-jre
java -version
=> java version "1.6.0_32"
```


### Get latest stable build of Pentaho Data Integration


```
cd ~
wget http://sourceforge.net/projects/pentaho/files/Data%20Integration/5.1/pdi-ce-5.1.0.0-752.zip/download
unzip download
```

Test running a transformation from the command line

```
cd data-integration
./pan.sh -file "./samples/transformations/JsonInput - read a file.ktr"
```
Update pan.sh to accept OPT from Environment

```
$ vim pan.sh
update OPT="..."
to
OPT="$OPT ..."
```


### Set environment vars

```
git clone https://github.com/eeeschwartz/pentaho-transformations.git
cd pentaho-transformations
cp .env.pentaho.sample .env.pentaho
vim .env.pentaho # set vars for your system
```

### Set up automation cronjobs

```
cd pentaho-transformations
mkdir logs
crontab -e
```

Add the following lines to the crontab

```
15,45 * * * * ~/pentaho-transformations/upsertDatasets.sh
17,47 * * * * ~/pentaho-transformations/geocodeDatasetsInNeed.sh
```

### Run a transformation

```
cd ~/pentaho-transformations && source ~/pentaho-transformations/.env.pentaho && ~/data-integration/pan.sh -level=Basic -file "pull-last-day-of-code-enforcement.ktr"
```
