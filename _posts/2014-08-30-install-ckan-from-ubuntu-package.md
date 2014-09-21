---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-08-30"
published: true
permalink: "2014-08-30-install-ckan-from-ubuntu-package"
---

### Stream of Conscious Notes Following the [CKAN 2.2 install docs](http://docs.ckan.org/en/latest/maintaining/installing/install-from-package.html)



Ubuntu 12.04 64bit


as root on digital ocean droplet.

```
apt-get update
apt-get install -y nginx apache2 libapache2-mod-wsgi libpq5
wget http://packaging.ckan.org/python-ckan_2.2_amd64.deb
dpkg -i python-ckan_2.2_amd64.deb
apt-get install -y postgresql solr-jetty
```

### Config Solr

http://docs.ckan.org/en/latest/maintaining/installing/install-from-source.html#setting-up-solr

/etc/default/jetty

```
NO_START=0            # (line 4)
JETTY_HOST=127.0.0.1  # (line 15)
JETTY_PORT=8983       # (line 18)
```

```
$ service jetty start
 * Could not start Jetty servlet engine because no Java Development Kit
 * (JDK) was found. Please download and install JDK 1.4 or higher and set
 * JAVA_HOME in /etc/default/jetty to the JDK's installation directory.
```

Point Jetty at the JVM in /etc/default/jetty

```
JAVA_HOME=/usr/lib/jvm/java-6-openjdk-amd64/
```

Success!

```
$ service jetty start
grep: character class syntax is [[:space:]], not [:space:]
 * Starting Jetty servlet engine. jetty                                                                                                                                          * Jetty servlet engine started, reachable on http://ckan:8983/. jetty
```

```
$ wget http://localhost:8983
--2014-08-31 00:52:19--  http://localhost:8983/
Resolving localhost (localhost)... 127.0.0.1
Connecting to localhost (localhost)|127.0.0.1|:8983... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1082 (1.1K) [text/html]
Saving to: `index.html'

100%[======================================================================================================================================>] 1,082       --.-K/s   in 0s

2014-08-31 00:52:19 (71.0 MB/s) - `index.html' saved [1082/1082]
```


```
root@ckan:~# mv /etc/solr/conf/schema.xml /etc/solr/conf/schema.xml.bak
root@ckan:~# ln -s /usr/lib/ckan/default/src/ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
root@ckan:~# service jetty restart
```

```
$ vim /etc/ckan/default/production.ini
and set `solr_url = http://127.0.0.1:8983/solr` on line 74
```

```
$ cd /usr/lib/ckan/default/src/ckan
$ paster db init -c /etc/ckan/default/development.ini
The program 'paster' is currently not installed.  You can install it by typing:
apt-get install python-pastescript

$ apt-get install python-pastescript
```

failure to init db

```
$ paster db init -c /etc/ckan/default/production.ini
Traceback (most recent call last):
  File "/usr/bin/paster", line 4, in <module>
    command.run()
  File "/usr/lib/python2.7/dist-packages/paste/script/command.py", line 103, in run
    command = commands[command_name].load()
  File "/usr/lib/python2.7/dist-packages/pkg_resources.py", line 1989, in load
    entry = __import__(self.module_name, globals(),globals(), ['__name__'])
  File "/usr/lib/ckan/default/src/ckan/ckan/lib/cli.py", line 11, in <module>
    import ckan.lib.fanstatic_resources as fanstatic_resources
  File "/usr/lib/ckan/default/src/ckan/ckan/lib/fanstatic_resources.py", line 6, in <module>
    from fanstatic import Library, Resource, Group, get_library_registry
ImportError: No module named fanstatic

$ pip install fantastic
The program 'pip' is currently not installed.  You can install it by typing:
apt-get install python-pip

$ apt-get install python-pip

apt-get install python-pip
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following NEW packages will be installed:
  python-pip
0 upgraded, 1 newly installed, 0 to remove and 15 not upgraded.
Need to get 95.1 kB of archives.
After this operation, 399 kB of additional disk space will be used.
Get:1 http://mirrors.digitalocean.com/ubuntu/ precise/universe python-pip all 1.0-1build1 [95.1 kB]
Fetched 95.1 kB in 0s (1,269 kB/s)
Selecting previously unselected package python-pip.
(Reading database ... 122812 files and directories currently installed.)
Unpacking python-pip (from .../python-pip_1.0-1build1_all.deb) ...
Processing triggers for man-db ...
Setting up python-pip (1.0-1build1) ...
root@ckan:/usr/lib/ckan/default/src/ckan# pip install fantastic
Downloading/unpacking fantastic
  Could not find any downloads that satisfy the requirement fantastic
