---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: true
permalink: ""
---

```
createdb "geocode_code_enforcement"
csvsql --db postgresql:///geocode_code_enforcement --insert --table ce_calls data/ce-gecoded.csv
psql geocode_code_enforcement -c 'DROP TABLE parcels'
csvsql --db postgresql:///geocode_code_enforcement --insert --table parcels data/ParcelCentroids.csv
```

Add id

### Connect to DB with sequel

`map <leader>r :!ruby %<cr>`

To make sure sequel result set is dataset is of the table object (eg CodeEnforcment) rather than hash

http://fredwu.me/post/58910814911/gotchas-in-the-ruby-sequel-gem

### Inspect distance between geocoders

select distance_between_geocoders from ce_calls where distance_between_geocoders IS NOT NULL order by distance_between_geocoders DESC;

Not sure what the unit of distance is

```
geocode_code_enforcement=# select COUNT(*) from ce_calls where distance_between_geocoders IS NOT NULL AND distance_between_geocoders < 10;
 count
-------
 36537
(1 row)
```
```
geocode_code_enforcement=# select COUNT(*) from ce_calls where distance_between_geocoders IS NOT NULL AND distance_between_geocoders > 10;
 count
-------
  1162
(1 row)
```

```
geocode_code_enforcement=# select count(*) from ce_calls where distance_between_geocoders IS NOT NULL AND distance_between_geocoders < .05;
 count
-------
 27602
(1 row)
```

This distance is actually between elasticsearch and nominatim, the distance_between_geocoders is about to be recalculated for these google geocoded results

```
geocode_code_enforcement=# select sum(distance_between_geocoders) from ce_calls where google_result = true;
     sum
-------------
 530021.4827
(1 row)
```

### Snapshot DB before re-calculating distance

```
pg_dump geocode_code_enforcement > data/pg_ce_calls_nominatim_distance
```

### Recalculate distance

```
with_parcel_id = DB[:ce_calls].join(:parcels, :PVANUM => :parcel_id).where("google_result = true AND distance_between_geocoders > 0").all

$ ruby calculate_distance.rb | tee diff_between_google_and_nominatim_distance.csv

geocode_code_enforcement=# select sum(distance_between_geocoders) from ce_calls where google_result = true;
    sum
-----------
 3717.4155
(1 row)
```