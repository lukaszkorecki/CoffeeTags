# CoffeeTags

### Latest version: `0.2.0`

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

* ruby (1.8.7, 1.9.2 or 1.9.3)

### Editors supported

* Vim with [TagBar](https://github.com/majutsushi/tagbar)
* [Sublime Text](http://www.sublimetext.com/) and [CTags plugin](https://github.com/SublimeText/CTags)


# Halp!

Just use `coffeetags --help`

# Ruby Gem

## Installation

`gem install CoffeeTags`

## Usage

`$ coffeetags --help`

# Vim

This can also be used as a vim plugin that will update tag files on save, and support visualization with [TagBar](https://github.com/majutsushi/tagbar). You will still need to install the gem as described above as well as install the plugin to vim. You can install it via:

## Install

*  [Pathogen](https://github.com/tpope/vim-pathogen)
  *  `git clone https://github.com/lukaszkorecki/CoffeeTags ~/.vim/bundle/CoffeeTags`
*  [NeoBundle](https://github.com/Shougo/neobundle.vim)
  *  `NeoBundle 'lukaszkorecki/CoffeeTags'`
*  [Vundle](https://github.com/gmarik/vundle)
  *  `Bundle 'lukaszkorecki/CoffeeTags'`
*  manual
  *  copy all of the files into your `~/.vim` directory

## Configuration

In you `~/.vimrc` you can configure the plugin with:

```
let g:CoffeeAutoDisabled=<0 or 1>        " Disables autotaging on save (Default: 0 [false])
let g:CoffeeAutoTagFile=<filename>       " Name of the generated tag file (Default: ./tags)
let g:CoffeeAutoTagIncludeVars=<0 or 1>  " Includes variables (Default: 0 [false])
let g:CoffeeAutoTagTagRelative=<0 or 1>  " Sets file names to the relative path from the tag file location to the tag file location (Default: 1 [true])
```

## Sublime Text

*TODO* - I don't use ST myself, but PRs with HOWTO are welcomed

## Config types

CoffeeTags can work in 2 modes:

- tags only for functions (default)
- tags for functions and objects containing them

Second mode is activated by adding `--include-vars` to command line arguments

# TODO

- squash all bugs

# License

MIT

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/lukaszkorecki/coffeetags/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

