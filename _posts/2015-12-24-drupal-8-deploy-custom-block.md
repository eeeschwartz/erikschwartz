---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2015-12-24"
permalink: "2015-12-24-drupal-8-deploy-custom-block"
hidden: true
---

### Well, you can’t \_exactly\_ deploy a custom block in Drupal

This is because "[a custom block is made of two entities, one for the placement and the actual content](http://drupal.stackexchange.com/a/146052/54929)".

So if you create a custom block in development and deploy it to production using `drush config-import` you’ll get the following error:

```
This block is broken or missing. You may be missing content or you might need to enable the original module.
```

### The workaround

Create a custom block in production that is disabled in the block layout. Sync the db to your dev environment. This allows you to add configuration that syncs to its related content on production (via the content's UUID).

Workflow:

- Make sure the custom block type exists on production
- Block layout > create custom block that is disabled
    - Add the content that you want
- Sync production db to dev environment
- In dev, place the block, configure, style it, etc.
- export the config with `drush config-export`
- Check in and deploy the config changes to prod
