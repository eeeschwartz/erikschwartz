---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---
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
