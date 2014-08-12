---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-07-31"
published: true
permalink: ""
---

### I need to create a new layer in the shapefile for the neighborhood districts



Download neighborhood association shp

http://data.lexingtonky.gov/dataset/neighborhoodassoc/resource/d07f522e-3e8f-46a4-b6a5-7cfe6f44efb7

Council districts

http://data.lexingtonky.gov/dataset/board-of-elections-council-district/resource/18180bdb-4f91-45b5-bbcb-8fe696bbd0e8


```
topojson -o public/data/geography.topo.json -s 7e-11 --id-property=OBJECTID voting-precincts/voting-precincts.shp NeighborhoodAssoc/NeighborhoodAssoc.shp Council/Council.shp
```

topojson -o public/data/geography2.topo.json -s 7e-11 --id-property=OBJECTID ~/Downloads/voting-precincts/voting-precincts.shp

topojson -o public/data/geography.topo.json -s 7e-11 --id-property=OBJECTID ~/Downloads/VotingPrecinct/VotingPrecinct.shp ~/Downloads/NeighborhoodAssoc/NeighborhoodAssoc.shp ~/Downloads/Council/Council.shp


### Remove layer from map

