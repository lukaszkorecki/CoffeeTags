# encoding: utf-8
require "CoffeeTags/version"
require "CoffeeTags/parser"
require "CoffeeTags/formatter"
require 'optparse'
require 'erb'

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

  class Utils
    def self.tagbar_conf include_vars
      include_vars_opt = include_vars ? "--include-vars" : ''

      tmpl_file = File.read(File.expand_path("../../vim/tagbar-coffee.vim.erb", __FILE__))
      tmpl = ERB.new(tmpl_file)

      tmpl.result(binding)
    end

    def self.option_parser args
      args << '-h' if args.empty?
      options = {}
      optparse = OptionParser.new do |opts|
        opts.banner  = (<<-BAN
          ---------------------------------------------------------------------
          #{NAME} #{Coffeetags::VERSION}
          ---------------------------------------------------------------------
          by #{AUTHOR} ( #{URL} )
          Usage:
          coffeetags [OPTIONS] <list of files>

          CoffeeTags + TagBar + Vim ---> https://gist.github.com/1935512
          ---------------------------------------------------------------------
          BAN
                       ).gsub(/^\s*/,'')


        opts.on('--include-vars', "Include variables in generated tags") do |o|
          options[:include_vars] = true
        end

        opts.on('-f', '--file FILE', 'Write tags to FILE (use - for std out)') do |o|
          options[:output] = o unless o == '-'

        end

        opts.on('-R', '--recursive', 'Process current directory recursively') do |o|
          options[:recur] = true
        end

        opts.on('--vim-conf', 'Generate TagBar config (more info https://gist.github.com/1935512 )') do
          puts tagbar_conf options[:include_vars]
          exit
        end

        opts.on('-v', '--version', 'Current version') do
          puts Coffeetags::VERSION
          exit
        end

        opts.on('-h','--help','HALP') do
          puts opts
          exit
        end

      end

      optparse.parse! args

      options[:files]  = args.to_a
      options[:files] += Dir['./**/*.coffee', './**/Cakefile'] if options[:recur]

      [
        options[:output],
        options[:include_vars],
        options[:files]
      ]

    end


    def self.run output, include_vars,  files
      __out = if output.nil?
                STDOUT
              else
                File.open output, 'w'
              end

      __out  << Coffeetags::Formatter.header

      files = [ files] if files.is_a? String

      files.reject { |f| f =~ /^-/}.each do |file|
        sc = File.read file
        parser = Coffeetags::Parser.new sc, include_vars
        parser.execute!

        formatter = Coffeetags::Formatter.new file, parser.tree

        formatter.parse_tree

        __out << formatter.tags
      end
      __out.close if __out.respond_to? :close

      __out.join("\n") if __out.is_a? Array
    end

  end
end
