---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Fire up Squirrel SQL

* Select BldgInsp Catalog
* `select * from vw_OpenData_BI_Permits`

### Export 2014 Cases

* `select * from vw_OpenData_BI_Permits where SUBSTRING(Date, 7, 9) >= 2014;`
* Fully qualified: `select * from [BldgInsp].[dbo].[vw_OpenData_BI_Permits] where SUBSTRING(Date, 7, 9) >= 2014;`
* unselect "Limit to 100 rows"
* Execute sql (Ctrl+Enter)
* right click on resultset and save to `/Users/erik/code/citygram_data/building-permits-2014.csv`

### Geocode addressess

```
ruby geocode_addresses.rb building-permits-2014.csv > building-permits-geocoded-2014.csv
```

### Load into local postgres


```
$ psql geocode_code_enforcement -c 'drop table if exists building_permits'
$ csvsql --db postgresql:///geocode_code_enforcement --insert --table building_permits building-permits-geocoded-2014.csv
```

### Dump geojson to file locally and push to heroku

```
rake generate_geojson:building_permits
```