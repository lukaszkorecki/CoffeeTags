# encoding: utf-8
require "CoffeeTags/version"
require "CoffeeTags/parser"
require "CoffeeTags/formatter"

class Object
  def blank?
    if self.respond_to? :"empty?"
      self.nil? or self.empty?
    else
      self.nil?
    end
  end
end

module Coffeetags
  AUTHOR = "Łukasz Korecki /lukasz@coffeesounds.com/"
  NAME = "CoffeeTags"
  URL = "https://github.com/lukaszkorecki/CoffeeTags"
  TAGBAR_COFFEE_CONF = <<-CONF
 let g:tagbar_type_coffee = {
  \\ 'kinds' : [
  \\   'f:functions',
  \\   'o:object'
  \\ ],
  \\ 'kind2scope' : {
  \\  'f' : 'object',
  \\   'o' : 'object'
  \\},
  \\ 'sro' : ".",
  \\ 'ctagsbin' : 'coffeetags',
  \\ 'ctagsargs' : '',
  \\}
  CONF

  class Utils

    def self.option_parser args
      @@include_vars = false
      puts @include_vars
      args << 'help' if args.empty?
      y args
      case args.first
      when /version|^v/
        STDOUT <<  "CoffeeTags #{Coffeetags::VERSION}"
        exit 0
      when 'help'
        STDOUT << "coffeetags #{Coffeetags::VERSION} - [version|vim_conf] or path to a coffeescript file"
        exit 0
      when /vim_conf/
        puts <<-HELP
" Add this type definition to your vimrc
" or do
" coffeetags vim_conf >> <PATH TO YOUR VIMRC>
        HELP
        puts Coffeetags::TAGBAR_COFFEE_CONF
        exit 0
      when /--include-vars/
        @@include_vars = true
      end

      puts @include_vars
      self.run args

    end

    def self.run files
      puts @include_vars
      files.reject { |f| f =~ /^--/}.each do |file|
        sc = File.read file

        puts @@include_vars
        parser = Coffeetags::Parser.new sc, @@include_vars
        parser.execute!

        formatter = Coffeetags::Formatter.new file, parser.tree

        formatter.parse_tree

        STDOUT << formatter.to_file
      end
    end
  end
end
