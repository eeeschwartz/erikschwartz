---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-07-01"
published: true
permalink: "2014-07-01-install-qgis-osx"
---

Running OSX Mavericks

Following the [official qgis install guide](http://www.kyngchaos.com/software/qgis)

Installs everything to: `/Library/Frameworks/`

```
http://www.kyngchaos.com/files/software/frameworks/GEOS_Framework-3.4.2-3.dmg
http://www.kyngchaos.com/files/software/frameworks/PROJ_Framework-4.8.0-1.dmg
http://www.kyngchaos.com/files/software/frameworks/UnixImageIO_Framework-1.5.0.dmg
http://www.kyngchaos.com/files/software/frameworks/SQLite3_Framework-3.7.17-2.dmg
http://www.kyngchaos.com/files/software/frameworks/GDAL_Framework-1.11.0-4.dmg
# install NumPy and GDal complete framework
http://www.kyngchaos.com/files/software/python/matplotlib-1.3.1-2.dmg
http://www.kyngchaos.com/files/software/qgis/QGIS-2.4.0-1.dmg
```

```
brew install postgresql
brew install postgis
createdb postgis_demo
psql -d postgis_demo -c "CREATE EXTENSION postgis;"
```