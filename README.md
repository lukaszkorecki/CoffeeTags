# CoffeeTags

A  simple tool for generating CoffeeScript tags (Ctags compatible).


### Example + Screenshot
Showing only functions (right) or with variables included (left)

<a href="http://skitch.com/plugawy/gyfnb/1-coffeetags-1-vim-unicorn.local-tmux"><img src="http://img.skitch.com/20111012-8cjesum8ru8usqusra4yppj5cc.preview.png" alt="1. CoffeeTags:1:vim - "unicorn.local" (tmux)" /></a><br /><span>Uploaded with <a href="http://skitch.com">Skitch</a>!</span>

## Huh?

CoffeeTags was created for use with Vim and [TagBar plugin](https://github.com/majutsushi/tagbar), however it
accepts most common ctags arguments, therefore the following:

`coffeetags -R -f TAGS`


will generate standard TAGS file which later can be used with Vim (standard `:tag` command works as expected)

# Requirements

* ruby (either 1.8.7 or 1.9.2)
* Vim

### optional

* [TagBar](https://github.com/majutsushi/tagbar)

# Halp!

Just use `coffeetags --help`

# Installation

* get `coffeetags`

    `gem install CoffeeTags`


* add TagBar config to your .vimrc

`coffeetags --vim-conf >> ~/.vimrc`

There are additional flags you can pass or use a `ftplugin', [read more](https://github.com/lukaszkorecki/CoffeeTags/blob/master/tagbar-info.markdown)

* open your coffeescript file and open TagBar.

Done!

# TODO

- squash all bugs
