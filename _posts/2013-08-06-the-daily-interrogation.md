---
layout: post
category: projects
"current-tab": projects
author: Erik Schwartz
permalink: introducing-interrogatorrr
---
It's not as bad as it sounds.

### Challenge
It takes more than 1 minute to write a blog post (not to mention that introverts need to prepare their brain to spaz out with the extros running around everywhere).

### Solution
You receive a phone call. A friendly robot asks you an open ended question:

* What's been on your mind today?
* What did you dream about?
* Describe the mood in your city lately.
* etc

Your 1 minute answer is transcribed and published to your blog.

<audio src="/twilio-recording.mp3" controls="controls">
</audio>
\[... transcription would live here ...\]

I like the idea of posting the audio as well as the text. I did some genealogy work recently and it occurred to me how much I would love to hear the voices of long-gone relatives. It would give such interesting insight into their personality and temperament.

So I wrote a [simple application](https://github.com/eeeschwartz/interrogatorrr) as a proof of concept.

### Application structure
Actors:

- The interstitial app hosted on heroku (app)
- Jekyll blog hosted on github pages (blog)
- Twilio (twilio)

Under the hood:

- The app wakes up and tells twilio to call you with a question.
- Twilio records the answer and hits the callback endpoint on the app
- The app grabs the recording and transcript of the call
- The app creates a jekyll-formatted post and commits it to the blog repo
- The app deploys the blog changes to github pages and "hello world"

I've put together a proof of concept and will be posting the resulting interrogations here. Please feel free to run with [the project](https://github.com/eeeschwartz/interrogatorrr) on github. Contributions welcome.
