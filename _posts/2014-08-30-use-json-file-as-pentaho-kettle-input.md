---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Transform JSON to CSV

JSON Input [step documentation](http://infocenter.pentaho.com/help/index.jsp?topic=%2Fpdi_user_guide%2Freference_step_json_input.html)

Kettle comes with a host of good example tranformations in `design-tools\data-integration\samples\transformations`

Uses [JSONPath](http://goessner.net/articles/JsonPath/) to traverse the incoming json

I download [Grand Rapids building permits](http://www.civicdata.com/api/3/action/datastore_search?resource_id=c4651e26-05ef-4894-b43e-bdf7d0b622c6) and traverse the json in the JSON step with > Fields > Path '$..['Permit No']'

You can extract the field names from the metadata with > Fields > Path '$..[id]'

### Use CKAN resource metadata to dynamically transform the json to csv

The JSON file has all of the fields so ideally we can read those fields and dynamically tranform the json records to csv rather than specifying the fields we want to extract statically. Not sure how to do this.


