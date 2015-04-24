module Coffeetags
  class Parser
    attr_reader :tree
    # Creates a new parser
    #
    # @param [String] source source of the CoffeeScript file
    # @param [Bool] include_vars include objects in generated tree (default false)
    # @return [Coffeetags::Parser]
    def initialize source, include_vars = false
      @include_vars = include_vars
      @source = source

      @fake_parent = 'window'

      # tree maps the ... tree :-)
      @tree = []

      # regexes
      @block = /^\s*(if\s+|unless\s+|switch\s+|loop\s+|do\s+|for\s+)/
      @class_regex = /\s*class\s+(?:@)?([\w\.]*)/
      @func_regex = /^\s*(?<name>[a-zA-Z0-9_]+)\s?[=:]\s?(?<params>\([@a-zA-Z0-9_]*\))?\s?[=-]>/
      @proto_meths = /^\s*(?<parent>[A-Za-z]+)::(?<name>[@a-zA-Z0-9_]*)/
      @var_regex = /([@a-zA-Z0-9_]+)\s*[:=]\s*[^-=]*$/
      @token_regex = /([@a-zA-Z0-9_]+)\s*[:=]/
      #@iterator_regex = /^\s*for\s+([a-zA-Z0-9_]*)\s*/ # for in/of
      @iterator_regex = /^\s*for\s+(?<name>[a-zA-Z0-9_]+)\s+(in|of)(?<parent>.)*/ # use named captures too specify parent variable in iterator
      @comment_regex = /^\s*#/
      @start_block_comment_regex = /^\s*###/
      @end_block_comment_regex = /^.*###/
      @oneline_block_comment_regex = /^\s*###.*###/
      @comment_lines = mark_commented_lines
    end

    # Mark line numbers as commented out
    # either by single line comment (#)
    # or block comments (###~###)
    def mark_commented_lines
      [].tap do |reg|
        in_block_comment = false
        line_no = 0
        start_block = 0
        end_block = 0
        @source.each_line do |line|
          line_no = line_no+1

          start_block = line_no if !in_block_comment and line =~ @start_block_comment_regex
          end_block = line_no if start_block < line_no and line =~ @end_block_comment_regex
          end_block = line_no if line =~ @oneline_block_comment_regex

          in_block_comment = end_block < start_block

          reg << line_no if in_block_comment or end_block == line_no or line =~ @comment_regex
        end
      end
    end

    # Detect current line level based on indentation
    # very useful in parsing, since CoffeeScript's syntax
    # depends on whitespace
    # @param [String] line currently parsed line
    # @return  [Integer]
    def line_level line
      line.match(/^[ \t]*/)[0].gsub("\t", " ").split('').length
    end

    # Generate current scope path, for example:
    #   e  ->
    #     f ->
    #       z ->
    # Scope path for function z would be:
    # window.e.f
    # @param [Hash, nil] _el element of a prase tree (last one for given tree is used by default)
    # @param [Array, nil] _tree parse tree (or currently built)
    # @returns [String] string representation of scope for given element
    def scope_path _el = nil, _tree = nil
      bf = []
      tree = (_tree || @tree)
      element = (_el || tree.last)
      idx = tree.index(element) || -1

      current_level = element[:level]
      tree[0..idx].reverse.each_with_index do |item, index|
        # uhmmmmmm
        if item[:level] < current_level
          if item[:kind] == 'b'
            true
          elsif
            bf << item[:name]
          end
          current_level = item[:level]
        end
      end
      sp = bf.uniq.reverse.join('.')
      sp
    end

    # Helper function for generating parse tree elements for given
    # line and regular expression
    #
    # @param [String] line source line currently being parsed
    # @param [RegExp] regex regular expression for matching a syntax element
    # @param [Integer] level current indentation/line level
    # @param [Hash, {}] additional_fields additional fields which need to be added to generated element
    # @returns [Hash,nil] returns a parse tree element consiting of:
    #   :name of the element
    #   indentation :level of the element
    def item_for_regex line, regex, level, additional_fields={}
      if item = line.match(regex)
        entry_for_item = {
          :level => level
        }
        if item.length > 2 # proto method or func
          if regex == @proto_meths
            entry_for_item[:parent] = item[1]
            entry_for_item[:name] = item[2]
          elsif regex == @func_regex
            entry_for_item[:name] = item[1]
            #entry_for_item[:params] = item[2] # TODO: when formatting, show params in name ?
          end
        else
          entry_for_item[:name] = item[1]
        end
        entry_for_item.merge(additional_fields)
      end
    end

    # Look through the tree to see if it's possible to change an entry's kind
    # Differ the objects from simple variables
    # Should execute after the whole tree has been generated
    def comb_kinds tree
      entries_with_parent = tree.reject {|c| c[:parent].nil? }
      tree.each do |c|
        next c unless c[:kind] == 'v'
        maybe_child = entries_with_parent.select {|e| e[:parent] == c[:name]}
        unless maybe_child.empty?
          c[:kind] = 'o'
        end
      end
      tree
    end

    # trim the bloated tree
    # - when not required to include_vars, reject the variables
    def trim_tree tree
      unless @include_vars
        tree = tree.reject do |c|
          ['v'].include? c[:kind]
        end
      end
      tree
    end

    # Parse the source and create a tags tree
    # @note this method mutates @tree instance variable of Coffeetags::Parser instance
    # @returns self it can be chained
    def execute!
      line_n = 0
      level = 0
      classes = []
      @source.each_line do |line|
        line_n += 1
        line.chomp!
        # indentify scopes
        level = line_level line

        # ignore comments!
        next if @comment_lines.include? line_n

        [
          [@class_regex, 'c'],
          [@proto_meths, 'p'],
          [@func_regex, 'f'],
          [@var_regex, 'v'],
          [@block, 'b']
        ].each do |regex, kind|
          mt = item_for_regex line, regex, level, :source => line, :line => line_n, :kind => kind
          unless mt.nil?
            # TODO: one token should not fit for multiple regex
            classes.push mt if kind == 'c'
            next if kind == 'f' # wait for later to determine whether it is a class method
            @tree << mt
          end
        end

        # instance variable or iterator (for/in)?
        token = line.match(@token_regex )
        token ||=  line.match(@iterator_regex)

        # we have found something!
        if not token.nil?
          # should find token through the tree first
          token_name = token[1]
          existing_token = @tree.find {|o| o[:name] == token_name}
          if existing_token
            o = existing_token
          else
            o = {
              :name => token_name,
              :level => level,
              :parent => '',
              :source => line,
              :line => line_n
            }
          end

          # Remove edge cases for now

          # - if a line containes a line like:  element.getElement('type=[checkbox]').lol()
          token_match_in_line = false
          token_match_in_line = line.match token_name
          unless token_match_in_line.nil?
            offset = token_match_in_line.offset 0
            str_before = line.slice 0, offset[0]
            str_after = line.slice offset[1], line.size
            [str_before, str_after].map do |str|
              # if there are unmatch quotes, our token is in a string
              token_match_in_line = ['"', '\''].any? { |q| str.scan(q).size % 2 == 1 }
            end
          end

          if token_match_in_line
            @tree = @tree.reject {|c| c[:name] == o[:name]}
            next
          end

          # - scope access and comparison in if x == 'lol'
          is_in_comparison = line =~ /::|==/

          # - objects with blank parent (parser bug?)
          has_blank_parent = o[:parent] =~ /\.$/

          # - multiple consecutive assignments
          is_previous_not_the_same = !(@tree.last and @tree.last[:name] == o[:name] and @tree.last[:level] == o[:level])

          if !token_match_in_line and is_in_comparison.nil? and (has_blank_parent.nil? or is_previous_not_the_same)
            unless o[:kind]
              o[:kind]   = line =~ /[:=]{1}.*[-=]\s?\>/ ? 'f' : 'v'
            end
            o[:parent] = scope_path o
            o[:parent] = @fake_parent if o[:parent].empty?

            # treat variable and function with a class as parent as property
            if ['f', 'v', 'o'].include? o[:kind]
              # TODO: process func params
              maybe_parent_class = classes.find {|c| c[:name] == o[:parent] }
              if maybe_parent_class
                o[:kind] = 'p'
              end
            end

            @tree << o unless @tree.include? o
          end
        end
      end

      @tree = comb_kinds @tree

      @tree = trim_tree @tree

      # P.S when found a token, first lookup in the tree, thus the duplicate won't appear
      # so there is no need of uniq_tree
      self # chain!
    end
  end
end
