It's not as bad as it sounds.

### Challenge
It takes more than 1 minute to write a blog post (not to mention that introverts need to prepare their brain to spaz out with the extros running around everywhere).

### Solution
Receive a phone call. It asks you an open ended question: 

* What's been on your mind today?
* What did you dream about?
* What is the mood in your city lately?
* …

Your 1 minute answer is transcribed and published to your blog.

I like the idea of posting the audio as well as the text. After doing some genealogy work recently it occurred to me how much I would love to hear the sound of long-gone relatives voices. It would give such interesting clues about their personality and temperament.

### Application structure
Characters:

- The interstitial app hosted on heroku (app)
- Jekyll blog hosted on github pages (blog)
- Twilio (twilio)

Workflow:

- The app wakes up and tells twilio to call you with a question.
- Twilio records the answer and hits the callback endpoint on the app
- The app grabs the recording and transcript of the call 
- The app creates a jekyll-formatted post and commits it to the blog repo
- The app deploys the blog changes to github pages and "hello world"

I've put together a proof of concept and will be posting the results here. Please feel free to run with the project [on github]()