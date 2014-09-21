---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Creating tranformation from csv to geocoded csv

* New transformation
* save `code/pentaho/csv-to-heroku.ktr`
* Drag new step to canvas: Input > 'CSV file input'
	* filename: `/Users/erik/code/citygram_data/building-permits-2014.csv`
	* Lazy conversion: "false"
	* otherwise, in further javascript steps, you get the error: `Unable to verify if [CaseNo String(13)<binary-string>] is null or not because of an error:java.lang.ClassCastException: java.lang.String cannot be cast to [B`
* Click 'Get Fields', should show building permit fields
* New step: Lookup > HTTP Client 
	* URL: 'http://localhost:9393/geocode'
	* Fields Tab > Add parameter > Name: 'Address', Parameter: 'query' 
	* effectively: http://localhost:9393/geocode?query={Address})
	* Address is fed from previous step, query is what the geocoder expects
* New Step: Modified Java Script Value
	* Compatibility Mode: on
	* Click `Test script`
	* Set results value to `{"results":[{"formatted_address":"936 CHINOE RD","parcel_id":13288495,"geometry":{"location":{"lat":38.0038342907754,"lng":-84.4850186716363}}}]}
`
	* Now write a script to grab the address of the first result :P
	
```
var results = JSON.parse(geocoderResponse).results;

if (results.length > 0) {
	parcelId = results[0].parcel_id;
}
```
* New Step: Text file output
	* Filename: '/Users/erik/code/citygram_data/code-enforcement-geocoded-2014.csv'
	* Content Tab > 'Separator': ,
	* Fields Tab > delete geocoderResponse field
	
### Output to postgres table [not working]

* New step 'Table Output'
* Add parameters from `heroku config` postgres using JDBC
* It fails because ssl is turned off. 
* When I try to [turn on ssl](http://stackoverflow.com/a/9465210) by editing the database connection > options, I'm unable to add more than one option :P
* [later] I was able to add more options by Command + clickining in a cell for a new row

I'd like to set these options for the connection:

```
ssl = true
sslfactory = org.postgresql.ssl.NonValidatingFactory
```

* Database Fields Tab
	* Truncate table: true
	* Specify database fields: true
	* Click 'Get fields'
	* Errors out...
	
	
	
