# CoffeeTags

A  simple tool for generating tags (Ctags compatible ) for use with Vim + [TagBar plugin](https://github.com/majutsushi/tagbar)

![screenshot!](https://img.skitch.com/20110922-j5u4pfi9ur4c76yppwwmd7kf9h.jpg)

It might work with other plugins/editors which can use Ctags (such as Emacs or
TagList for Vim).

# Requirements

* ruby (either 1.8.7 or 1.9.2)
* Vim
* [TagBar plugin](https://github.com/majutsushi/tagbar)


# Installation

* get the `coffeetags` tool

    `gem install CoffeeTags`


* add TagBar config to your .vimrc

    `coffeetags vim_config >> ~/.vimrc`

* open your coffeescript file and open TagBar.

Done!

# TODO

- squash all bugs