No distributions at all found for fantastic
Storing complete log in /root/.pip/pip.log
```

I needed to [activate python virtual env](http://docs.ckan.org/en/943-writing-extensions-tutorial/paster.html)

```
$ . /usr/lib/ckan/default/bin/activate
(default)root@ckan:/usr/lib/ckan/default/src/ckan# cd /usr/lib/ckan/default/src/ckan
(default)root@ckan:/usr/lib/ckan/default/src/ckan# paster db init -c /etc/ckan/default/production.ini
...
sqlalchemy.exc.OperationalError: (OperationalError) FATAL:  password authentication failed for user "ckan_default"
FATAL:  password authentication failed for user "ckan_default"
```

I probably need to setup postgres first?

### Setup Postgres user

```
$ sudo -u postgres createuser -S -D -R -P ckan_default
$ sudo -u postgres createdb -O ckan_default ckan_default -E utf-8
$ sudo mkdir -p /etc/ckan/default
$ sudo chown -R `whoami` /etc/ckan/
$ vim /etc/ckan/default/production.ini
change `sqlalchemy.url = postgresql://ckan_default:pass@localhost/ckan_default` to have the new password
```

```
$ ckan db init
```

### Install DataStore extension

```
$ vim /etc/ckan/default/production.ini
add datastore to list of plugins `ckan.plugins = <list of plugins> datastore`
```

"The DataStore requires a separate PostgreSQL database to save the DataStore resources to."

```
$ sudo -u postgres createuser -S -D -R -P -l datastore_default
$ sudo -u postgres createdb -O ckan_default datastore_default -E utf-8
```

Now, uncomment the ckan.datastore.write_url and ckan.datastore.read_url lines in your CKAN config file and edit them if necessary, for example:

```
ckan.datastore.write_url = postgresql://ckan_default:pass@localhost/datastore_default
ckan.datastore.read_url = postgresql://datastore_default:pass@localhost/datastore_default
```


Set permission

```
$ sudo ckan datastore set-permissions
Perform commands to set up the datastore.
    Make sure that the datastore URLs are set properly before you run
    these commands.

    Usage::

        paster datastore set-permissions SQL_SUPER_USER

    Where:
        SQL_SUPER_USER is the name of a postgres user with sufficient
                       permissions to create new tables, users, and grant
                       and revoke new permissions.  Typically, this would
                       be the "postgres" user.
```

Point [paster](http://ckan.readthedocs.org/en/1485-rtd-theme/maintaining/paster.html) at the config

```
$ paster datastore --config=/etc/ckan/default/production.ini set-permissions postgres
2014-08-31 01:26:47,376 WARNI [ckanext.datastore.plugin] Omitting permission checks because you are running paster commands.
Set permissions for read-only user: SUCCESS
```

```
$ sudo service apache2 restart
$ sudo service nginx restart
$ curl -X GET "http://127.0.0.1:80/api/3/action/datastore_search?resource_id=_table_metadata"
returns json if successfully installed
```

### Install [DataPusher](http://docs.ckan.org/projects/datapusher/en/latest/)

"Starting from CKAN 2.2, if you installed CKAN via a package install, the DataPusher has already been installed and deployed for you. You can skip directly to Configuration."

Woot!

Set site_url, add datapusher to ckan.plugins

```
$ vim /etc/ckan/default/production.ini
ckan.datapusher.url = http://104.131.23.252/
ckan.site_url = http://104.131.23.252/
ckan.plugins = <other plugins> datapusher

$ sudo service apache2 restart
$ curl 0.0.0.0:8800
{
  "help": "\n        Get help at:\n        http://ckan-service-provider.readthedocs.org/."
}
```

At this point you must supply a remote url but when you do, file preview and datastore api works!

### Select most recent records using datastore sql api

Figure out the query to run:

```
$ sudo -u postgres psql datastore_default

select * from "963cf23f-90be-479f-a7d7-7cb7fb29d45d" where "DateOpened" > (now() - '12 day'::interval);

# as a url:
http://104.131.23.252/api/action/datastore_search_sql?sql=select%20*%20from%20%22963cf23f-90be-479f-a7d7-7cb7fb29d45d%22%20where%20%22DateOpened%22%20%3E%20(now()%20-%20'12%20day'::interval)
```

### Set up FileStore

```
$ sudo mkdir -p /var/lib/ckan/default
$ vim /etc/ckan/default/production.ini
ckan.storage_path = /var/lib/ckan/default

$ sudo chown www-data /var/lib/ckan/default
$ sudo chmod u+rwx /var/lib/ckan/default
$ sudo service apache2 reload
```

Now you see the 'upload' link when adding a resource

### Determine CKAN version and extensions

`http://www.civicdata.com/api/util/status`

### Field Data type error in Datapusher table

```
ERROR [ckan.controllers.api] Validation error: '{\\'info\\': {\\'orig\\': [\\'invalid input syntax for type numeric: "12040846W7"\\\\nLINE 4:                     WHERE ("caseno") = (\\\\\\'12040846W7\\\\\\');\\\\n                                                ^\\\\n\\']}, \\'__type\\': \\'Validation Error\\', \\'data\\': \\'(DataError) invalid input syntax for type numeric: "12040846W7"\\\\nLINE 4:                     WHERE ("caseno") = (\\\\\\'12040846W7\\\\\\');\\\\n
```

caseno is numeric in the db. We should explicitly set its datatype during datastore_create

```
datastore_default=# \d my-upsertables-3
                                       Table "public.my-upsertables-3"
   Column   |            Type             |                            Modifiers
------------+-----------------------------+------------------------------------------------------------------
 _id        | integer                     | not null default nextval('"my-upsertables-3__id_seq"'::regclass)
 _full_text | tsvector                    |
 caseno     | numeric                     |
 CaseYr     | numeric                     |
 Address    | text                        |
 DateOpened | timestamp without time zone |
 CaseType   | text                        |
 Status     | text                        |
 StatusDate | timestamp without time zone |
 Closed     | text                        |
 parcelId   | numeric                     |
 lat        | numeric                     |
 lng        | numeric                     |
Indexes:
    "my-upsertables-3_pkey" PRIMARY KEY, btree (_id)
    "my-upsertables-3_caseno_key" UNIQUE CONSTRAINT, btree (caseno)

datastore_default=# alter table "my-upsertables-3" alter column caseno type text;
```
