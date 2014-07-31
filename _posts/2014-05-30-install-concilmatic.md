---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-06-24"
published: false
permalink: "2014-06-27-foo"
---

* install [pdftotext](http://www.bluem.net/en/mac/packages/)



```
createdb template_postgis
psql -f /usr/local/share/postgis/postgis.sql template_postgis
psql -f /usr/local/share/postgis/spatial_ref_sys.sql template_postgis
createdb -T template_postgis councilmatic

createuser -s -r postgres
> createuser: creation of new role failed: ERROR:  role "postgres" already exists

cp local_settings.py.template local_settings.py

Would you like to create one now? (yes/no): yes
Username (leave blank to use 'erik'):
Email address:
Password:
Password (again):

python manage.py migrate
python manage.py loadlegfiles
python manage.py updatelegfiles
> DatabaseError: permission denied for relation phillyleg_legfile
psql councilmatic -c 'alter database councilmatic owner to postgres'

python manage.py updatelegfiles
> ImproperlyConfigured: Error importing legislation scraper
> phillyleg.management.scraper_wrappers.sources.hosted_legistar_scraper.HostedLegistarSiteWrapper: "No module named legistar.scraper"

pip install legistar-scraper


# ImportError: No module named bs4
pip install BeautifulSoup4

alter database lateraldev owner to pavan
```



##### todo: copy settings_local.py back to template