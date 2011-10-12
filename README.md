# CoffeeTags

A  simple tool for generating CoffeeScript tags (Ctags compatible ).

Showing only functions (right) or with variables included (left)


<div class="thumbnail">

<a href="http://skitch.com/plugawy/gyfnb/1-coffeetags-1-vim-unicorn.local-tmux"><img src="http://img.skitch.com/20111012-8cjesum8ru8usqusra4yppj5cc.preview.png" alt="1. CoffeeTags:1:vim - "unicorn.local" (tmux)" /></a><br /><span>Uploaded with <a href="http://skitch.com">Skitch</a>!</span>

</div>

Designed for use with Vim + [TagBar plugin](https://github.com/majutsushi/tagbar) but also works without it. Simply configure your Vim for use with a regular tags file and generate them with the following command:

`coffeetags -R -f TAGS`

# Requirements

* ruby (either 1.8.7 or 1.9.2)
* Vim

### optional

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

    `coffeetags --vim-conf >> ~/.vimrc` (or `coffeetags --vim-conf --include-vars >> ~/.vimrc`)

* open your coffeescript file and open TagBar.

Done!

# TODO

- squash all bugs
