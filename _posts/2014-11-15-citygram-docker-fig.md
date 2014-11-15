---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
published: false
permalink: ""
---

### Prereqs

* Install [boot2docker and fig](http://www.fig.sh/install.html)



* start boot2docker server `boot2docker start`
* `git clone git@github.com:codeforamerica/citygram.git`
* add Dockerfile, fig.yml
* `fig build`

### Try to upgrade to ruby 2.1.4

```
Your Ruby version is 2.1.4, but your Gemfile specified 2.1
Service 'web' failed to build: The command [/bin/sh -c bundle install] returned a non-zero code: 18

```

* Update Gemfile to ruby 2.1.4
* `fig build`
* `fig run web rake db:create db:migrate`

```
Creating citygramfig_db_1...
Could not find minitest-5.4.2 in any of the sources
Run `bundle install` to install missing gems.
```


* `fig run web bundle install` <-- wrong, should be `fig build` to make changes stick
* `fig build`

```
...
web_1 | /usr/local/bundle/gems/bundler-1.7.4/lib/bundler/spec_set.rb:92:in `block in materialize': Could not find twilio-ruby-3.13.1 in any of the sources (Bundler::GemNotFound)
```

* Many gems are erroring  - gems are installed but they are slightly different versions
* The Dockerfile was running `bundle install` before `ADD . /myapp`
* 
### Trying different postgis docker images

* helmi03/docker-postgis - fails on start due to ssl problem. Size: ~500MB
* 

### 
* `fig run web rake db:create db:migrate`

