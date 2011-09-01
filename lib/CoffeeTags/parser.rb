module Coffeetags
  class Parser
    def initialize source
      @source = source

      # all bits and pieces are hashes
      # {
      # name, parent, line, args list
      # }
      @classes = []

      # methods can be bound to a class, object or
      # window (that means they're funcitons)
      @methods = []

      # tree maps the ... tree :-)
      @tree = {}

      # regexes
      @class_regex = /(class) \w*/
      @function_regex = /^[ \t]*([A-Za-z]+)[ \t]*=.*->.*$/
    end


    def execute
      line = 0
      scope = ''
      @source.each_line do |line|
        line += 1
        if  klass = line.match(@class_regex)
          @classes << {
            :name => klass[1],
            :line => line
          }
          scope = klass[1]

          @tree[scope] = []
        end

        if meth = line.match(@function_regex)
          @methods << {
            :name => meth[1], :line => line, :parent => scope
          }
          @tree[scope] << meth[1] if scope != ''
        end
      end
    end
  end
end
