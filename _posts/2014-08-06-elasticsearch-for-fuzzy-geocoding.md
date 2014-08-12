---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-07-31"
published: true
permalink: ""
---

```
$ ruby -v
ruby 1.9.3p484 (2013-11-22 revision 43786) [x86_64-darwin13.0.2]
$ gem install elasticsearch
$ elasticsearch --config=/usr/local/opt/elasticsearch/config/elasticsearch.yml
```

```
require 'elasticsearch'

# Connect to localhost:9200 by default:
es = Elasticsearch::Client.new log: true

# Round-robin between two nodes:
# This returns an http error, faraday can't find search1 or search2
# es = Elasticsearch::Client.new hosts: ['search1:9200', 'search2:9200']

# Connect to localhost explicitly instead
es = Elasticsearch::Client.new hosts: ['localhost:9200']

# Connect to cluster at search1:9200, sniff all nodes and round-robin between them
es = Elasticsearch::Client.new hosts: ['localhost:9200'], reload_connections: true

# Index a document:
es.index index: 'my_app',
         type:  'blog_post',
         id: 1,
         body: {
          title:   "Elasticsearch clients",
          content: "Interesting content...",
          date:    "2013-09-24"
         }

# Get the document:
es.get index: 'my_app', type: 'blog_post', id: 1

# Search:
es.search index: 'my_app',
          body: { query: { match: { title: 'elasticsearch' } } }
```


### Add a bit of data

http://joelabrahamsson.com/elasticsearch-101/

* Install Sense Chrome Extension
* Get rid of index cruft

```
curl -XDELETE "http://localhost:9200/_all" -d'
{
   "query": {
      "match_all": {}
   }
}'
```

```
PUT /addresses/address/38108180
{
    "PVANUM": 38108180,
    "NUM1": 2469,
    "NAME": "FOO",
    "TYPE": "RD",
    "ADDRESS": "2469 ROCKMINSTER RD",
    "UNIT": ""
}
```

### Search the data

```
GET _search
{
   "query": {
      "query_string": {
         "default_field": "ADDRESS",
         "query": "ROCKMINSTER"
      }
   }
}
```

```
GET _search
{
   "query": {
      "query_string": {
         "default_field": "ADDRESS",
         "query": "469 Martin luther"
      }
   }
}
```

### Snapshot the index

```
$ curl -XPUT 'http://localhost:9200/_snapshot/addresses_index' -d '{
    "type": "fs",
    "settings": {
        "location": "/Users/erik/code/address-service/addresses_index"
    }
}'

# Get info about it
GET /_snapshot/addresses_index?pretty
```