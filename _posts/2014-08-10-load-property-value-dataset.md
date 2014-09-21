---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

download House value dataset to current directory

psql

```
$ \list
$ \c geocode_code_enforcement
You are now connected to database "geocode_code_enforcement" as user "erik".
geocode_code_enforcement-# \dt
         List of relations
 Schema |   Name   | Type  | Owner
--------+----------+-------+-------
 public | ce_calls | table | erik
 public | parcels  | table | erik
```

```
$ csvsql --db postgresql:///geocode_code_enforcement --insert --table property_values ~/Downloads/Property\ Value\ \(2011-2014\).csv
```

### Load voting precincts into DB

```
$ shp2pgsql -s 4326 VotingPrecinct/VotingPrecinct.shp | psql -d geocode_code_enforcement
SET
SET
BEGIN
CREATE TABLE
ALTER TABLE
ERROR:  function addgeometrycolumn(unknown, unknown, unknown, unknown, unknown, integer) does not exist
LINE 1: SELECT AddGeometryColumn('','votingprecinct','geom','4326','...
```

### Add PostGIS, duh

psql

```
geocode_code_enforcement=# CREATE EXTENSION postgis;
CREATE EXTENSION
```

### Import voting precincts

```
$ shp2pgsql -s 4326 ~/Downloads/VotingPrecinct/VotingPrecinct.shp | psql -d geocode_code_enforcement

# Add geom to precinct
psql $ SELECT UpdateGeometrySRID('votingprecinct','geom',4326);
psql $ SELECT AddGeometryColumn ('public','parcels','geom',4326,'POINT',2);
psql $ UPDATE parcels SET geom = ST_SetSRID(ST_MakePoint("X", "Y"), 4326);
UPDATE 109351
```

yay!



### Add voting precinct to parcels

Note that in the parcel table X,Y is the centroid

```
alter table parcels add column voting_precinct_id INT;
update parcels AS p  set voting_precinct_id = v.gid from votingprecinct AS v  WHERE (st_contains(v.geom, p.geom));
```

###
```
geocode_code_enforcement=# select count(*) from property_values ;
 count
--------
 438707

geocode_code_enforcement=# \d property_values
          Table "public.property_values"
    Column     |         Type         | Modifiers
---------------+----------------------+-----------
 parid         | character varying(8) | not null
 class         | character varying(1) | not null
 taxyr         | integer              | not null
 faircashvalue | double precision     | not null
 taxablevalue  | double precision     | not null
```

```
geocode_code_enforcement=# select count(*) from property_values where taxablevalue <> 0 limit 10;
 count
--------
 424623
(1 row)

geocode_code_enforcement=# select count(*) from property_values where taxablevalue <> faircashvalue limit 10;
 count
-------
 95556
(1 row)
```
