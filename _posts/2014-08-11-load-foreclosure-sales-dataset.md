---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Create foreclosure_sales table from csv

```
$ csvsql --db postgresql:///geocode_code_enforcement --insert --table foreclosure_sales ~/Downloads/Foreclosure\ Sales\ \(2011-2014\).csv
```

psql 

```
$ \list
$ \c geocode_code_enforcement
You are now connected to database "geocode_code_enforcement" as user "erik".
geocode_code_enforcement-# \dt
         List of relations
 Schema |       Name        | Type  | Owner
--------+-------------------+-------+-------
 public | ce_calls          | table | erik
 public | foreclosure_sales | table | erik
 public | parcels           | table | erik
 public | property_values   | table | erik
 public | spatial_ref_sys   | table | erik
 public | votingprecinct    | table | erik```
```


### Aggregate foreclosure sales by month by voter precinct
```
geocode_code_enforcement=# select count(*) from foreclosure_sales ;
 count
--------
 4196
 
geocode_code_enforcement=# \d foreclosure_sales ;
       Table "public.foreclosure_sales"
  Column  |         Type          | Modifiers
----------+-----------------------+-----------
 parid    | integer               | not null
 class    | character varying(1)  | not null
 saledate | date                  | not null
 price    | integer               | not null
 saleval  | character varying(24) | not null
```

