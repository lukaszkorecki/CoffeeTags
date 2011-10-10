# CoffeeTags

A  simple tool for generating tags (Ctags compatible ) for use with Vim + [TagBar plugin](https://github.com/majutsushi/tagbar)

![screenshot!](https://img.skitch.com/20110922-bf1dipa6kgdu2i18yr1xh8nwa3.png)

It might work with other plugins/editors which can use Ctags (such as Emacs or
TagList for Vim).

# Requirements

* ruby (either 1.8.7 or 1.9.2)
* Vim
* [TagBar plugin](https://github.com/majutsushi/tagbar)

# Halp!

`coffeetags --help`

    -R - process current directory recursively and look for all *.coffee files
    --f  <file> - save tags to <file>, if <file> == '-' tags get print out to STDOUT (jscatgs style)
    --version - coffeetags version
    --vim-conf - print out tagbar config for vim
    --include-vars - include objects/variables in generated tags
    combine --vim-conf and --include-vars to create a config which adds '--include-vars' option

# Installation

* get the `coffeetags` tool

    `gem install CoffeeTags`


* add TagBar config to your .vimrc

    `coffeetags vim_config >> ~/.vimrc`

* open your coffeescript file and open TagBar.

Done!

# TODO

- squash all bugs
