# CoffeeTags

### Latest version: `0.0.3`

A  simple tool for generating CoffeeScript tags (Ctags compatible).

[![Build Status](https://secure.travis-ci.org/lukaszkorecki/CoffeeTags.png?branch=master)](http://travis-ci.org/lukaszkorecki/CoffeeTags)


### [Watch a quick demo](http://ascii.io/a/26)

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
* Vim or [Sublime Text](http://www.sublimetext.com/) and [CTags plugin](https://github.com/SublimeText/CTags)

### optional

* Vim
  * [TagBar](https://github.com/majutsushi/tagbar)

# Halp!

Just use `coffeetags --help`

# Installation

* get `coffeetags`

    `gem install CoffeeTags`


## Vim installation
* add TagBar config to your .vimrc

`coffeetags --vim-conf >> ~/.vimrc`

## Sublime Text

*TODO* - I don't use ST myself, but PRs with HOWTO are welcome


## Config types

CoffeeTags can work in 2 modes:

- tags only for functions (default)
- tags for functions and objects containing them

Second mode is activated by adding `--include-vars` to command line arguments

#   CoffeeTags + TagBar + Vim

## Config in  vimrc

You can add the config to your .vimrc (making sure that the old one is removed)
by:

    coffeetags --vim-conf >> ~/.vimrc

or (for 2nd mode)

    coffeetags --include-vars --vim-conf >> ~/.vimrc


## Config as a filetype plugin

You can generate a special filetype plugin and tagbar will use that
automatically.

This option is preferable if you want to keep your vimrc short.

    coffeetags --vim-conf > ~/.vim/ftplugin/coffee/tagbar-coffee.vim
    coffeetags [--include-vars] --vim-conf > ~/.vim/ftplugin/coffee/tagbar-coffee.vim

or if you're using pathogen

    coffeetags [--include-vars] --vim-conf > ~/.vim/bundle/coffeetags/ftplugin/coffee/tagbar-coffee.vim
    coffeetags --vim-conf > ~/.vim/bundle/coffeetags/ftplugin/coffee/tagbar-coffee.vim


* open your coffeescript file and open TagBar.

Done!

# TODO

- squash all bugs


# License

MIT


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/lukaszkorecki/coffeetags/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

