---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-11-16"
permalink: "2015-11-16-install-pantheon-drupal-8-mamp"
---

Stream of consciousness setup of:

* local OSX dev environment
* based on a Pantheon Drupal 8 install

```
git clone pantheon-site.git
point MAMP apache at pantheon-site directory
```

### Create local settings file

cp sites/example.settings.local.php sites/default/settings.local.php

Refreshing localhost yields this error:

```
Skip to main content
Drupal 8.0.0-rc3
Error
The website encountered an unexpected error. Please try again later.
Drupal\Core\Database\ConnectionNotDefinedException: The specified database connection is not defined: default in Drupal\Core\Database\Database::openConnection() (line 366 of core/lib/Drupal/Core/Database/Database.php).

Drupal\Core\Database\Database::openConnection('default', 'default')
Drupal\Core\Database\Database::getConnection()
Drupal\Core\Config\BootstrapConfigStorageFactory::getDatabaseStorage()
Drupal\Core\Config\BootstrapConfigStorageFactory::get()
install_begin_request(Object, Array)
install_drupal(Object)
```

### Set up database

roughly following these instructions to “Create the Drupal Database": https://www.drupal.org/node/66187

append to settings.local.php

```
$databases['default']['default'] = array(
  'driver' => 'mysql',
  'database' => 'databasename',
  'username' => 'username',
  'password' => 'password',
  'host' => 'localhost',
  'prefix' => 'main_',
  'collation' => 'utf8mb4_general_ci',
);
```

Refreshing http://localhost:8888/core/install.php yields a blank page. Look at phpmyinfo via mamp: http://localhost:8888/MAMP/index.php?language=English&page=phpinfo to find the PHP error log.

```
tail -f /Applications/MAMP/logs/php_error.log

[17-Nov-2015 01:46:36 Europe/Berlin] PHP Fatal error:  Uncaught exception 'Symfony\Component\DependencyInjection\Exception\InvalidArgumentException' with message 'The service definition "renderer" does not exist.'
```

hm. I’m going to update the database settings before looking deeper into a renderer error.

...

After creating the database, the error is gone. I’m taken to the Drupal install screen. In my case, I want to use the db from Pantheon.

In phpmyadmin > import > browse to database.tar.gz downloaded from Pantheon.

### Fix salt config error

Error:
```
Additional uncaught exception thrown while handling exception.
Original

RuntimeException: Missing $settings['hash_salt'] in settings.php. in Drupal\Core\Site\Settings::getHashSalt() (line 145 of /Users/erikschwartz/code/lexky-d8/core/lib/Drupal/Core/Site/Settings.php).
```

append to settings.local.php

```
$settings['hash_salt'] = 'fooshnickens';
```

### Point at MAMP version of PHP

```
which php
/usr/bin/php
```

append to .zshrc or .bashrc

```
export MAMP_PHP=/Applications/MAMP/bin/php/php5.5.26/bin
export PATH="$MAMP_PHP:$PATH"

# Give access to MAMP mysql client
export PATH=$PATH:/Applications/MAMP/Library/bin
```

Now the MAMP php is used:

```
which php
/Applications/MAMP/bin/php/php5.5.26/bin/php
```

### Install Drush 8

Error:

```
> drush status
Drush 7.1.0 does not support Drupal 8. You will need Drush version 8 or higher. See http://docs.drush.org/en/master/install/ for details.
```

Get drush from HEAD, which is 8.0-dev for Drupal 8.0.0-rc3 at the moment.

```
composer global require drush/drush:dev-master
drush version
Drush Version   :  8.0-dev
```

### Debug the Drush DB connection

```
drush updatedb
Drush command terminated abnormally due to an unrecoverable error.                                                                                                                                                                                                                                                                                            [error]
Error: Call to undefined function drupal_get_installed_schema_version() in /Users/erikschwartz/code/lexky-d8/core/includes/install.inc, line 80
```

```
drush status —debug
```

Note the error in the output:
```
  sh: mysql: command not found
```

The MAMP mysql binary needs to be in the path:

Add to the .bashrc or .zshrc

```
export PATH=$PATH:/Applications/MAMP/Library/bin
```

And drush can now connect to mysql!
