require 'yaml'
module Coffeetags
  class Parser
    attr_reader :tree, :methods, :classes
    def initialize source

      @source = source

      # tree maps the ... tree :-)
      @tree = {}

      @functions = []

      @scope = []
      # regexes
      @class_regex = /class\s*(\w*)/
      @function_regex = /^[ \t]*([A-Za-z]+)[ \t]*[=:].*->.*$/
      @var_regex = /([a-zA-Z0-9_]*)[ \t]*[=]/
    end


    def add_to_tree scope, item
      sc = scope.blank? ?   '__top__' : scope
      @tree[sc] ||= []
      @tree[sc] << item
    end

    def line_level line
      line.match(/^[ \t]*/)[0].gsub("\t", " ").split('').length
    end

    def execute!
      line_n = 0
      level = 0
      scope = ''
      @source.each_line do |line|
        line_n += 1
        unless line =~ /^#/
          o = if  klass = line.match(@class_regex)
                c = {
                  :parent => '',
                  :name => klass[1],
                  :line => line_n,
                  :kind => 'c'
                }
                scope = klass[1]

                @scope << { :name => klass[1], :level => (line_level line)}
                c
              end

          o = if meth = line.match(@function_regex)
                m = {
                  :parent => scope,
                  :name => meth[1],
                  :line => line_n,
                  :kind => 'f',
                  :source => line.gsub("\n",'')
                }
                @functions << meth[1]

                m
              end

          add_to_tree scope, o unless o.nil?
        end
      end
    end
  end
end
