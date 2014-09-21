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

### Aggregate property values by month by voter precinct
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

Oh wait! Property values is calculated yearly. Grouping by month is a non-starter.
