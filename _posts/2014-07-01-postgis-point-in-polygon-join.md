---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-07-01"
published: true
permalink: "2014-07-01-postgis-point-in-polygon-join"
---

Assuming you have a shapefile

```
shp2pgsql -s 4326 VotingPrecinct/VotingPrecinct.shp | psql -d postgis_demo
```


```
csvsql --db postgresql:///postgis_demo --insert --table ce_calls ce_calls_gecoded.csv
```

update column names manually since the camelcase columns are not usable in postgres (today for me anyway)

```
head -n 1 ce_calls_geocoded_bad_headers.csv > ce_calls_gecoded.csv
vim ce_calls_geocoded.csv # fix the headings
# tail all but the header line
tail -n +2 ce_calls_geocoded_bad_headers.csv >> ce_calls_gecoded.csv
```

Error message

```
You don't appear to have the necessary database backend installed for connection string you're trying to use. Available backends include:

Postgresql:	pip install psycopg2
MySQL:		pip install MySQL-python

For details on connection strings and other backends, please see the SQLAlchemy documentation on dialects at:

http://www.sqlalchemy.org/docs/dialects/
```
```
pip install psycopg2
```

in qgis: `Layer > Add PostGIS layers`

Problem: csvsql doesn't insert lat long as point!

Add point column to ce_calls table

```
SELECT AddGeometryColumn ('public','ce_calls','geom',4326,'POINT',2);
UPDATE ce_calls SET geom = ST_SetSRID(ST_MakePoint(geo_longitude, geo_latitude), 4326);
```

Update SRID of voting precinct table

```
SELECT UpdateGeometrySRID('votingprecinct','geom',4326);
```

join on point in voting precinct

```
select objectid, c.* from votingprecinct v join ce_calls c ON (st_contains(v.geom, c.geom));
```

select counts against years

in a file named ce_calls.sql

```
copy
(select objectid as id,
  sum(case when extract(year from dateopened) = 2011 then 1 else 0 end) as y_2011,
  sum(case when extract(year from dateopened) = 2012 then 1 else 0 end) as y_2012,
  sum(case when extract(year from dateopened) = 2013 then 1 else 0 end) as y_2013,
  sum(case when extract(year from dateopened) = 2014 then 1 else 0 end) as y_2014
  from votingprecinct v inner join ce_calls c ON(st_contains(v.geom, c.geom))
  where casetype = 'Housing'
  group by objectid
) TO STDOUT WITH CSV HEADER;
```

run the query from command line, and export to stdout as csv

```
cat ce_calls.sql | xargs -0 psql -d postgis_demo -c > assets/data/metric/ce-housing.csv
```