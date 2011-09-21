require 'yaml'
module Coffeetags
  class Parser
    attr_reader :tree, :scope
    def initialize source

      @source = source

      # tree maps the ... tree :-)
      @tree = []

      @functions = []

      @scope = []
      @tokens = []
      # regexes
      @class_regex = /class\s*(\w*)/
      @function_regex = /^[ \t]*([A-Za-z]+)[ \t]*[=:].*->.*$/
      @var_regex = /([a-zA-Z0-9_]*)[ \t]*[=]/


      @token_regex = /[ \t]*([a-zA-Z0-9_]*)[ \t]*[:=]/
    end


    def add_to_tree scope, item
      sc = scope.blank? ?   '__top__' : scope
      @tree[sc] ||= []
      @tree[sc] << item
    end

    def line_level line
      line.match(/^[ \t]*/)[0].gsub("\t", " ").split('').length
    end

    def scope_path _el = nil, _tree = nil
      bf = []
      tree = (_tree || @tree)
      element = (_el || tree.last)
      idx = tree.index(element) || -1

      current_level = element[:level]
      tree[0..idx].reverse.each do |_el|
        if _el[:level] != current_level and _el[:level] < current_level
          bf << _el[:name]
          current_level = _el[:level]
        end
      end
      bf.uniq.reverse.join('.')

    end

    def execute!
      line_n = 0
      level = 0
      sc = '__top__'
      # indentify scopes
      @source.each_line do |line|
        line_n += 1
        level = line_level line

        token = line.match @token_regex
        if not token.nil? and line =~ /-\>/
          o = {
              :name => token[1],
              :level => level,
              :parent => '',
              :source => line.chomp,
              :kind => 'f',
              :line => line_n
          }
          o[:parent] =  scope_path o
          @tree << o
        end
        @tree.uniq!
      end
    end
  end
end
