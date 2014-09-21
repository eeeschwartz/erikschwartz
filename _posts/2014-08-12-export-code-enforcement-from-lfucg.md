---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

## Fire up Squirrel SQL

* Select Code_Enforcement Catalog


### Order by status date

`select * from vw_OpenData_CodeEnf_Cases where CaseYr = 2014 order by convert(date, StatusDate, 105) DESC; `

Use [msdn code 105](http://msdn.microsoft.com/en-us/library/ms187928.aspx) to cast varchar to date for ordering. 

Fails with
```
Error: The input character string does not follow style 106, either change the input character string or use a different style.
SQLState:  S1000
ErrorCode: 9807
```


### Export 2014 cases only (~7000)

`select * from vw_OpenData_CodeEnf_Cases where CaseYr >= 2014;`

Right click in resultset area and save as csv to /Users/erik/code/citygram_data/cocde-enforcement-2014.csv

### Geocode addressess

start local elasticsearch instance with PVA addresses indexed

```
$ elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

```
$ ruby geocode_addresses.rb > code-enforcement-geocoded-2014.csv
# takes a minute or two
```

### Load into postgres


```
$ psql geocode_code_enforcement -c 'drop table if exists code_enforcement'
$ csvsql --db postgresql:///geocode_code_enforcement --insert --table code_enforcement code-enforcement-geocoded-2014.csv
```

### Check how many rows have been updated

## # # ```
select * from code_enforcement where "StatusDate" > now() - '2 day'::INTERVAL;
```