---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2016-01-23"
permalink: "2016-01-23-google-analytics-events-in-google-tag-manager"
---

When using Google Analytics (GA) directly, you can send custom events to GA in javascript like so:

```
ga('send', {
   'hitType': 'event',
   'eventCategory': 'Feedback',
   'eventAction': 'event action',
   'eventLabel': $(‘#feedback-text’).val(),
   'eventValue': 1
});
```

However, with Google Tag Manager (GTM), you don’t have the `ga` javascript object. Instead you can:

* push variables to the GTM dataLayer object
* create a tag in GTM that sends the variables along to GA

Here are the steps:

### Replace your call to "ga('send'”

Let’s say you use the `ga` javascript object to send an event to GA on a form submission:

```
$('#feedback-form').submit(function(e) {
    ga('send', {
        'hitType': 'event',
        'eventCategory': 'Feedback',
        'eventAction': 'event action',
        'eventLabel': $(‘#feedback-text’).val(),
        'eventValue': 1
    });
    ...
});
```

With GTM, you’ll do this instead:

```
$('#feedback-form').submit(function(e) {
    dataLayer.push({
        'hitType': 'event',
        'eventCategory': 'Feedback',
        'eventAction': 'General',
        'eventLabel': $('#feedback-text').val(),
        'eventValue': 1
    });
    ...
});
```

Next you’ll configure a GTM tag to fire. In this tag you'll pick up the values from the dataLayer and give them to GA.

### In GTM: Map GTM variables to dataLayer variables

`Variables > User Defined Variables > New > Data Layer Variable`

`> Configure Variable > Data Layer Variable Name: eventLabel` (this is the variable name used in the javascript call to dataLayer.push)

I like to name the GTM variable as dataLayer.[variableName], in this case [dataLayer.eventLabel](https://www.dropbox.com/s/e7v8zj6xnayxk97/Screenshot%202016-01-23%2013.41.58.png?dl=0).

### In GTM: Create a tag to send the dataLayer variable(s) to GA

`Tags > New > Google Analytics > Universal Analytics`

* Tracking Id: UA-1242343-12 (i.e. your tracking id)
* Track Type: Event
* Event Tracking Parameters
  * Here you can use the GTM dataLayer variables you mapped earlier. In this example, I hard-code every value [except for dataLayer.eventLabel](https://www.dropbox.com/s/qxe1m872ht6qyvg/Screenshot%202016-01-23%2013.52.14.png?dl=0)
* Create The trigger
  * [Fire On](https://www.dropbox.com/s/n1v74r1n1ty1b6x/Screenshot%202016-01-23%2013.26.16.png?dl=0): `Form > Form Submission > Some Forms > "Form Id” equals “feedback-form"`

### Test that the variable is sent to Google Analytics

Save the tag and trigger and click the GTM [Preview and Debug](https://www.dropbox.com/s/rlyggiqs7ntzaxi/Screenshot%202016-01-23%2013.55.05.png?dl=0) (each time you make changes to GTM).

In a new tab, visit the site with the feedback form. You should see the GTM [debugging pane](https://www.dropbox.com/s/cqnuvwz0yxhel07/Screenshot%202016-01-23%2013.56.26.png?dl=0) at the bottom of the page. It _should_ fire our newly created tag when the form is submitted.

Submit the feedback form.

In Google Analytics `Reporting > Real-time > Events`

You should see an entry for the just-submitted event. Click into it and you will see the [eventLabel detail](https://www.dropbox.com/s/02bb37nypryy6hk/Screenshot%202016-01-23%2013.57.23.png?dl=0).

