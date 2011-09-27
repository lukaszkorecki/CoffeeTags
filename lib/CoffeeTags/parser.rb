require 'yaml'
module Coffeetags
  class Parser
    attr_reader :tree
    def initialize source
      @source = source

      @fake_parent = 'window'

      # tree maps the ... tree :-)
      @tree = []

      # regexes
      @class_regex = /^[ \t]*class\s*(\w*)/
      @proto_meths = /^[ \t]*([A-Za-z]*)::([@a-zA-Z0-9_]*)/
      @var_regex = /([@a-zA-Z0-9_]*)[ \t]*[=:]{1}[ \t]*$/
      @token_regex = /([@a-zA-Z0-9_]*)[ \t]*[:=]{1}/
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
        # uhmmmmmm
        if _el[:level] != current_level and _el[:level] < current_level
          bf << _el[:name]
          current_level = _el[:level]
        end
      end
      bf.uniq.reverse.join('.')

    end

    def execute!
      @source.map { |line| line.gsub('[', '\[').gsub(']', '\]') }
      line_n = 0
      level = 0
      # indentify scopes
      @source.each_line do |line|
        line_n += 1
        level = line_level line

        if (_class = line.match @class_regex)
          @tree << { :name => _class[1], :level => level }
        end

        if(_proto  = line.match @proto_meths)
          @tree << { :name => _proto[1], :level => level }
        end

        if(var = line.match @var_regex)
          @tree << { :name => var[1], :level => level }
        end

        token = line.match @token_regex
        if not token.nil?
          o = {
              :name => token[1],
              :level => level,
              :parent => '',
              :source => line.chomp,
              :line => line_n
          }

          o[:kind] =  line =~ /[:=]{1}.*-\>/ ? 'f' : 'o'
          o[:parent] =  scope_path o
          o[:parent] = @fake_parent if o[:parent].empty?
          @tree << o if line !~ /::|==/ # remove edge cases for now
        end
        @tree.uniq!
      end
    end
  end
end
