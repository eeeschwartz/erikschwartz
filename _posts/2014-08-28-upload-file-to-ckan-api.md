---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---
### Upload to CKAN

using civicdata.com

* geojson files do not seem to work. Preview says error: error
* Having a geojson file as a resource on the same dataset as a csv, breaks the csv preview. It hangs indefinitely
* civicdata seems to have the datastore extension installed.

### Upsert to CKAN datastore from Pentaho

In Pentaho

* New step: 'Modified Java Script Value'
	* 
* New step: 'HTTP Post'
	* General tab
		* URL: 'http://www.civicdata.com/api/action/datastore_upsert'
	* fields tab
		* resource_id: 26e07d51-e1fa-424f-b88d-b56580c4d5b1
		* records: [{"CaseNo":"123", "Closed":"False"}] 
		* succeeds in Pentaho but nothing on civicdata changes
		
### Turn up logging level for Pentaho

When launching, set logging to: 'Rowlevel (very detailed)'

now I can see the http response from civicdata

`Bad request - JSON Error: Error decoding JSON data. Error: JSONDecodeError(...`


### Install wireshark to analyze HTTP request

* brew install wireshark --with-qt
* [Note from the future, use [runscope.net](http://runscope.net) instead! h/t [@jeremiak](https://twitter.com/jeremiak)]

### Oh shoot, I wasn't using the API key

### Use postman chrome extention to talk to CKAN API manually

* `http://www.civicdata.com/api/action/datastore_search?resource_id=26e07d51-e1fa-424f-b88d-b56580c4d5b1`

```
curl -X POST -v http://civicdata.com/api/3/action/datastore_upsert -H "Authorization: KEY" -d '{"resource_id": "26e07d51-e1fa-424f-b88d-b56580c4d5b1","records": [{"CaseNo":"123", "Closed":"False"}]}'
```

From the CKAN docs

```
curl -X POST http://127.0.0.1:5000/api/3/action/datastore_create -H "Authorization: {YOUR-API-KEY}" -d '{"resource_id": "{RESOURCE-ID}", "fields": [ {"id": "a"}, {"id": "b"} ], "records": [ { "a": 1, "b": "xyz"}, {"a": 2, "b": "zzz"} ]}'
```

```
curl -v -X POST http://civicdata.com/api/3/action/datastore_delete \
 -H "Authorization: KEY" \
-d '{"resource_id": "26e07d51-e1fa-424f-b88d-b56580c4d5b1"}' \
-H "Content-Type: application/json"

* Adding handle: conn: 0x7ff3da004000
* Adding handle: send: 0
* Adding handle: recv: 0
* Curl_addHandleToPipeline: length: 1
* - Conn 0 (0x7ff3da004000) send_pipe: 1, recv_pipe: 0
* About to connect() to civicdata.com port 80 (#0)
*   Trying 205.178.189.129...
* Connected to civicdata.com (205.178.189.129) port 80 (#0)
> POST /api/3/action/datastore_delete HTTP/1.1
> User-Agent: curl/7.30.0
> Host: civicdata.com
> Accept: */*
> Authorization: KEY
> Content-Type: application/json
> Content-Length: 55
>
* upload completely sent off: 55 out of 55 bytes
< HTTP/1.1 200 OK
* Server Sun-ONE-Web-Server/6.1 is not blacklisted
< Server: Sun-ONE-Web-Server/6.1
< Date: Fri, 22 Aug 2014 03:23:31 GMT
< Content-type: text/html
< Transfer-encoding: chunked
<
* Connection #0 to host civicdata.com left intact
<html><head><title>CIVICDATA.COM</title><meta name="keywords" content=""</head><frameset rows="100%", *" border="0" frameborder="0"><frame src="http://civicdataprod.cloudapp.net/index.html/api/3/action/datastore_delete" name="CIVICDATA.COM"></frameset></html>%
```

### Try to write to LFUCG dev CKAN instance (2.1?)

They do not seem to have datastore installed

```
curl -X GET "http://[dev-ec2-instance]/api/3/action/datastore_search?resource_id=_table_metadata"
"Bad request - Action name not known: datastore_search"
```

### Search with CKAN resource_search

http://[dev-ec2-instance]/api/3/action/resource_search?resource_id=6d70ff05-b1c0-4d6d-993a-bca357a0b94f&query=CaseNo:2014

Not sure why you can't search on a valid field

```
{
...
 "success": false,
    "error": {
        "query": "Field \"CaseNo\" not recognised in resource_search.",
        "__type": "Validation Error"
    }
}
```

Perhaps you need to set up the key datatypes in the resource metadata?

### Use the CKAN FileStore API instead?

* [Docs](http://docs.ckan.org/en/latest/api/index.html#ckan.logic.action.update.package_update) to update a package's metadata

### Update a resource's metadata

```
CKAN_INSTANCE='http://[dev-ec2-instance]'
PACKAGE_ID='code-enforcement-complaints'
RESOURCE_ID='6d70ff05-b1c0-4d6d-993a-bca357a0b94f'
URL='http://[dev-ec2-instance]/storage/f/2014-08-24T14%3A40%3A47.694Z/code-enforcement-geocoded-2014.csv'
FORMAT='csv'
CKAN_APIKEY='FOO'
FILENAME=$1

curl $CKAN_INSTANCE/api/3/action/resource_update \
  --data '{ "package_id":"'$PACKAGE_ID'",
    "id":"'$RESOURCE_ID'",
    "url":"'$URL'",
    "format":"'$FORMAT'",
    "name":"'$FILENAME'"}' \
  -H Authorization:$CKAN_APIKEY
```

### Update a resource's file to a public url


* [Upload](http://docs.ckan.org/en/latest/maintaining/filestore.html?highlixght=filestore%20api#filestore-api
) with a remote url
* curl -H'Authorization: your-api-key' 'http://yourhost/api/action/resource_update' --form url=http://expample.com --form clear_upload=true --form id=resourceid

```
$ curl -H'Authorization: KEY' \
'http://[dev-ec2-instance]/api/action/resource_update' \
--form url=https://raw.githubusercontent.com/codeforamerica/lexington-citygram-etl/master/code-enforcement-geocoded-2014.csv \
--form clear_upload=true \
--form id=6d70ff05-b1c0-4d6d-993a-bca357a0b94f

"Bad request - JSON Error: Error decoding JSON data. Error: ValueError('No JSON object could be decoded',) JSON data extracted from the request: '------------------------------4e2503b52fb2;\\r\\nContent-Disposition: form-data; name=\"url\"\\r\\n\\r\\nhttps://raw.githubusercontent.com/codeforamerica/lexington-citygram-etl/master/code-enforcement-geocoded-2014.csv\\r\\n------------------------------4e2503b52fb2;\\r\\nContent-Disposition: form-data; name=\"clear_upload\"\\r\\n\\r\\ntrue\\r\\n------------------------------4e2503b52fb2;\\r\\nContent-Disposition: form-data; name=\"id\"\\r\\n\\r\\n6d70ff05-b1c0-4d6d-993a-bca357a0b94f\\r\\n------------------------------4e2503b52fb2;--'"
```

```
CKAN_INSTANCE='http://[dev-ec2-instance]'
RESOURCE_ID='6d70ff05-b1c0-4d6d-993a-bca357a0b94f'
URL='http://[dev-ec2-instance]/storage/f/2014-08-24T14%3A40%3A47.694Z/code-enforcement-geocoded-2014.csv'
CKAN_APIKEY='FOO'
curl $CKAN_INSTANCE/api/3/action/resource_update \
  --data '{
    "id":"'$RESOURCE_ID'",
    "url":"'$URL'"
  }' \
  -H Authorization:$CKAN_APIKEY
```

This updates the url but the data preview does not work. It requires [some CKAN configuration](http://docs.ckan.org/en/1117-start-new-test-suite/data-viewer.html#resource-proxy).

### Difference between Pentaho Tranformation and Job

* Transformation [runs in parallel](https://www.youtube.com/watch?feature=player_detailpage&v=ayFt9L0n_rM#t=139), row-wise
* Job runs in sequence

### Update a resource's values by uploading a file

[Good examples](https://gist.github.com/mheadd/a9bb37a51972cbff8ae0) of CKAN file management via the filestore API (pre-CKAN 2.2).

Pentaho Job

* HTTP, this completely replaces existing version. Although the datapusher does not always become active to copy the new values into the API and preview.

```
curl -H'Authorization: KEY' \
'http://[dev-ec2-instance]/api/3/action/resource_update' \
--form upload=@code-enforcement-geocoded-2014.csv \
--form id=6d70ff05-b1c0-4d6d-993a-bca357a0b94f
```

### Possible to use CKAN harvest extension to pull data in?

Looks [complicated](http://docs.ckan.org/en/ckan-1.7.3/harvesting.html) based on the 1.7.3 docs.

### For CKAN 2.2, you can update a resource in one command

```
curl -H'Authorization: your-api-key' 'http://yourhost/api/action/resource_update' --form upload=@newfiletoupload --form id=resourceid
```

### Upsert using the DataStore [faulty approach]

The following approach is wrong because it doesn't send raw json as the body of the request. See next section for this in action.

Here we want to upload a set of data that overlaps with what exists and insert where new and update where existing. 

* Requires a primary key

```
curl -v $CKAN_INSTANCE/datastore_upsert \
  --form primary_key='CaseNo' \
  --form resource_id="eb5527a6-2974-4772-b8cd-b69d99c26882" \
  --form force=true \
  -H "Authorization: $CKAN_APIKEY"
```

* upsert from file [causes 500 error]

```
curl -v $CKAN_INSTANCE/datastore_upsert \
  --form id="eb5527a6-2974-4772-b8cd-b69d99c26882" \
  --form force=true \
  --form upload=@code-enforcement-geocoded-2014.csv \
  -H "Authorization: $CKAN_APIKEY"
```

from ckan_default.error.log

```
Error - <type 'exceptions.TypeError'>: FieldStorage('upload', u'code-enforcement-geocoded-2014.csv') is not JSON serializable
```

This seems to be a bug in my version of CKAN, where the json is not parsed in the `db.py` upsert
* Ok let's try json

The resource_create action with primary_key does not seem to create a unique key in postgres

```
$ sudo -u postgres psql datastore_default
alter table my-upsertables-3 add unique(caseno);
```

```
curl -v $CKAN_INSTANCE/datastore_upsert \
  --form id="my-upsertables-3" \
  --form force=true \
  --form records="`cat code-enforcement-geocoded-2014.json`"\
  --form method=upsert \
  -H "Authorization: $CKAN_APIKEY"
```

set the primary key on the datastore to enable upsert

```
curl -v $CKAN_INSTANCE/datastore_create \
  --form fields='[{"id":"caseno","type":"text"}]' \
  --form primary_key="caseno" \
  --form resource_id="171991a8-c6ed-4415-9745-72c0390f56bc" \
  --form format="csv" \
  --form force=true \
  -H "Authorization: $CKAN_APIKEY"
```

```
"message": "Only lists of dicts can be placed against subschema ('fields',), not <type 'unicode'>", "__type": "Integrity Error"}
```

### Correct approach

```
curl -v $CKAN_INSTANCE/resource_create \
  --form id="upsert-me-6" \
  --form package_id="new-thing" \
  --form format="csv" \
  --form upload=@code-enforcement-geocoded-2014.csv \
  -H "Authorization: $CKAN_APIKEY"

sleep 5

curl -v $CKAN_INSTANCE/datastore_create \
  -d '{"resource_id": "upsert-me-6", "fields": [{"id":"CaseNo","type":"text"}, {"id":"CaseYr", "type":"Text"}], "primary_key":"CaseNo", "force":"true"}' \
  -H "Authorization: $CKAN_APIKEY"

curl -v $CKAN_INSTANCE/datastore_upsert \
   -d '{"resource_id": "upsert-me-6",
    "force":"true",
    "records":'"`jq .records code-enforcement-geocoded-2014.json`"'
  }' \
  -H "Authorization: $CKAN_APIKEY"
```


### This method works, but is x-www-form-urlencoded!

So it can only send limited sized payloads.

### In walks the datapusher extension

Preliminary question: what is the difference between datastorer and datapusher? Civicdata.com uses datastorer but I see that datapusher's documentation says that it is meant to replace datastorer.

I installed via ubuntu package and datapusher was already installed and mostly configured. But how do you give it data to upsert?


### Fix bug where json bareword "true" causes error


alter table "complaints" alter column "Closed" type boolean using case when "Closed" = 'true' then TRUE ELSE FALSE END;

### Upload csv to datastore through web UI

* The uploaded file doesn't have the parcelId, lat, long. Possible to add the files through the API?

```
fields='[{"id":"CaseNo","type":"text"},{"id":"CaseYr","type":"text"},{"id":"Address","type":"text"},{"id":"DateOpened","type":"date"},{"id":"CaseType","type":"text"},{"id":"Status","type":"text"},{"id":"StatusDate","type":"date"},{"id":"Closed","type":"bool"},{"id":"parcelId","type":"text"},{"id":"lat","type":"float"},{"id":"lng","type":"float"}]'

curl -v $CKAN_BASE_URL/api/action/datastore_create \
  -d '{"resource_id": "'$resource_id'","fields": '$fields', "primary_key":"CaseNo", "force":"true"}' \
  -H "Authorization: $CKAN_API_KEY"
```

This is successful!
