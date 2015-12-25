---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-12-16"
permalink: "2015-12-16-drupal-8-force-ssl-pantheon"
---

### To use SSL throughout the Pantheon dev workflow

When using the dev-my-site.pantheon.io domain (or test or live), put this bad boy at the top of your settings. It will redirect HTTP to HTTPS.

```php
/sites/default/settings.php
<?php

// Require HTTPS on pantheon
if (isset($_SERVER['PANTHEON_ENVIRONMENT']) &&
  $_SERVER['HTTPS'] === 'OFF') {
  if (!isset($_SERVER['HTTP_X_SSL']) ||
    (isset($_SERVER['HTTP_X_SSL']) && $_SERVER['HTTP_X_SSL'] != 'ON')) {
    header('HTTP/1.0 301 Moved Permanently');
    header('Location: https://'.$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI']);
    exit();
  }
}

...
```

Also see the related [pantheon docs](https://pantheon.io/docs/articles/sites/domains/adding-a-ssl-certificate-for-secure-https-communication/).
