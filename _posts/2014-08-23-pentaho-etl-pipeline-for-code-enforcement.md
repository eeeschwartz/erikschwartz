---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Start geocoder

* foreman start -f Procfile.dev (starts elasticsearch and server at localhost:9393)

Shell script called from kettle job to upload most recent file

``` shell 
curl -v $CKAN_INSTANCE/resource_update \
  --form upload=@/Users/erik/code/citygram_data/code-enforcement-geocoded-2014.csv \
  --form id="eb5527a6-2974-4772-b8cd-b69d99c26882" \
  -H "Authorization: $CKAN_APIKEY"
```

### Mimic LIMIT, OFFSET MySQL behavior in MS SQL Server

```
SELECT * FROM ( 
	select *, ROW_NUMBER() OVER (ORDER BY Cast(StatusDate as datetime) DESC) as row from vw_OpenData_CodeEnf_Cases where CaseYr >= 2014
) t 	where row >  10 AND row <= 20
```