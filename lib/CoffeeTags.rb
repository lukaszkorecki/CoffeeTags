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

  STRINGS = {
    'version' => "#{NAME} #{Coffeetags::VERSION} by #{AUTHOR} ( #{URL} )",
    'help' => <<-HELP
-R - process current directory recursively and look for all *.coffee files
--f  <file> - save tags to <file>, if <file> == '-' tags get print out to STDOUT (jscatgs style)
--version - coffeetags version
--vim-conf - print out tagbar config for vim
--include-vars - include objects/variables in generated tags
combine --vim-conf and --include-vars to create a config which adds '--include-vars' option
HELP
  }
  class Utils

    def self.option_parser args
      args = ['--version', '--help'] if args.empty?

      include_vars = ! args.delete('--include-vars').nil?
      recursive = ! args.delete('-R').nil?

      output = nil

      unless args.index( '-f').nil?
        output = args[ args.index('-f') + 1]
        args.delete '-f'
        args.delete output
        output = nil if output == '-'
      end

      to_print = [].tap do |_to_print|
        _to_print << args.delete( '--version')
        _to_print << args.delete( '--help')
      end.reject { |i| i.nil? }.map { |i| i.sub '--', ''}.map { |s| STRINGS[s] }
      ( to_print << tagbar_conf(include_vars) ) unless  args.delete('--vim-conf').nil?

      to_print.each {  |str| puts str  }

      args += Dir['./**/*.coffee', './**/Cakefile'] if recursive
      [output, include_vars, args] unless args.empty?
    end


    def self.run output, include_vars,  files
      __out = if output.nil?
                STDOUT
              else
                File.open output, 'w'
              end

      __out  << Coffeetags::Formatter.header

      files.reject { |f| f =~ /^-/}.each do |file|
        sc = File.read file
        parser = Coffeetags::Parser.new sc, include_vars
        parser.execute!

        formatter = Coffeetags::Formatter.new file, parser.tree

        formatter.parse_tree

        __out << formatter.tags
      end
      __out.close if __out.respond_to? :close
    end

    def self.tagbar_conf include_vars
      <<-CONF
" Add this type definition to your vimrc
" or do
" coffeetags --vim-conf >> <PATH TO YOUR VIMRC>
" if you want your tags to include vars/objects do:
" coffeetags --vim-conf --include-vars
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
  \\ 'ctagsargs' : '#{include_vars ?   "--include-vars" : "" } ',
  \\}
  CONF
    end
  end
end
