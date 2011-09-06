require 'yaml'
module Coffeetags
  class Parser
    attr_reader :tree, :methods, :classes
    def initialize source

      @source = source

      # tree maps the ... tree :-)
      @tree = {}

      # regexes
      @class_regex = /class\s*(\w*)/
      @function_regex = /^[ \t]*([A-Za-z]+)[ \t]*[=:].*->.*$/
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

            @tree[scope] = [] unless scope.nil? or scope.empty?
            @tree[scope] << c
          end

          if meth = line.match(@function_regex)
            m = {
              :parent => scope,
              :name => meth[1],
              :line => line_n,
              :kind => 'f'
            }
            @tree[scope] << m if scope != ''
          end
        end
      end
    end
  end
end
