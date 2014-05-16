##### [Vim: change in search](#vim-change-in-search)

I often want to perform a search on a phrase that does not conform to word boundaries, change the matched text and repeat over a buffer. 

```
really_long_var_name = 'bar'
...
if (really_long_var_name == 'bar')
end
```


Let's change `really_long_var_name` to `shorter_var_name`

I'd like to search for `really_long` do something like `ciw shorter` on the first result and then hit `n.` to repeat the action on future matches. Unfortunately `ciw` doesn't work because `w` captures the entire `really_long_var_name` rather than just the part we want to change. The most obvious solution is a bit cumbersome: `:s/really_long/shorter/gc`. Let's see about writing a vimscript for `cir` (or maybe &?) or `change in result`. 

Solution: use [this snippet](https://github.com/eeeschwartz/dotfiles/commit/6ef78d524627211daa00d518266c658199a115c8) to turn the search result into a text object referred to by "s". Now `cs` becomes "change selection" and is repeatable with commands like `n.` as in "Move to next result and repeat the previous command"


##### [Firefox: show/hide bookmarks toolbar with a keystroke](#fn-infer)
* Via [an add-on](https://addons.mozilla.org/bn-BD/firefox/addon/show-hide-bookmarks-toolbar/)
* Although I didn't install the add-on. Instead I will try the keystroke to show/hide the bookmarks sidebar `Command b`.

##### [Firefox: search page with regex](#fn-infer)
* [Fastest Search Add-on](https://addons.mozilla.org/en-US/firefox/addon/fastest-search/)
* I'm a little wary of willy-nilly installing add-ons so I'm going to punt on this for now.


##### [Git: search on any branch](#fn-infer)
* As seen on [Stack Overflow](http://stackoverflow.com/a/15293283) `git grep <regexp> $(git rev-list --all)`

##### [Markdown: anchor to each of these headings](#fn-infer) :)
* As seen on [SO](http://stackoverflow.com/a/7335259), it's [Pretty simple](#pretty-simple)

##### [Markdown: infer the anchor name](#markdown-infer-the-anchor-name)
* For each of these topic I'd like custom anchor like so `[Vim: do something faster](#vim-do-something-faster)`. 
* The anchor is based on the link body so I want to be able to create the the anchor by writing this: `[Vim: do something interesting](#fn-infer-anchor)`
* Then I preprocess the file with a simple script.
* <script src="https://gist.github.com/eeeschwartz/23b87ee34bc5a5d40920.js"></script>
