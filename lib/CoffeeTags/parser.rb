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


    def get_item line_number, line

    end

    def execute!
      line_n = 0
      level = 0
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

            @scope << { :name => klass[1], :level => (line_level line)}

            add_to_tree scope, c
          end

          if meth = line.match(@function_regex)
            m = {
              :parent => scope,
              :name => meth[1],
              :line => line_n,
              :kind => 'f'
            }
            @functions << meth[1]

            add_to_tree scope, m
          end
=begin
          if var = line.match(@var_regex)
            parent = unless @functions.empty? or scope.blank?
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

            add_to_tree scope, v unless var[1].blank?
          end
=end
        end
      end
    end
  end
end
