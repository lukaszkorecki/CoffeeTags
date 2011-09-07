require 'yaml'
module Coffeetags
  class Parser
    attr_reader :tree, :methods, :classes
    def initialize source

      @source = source

      # tree maps the ... tree :-)
      @tree = {}

      @functions = []

      # regexes
      @class_regex = /class\s*(\w*)/
      @function_regex = /^[ \t]*([A-Za-z]+)[ \t]*[=:].*->.*$/
      @var_regex = /([a-zA-Z0-9_]*)[ \t]*[=]/
    end

    def current_scope scope
      s = (scope.nil? or scope.empty?) ?   '__top__' : scope
      puts s
      s
    end

    def execute!
      line_n = 0
      scope = ''
      @source.each_line do |line|
        line_n += 1
        unless line =~ /^#/
          if  klass = line.match(@class_regex)
            c = {
              :parent => '',
              :name => klass[1],
              :line => line_n,
              :kind => 'c'
            }
            scope = klass[1]

            @tree[current_scope scope] ||= []
            @tree[current_scope scope] << c
          end


          if meth = line.match(@function_regex)
            m = {
              :parent => scope,
              :name => meth[1],
              :line => line_n,
              :kind => 'f'
            }
            @functions << meth[1]
            @tree[current_scope scope] ||= []
            @tree[current_scope scope] << m
          end

          if var = line.match(@var_regex)
            parent = unless @functions.empty?
                       "#{scope}.#{@functions.last}"
                     else
                       scope
                     end
            v = {
              :parent => parent,
              :name => var[1],
              :line => line_n,
              :kind => 'v'
            }


            @tree[current_scope scope] ||= []
            @tree[current_scope scope] << v unless var[1].nil? or var[1].empty?

          end
        end
      end
    end
  end
end
