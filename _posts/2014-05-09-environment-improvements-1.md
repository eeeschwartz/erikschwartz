---
layout: post
category: blog
"current-tab": blog
author: Erik Schwartz
date: "2014-05-09"
permalink: "2014-05-09-environment-improvements-1"
---

## Environment Improvements May 2 - May 9, 2014
As I write software I jot down minor annoyances in the development workflow or things I'd like to generally understand better. Each morning I spend 20 minutes addressing one or two problems and capture my new learnings here for posterity.

##### <a name="vim-editing-macros"></a> [Vim: Editing Macros]({{page.url}}#vim-editing-macros)

* `C-r C-r a` inserts register `a` in command mode

* `*` register is system clipboard

##### <a name="vim-make-temporary-key-mapping-to-run-a-script-youre-debugging"></a> [Vim: make temporary key mapping to run a script you're debugging]({{page.url}}#vim-make-temporary-key-mapping-to-run-a-script-youre-debugging)
* `map <leader>r :!spring rake db:seed<cr>`

##### <a name="vim-copy-filename-to-system-clipboard"></a> [Vim: Copy filename to system clipboard]({{page.url}}#vim-copy-filename-to-system-clipboard)
* `:let @* = expand("%")` [from Stack Overflow](http://stackoverflow.com/questions/916875/yank-file-name-path-of-current-buffer-in-vim)
* To map a keystroke `:nmap cp :let @* = expand("%")`

##### <a name="vim-ignore-keep-files-from-ctrl-p-file-search"></a> [Vim: Ignore .keep files from ctrl-p file search]({{page.url}}#vim-ignore-keep-files-from-ctrl-p-file-search)
* `let g:ctrlp_custom_ignore = '.keep\|node_modules\|DS_Store\|git\|tmp/cache\|.swp'`

##### <a name="vim-delete-text-within-html-tag"></a> [Vim: delete text within html tag]({{page.url}}#vim-delete-text-within-html-tag)

* `dit` who knew?!

##### <a name="vim-tab-refresher-for-easily-looking-at-gem-source-code"></a> [Vim: tab refresher for easily looking at gem source code]({{page.url}}#vim-tab-refresher-for-easily-looking-at-gem-source-code)

```
	tabe          create new tab
	gt            go to next tab
	gT            go to previous tab
	{i}gt         go to tab in position i
```

##### Vim: [prompt](http://travisjeffery.com/b/2011/11/saving-files-in-nonexistant-directories-with-vim/) to [mkdir if doesn't exist]({{page.url}}#vim-mkdir-if-doesnt-exist)

```
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir)
          \   && (a:force
          \       || input("'" . a:dir . "' does not exist. Create? [y/N]") =~? '^y\%[es]$')
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
```

##### <a name="bash-use-cut-remove-leading-whitespace"></a> [Bash: Use cut remove leading whitespace]({{page.url}}#bash-use-cut-remove-leading-whitespace)
Useful for removing extraneous stuff before piping output to another command

```
$ git branch
   foo-branch
$ git branch | cut -c 3-
foo-branch
```

#### <a name="like emacs"></a> [Bash: Movement by words (like emacs)]({{page.url}}#bash-movement-by-words-like-emacs)
* `M-f` forward
* `M-b` backward


##### <a name="deploy-non-master-branch-to-heroku"></a> [deploy non-master branch to heroku]({{page.url}}#deploy-non-master-branch-to-heroku) (aka use standard git to push a feature branch to heroku master)
g push heroku search-park-name:master


##### <a name="binstubs"></a> [Binstubs]({{page.url}}#binstubs)
* Prepare the environment before shelling out to an executable
* In practice this means the script makes sure the executable runs against the project's ruby version and gemset

