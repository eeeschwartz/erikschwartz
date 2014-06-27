---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-06-27"
published: true
title: Add Keynote Slides to iMovie
permalink: "2014-06-27-add-keynote-slides-to-i-movie"
---

We had a fantastic event last week at Code for America called [BETA](http://beta.codeforamerica.org/), a so called "civic show and tell". It was recorded for posterity, the only snag being that we didn't record all of the magnificent slides that people produced. The good news is that we can hack together a way to embed them in the video along with the lovely presenters.

### Problem Statement

Shucks, I have video of presentors but not their slides.

### Solution
 
* Follow along to the presentor video
* Record the slide transitions in Keynote
* Export the perfectly-timed Keynote slides as a video
* Embed the slides video in the presentor video like a boss
* ...
* Profit

### Record slide transitions in Keynote (version 6)
* Open the presentor video and get ready to play it
* In Keynote menu `Play > Record Slideshow...`
* Start the presentor video so that you can listen along
* Back to Keynote, click the mic to mute audio input. Click record.
* Transition the slides as you listen to the presentation
* `File > Export To > Quicktime`

### Embed slides video into presentation video in iMovie (version 10)
* Create event, create new video (called Lexingteam in image below) and import your presentor video ![image](/images/presentors-video.jpg)
* Drag the slides video above the presentor video ![image](/images/add-slides-video.jpg)
* Move the slides video left/right until the transitions line up with the presentors

### Adjust the slides video
* Click the 'Adjust' menu in the upper right ![image](/images/adjust-menu.jpg)
* Select the slides video clip in the video area below
* Set to 'picture in picture' and set the dissolve time to 0.0
* Drag and resize the slides video window to your liking (you can also change 'dissolve' to 'swap' to make your slides the main picture and your presentation video the smaller picture)

### Video editing tips from a n00b
* You can click and hold on a part of the slides video to copy and repeat a section. This is helpful to make the intro slide longer. 
* If you have several video or picture sections above the 'main' video (for instance, if you copied the beginning slide to cover the beginning of the presentation), you can copy picture-in-picture adjustments like resizing the slides video. Adjust the video clip, `Edit > Copy`, select all of the clips and `Edit > Paste Adjustments > All`.

