# CoffeeTags

### Latest version: [![Gem version][ruby-gems-image]][ruby-gems-url]

A  simple tool for generating CoffeeScript tags (Ctags compatible).

[![Build Status][travis-image]][travis-url] [![Coverage Status][coveralls-image]][coveralls-url]

### [Watch a quick demo](https://asciinema.org/a/26)

## Huh?

CoffeeTags was created for use with Vim and [TagBar plugin](https://github.com/majutsushi/tagbar), however it
accepts most common ctags arguments, therefore the following:

`coffeetags -R -f TAGS`


will generate standard TAGS file which later can be used with Vim (standard `:tag` command works as expected)

# Requirements

* ruby 1.8.7 and up

### Windows support

[Yup, we got it!](https://github.com/lukaszkorecki/CoffeeTags/issues/28#issuecomment-44046429)


### Editors supported

* [NeoVim](https://neovim.io) with [TagBar](https://github.com/majutsushi/tagbar)
* Vim with [TagBar](https://github.com/majutsushi/tagbar)
* [Sublime Text](http://www.sublimetext.com/) and [CTags plugin](https://github.com/SublimeText/CTags)


# Halp!

Just use `coffeetags --help`

# Ruby Gem

## Installation

`gem install CoffeeTags` (or `sudo gem install CoffeeTags`)

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
let g:CoffeeAutoTagDisabled=<0 or 1>     " Disables autotaging on save (Default: 0 [false])
let g:CoffeeAutoTagFile=<filename>       " Name of the generated tag file (Default: ./tags)
let g:CoffeeAutoTagIncludeVars=<0 or 1>  " Includes variables (Default: 0 [false])
let g:CoffeeAutoTagTagRelative=<0 or 1>  " Sets file names to the relative path from the tag file location to the tag file location (Default: 1 [true])
```

# Sublime Text

See [this issue on SublimeText/Ctags](https://github.com/SublimeText/CTags/issues/33)

# Config types

CoffeeTags can work in 2 modes:

- tags only for functions (default)
- tags for functions and objects containing them

Second mode is activated by:

- Adding `--include-vars` to command line arguments
- Setting `let g:CoffeeAutoTagIncludeVars=1` in your `~/.vimrc` for vim

# TODO

- squash all bugs

# License

MIT

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/lukaszkorecki/coffeetags/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

[travis-url]: https://travis-ci.org/lukaszkorecki/CoffeeTags
[travis-image]: https://travis-ci.org/lukaszkorecki/CoffeeTags.svg?branch=master

[ruby-gems-url]: http://rubygems.org/gems/CoffeeTags
[ruby-gems-image]: https://badge.fury.io/rb/CoffeeTags.svg

[coveralls-url]: https://coveralls.io/r/lukaszkorecki/CoffeeTags?branch=master
[coveralls-image]: https://img.shields.io/coveralls/lukaszkorecki/CoffeeTags.svg
