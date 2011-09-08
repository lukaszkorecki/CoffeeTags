module Coffeetags
  class Formatter
    def initialize  file, tree =[]
      @file = file
      @tree = tree

      @header = [
        "!_TAG_FILE_FORMAT	2	/extended format/",
        "!_TAG_FILE_SORTED	0	/0=unsorted, 1=sorted, 2=foldcase/",
        "!_TAG_PROGRAM_AUTHOR	#{Coffeetags::AUTHOR}",
        "!_TAG_PROGRAM_NAME	#{Coffeetags::NAME}	//",
        "!_TAG_PROGRAM_URL	#{Coffeetags::URL}	/GitHub repository/",
        "!_TAG_PROGRAM_VERSION	#{Coffeetags::VERSION}	//"
      ]

      # for now
      @types = {
        'f' => 'type:function',
        'c' => 'type:class',
        'v' => 'type:var'
      }


    end

    def line_to_string entry

      namespace = (entry[:parent].blank?) ? entry[:name]: entry[:parent]
      namespace = "namespace:#{namespace}"

      [
        entry[:name],
        @file,
        '//;"',
        entry[:kind],
        "lineno:#{entry[:line]}",
        namespace,
        @types[entry[:kind]]
      ].join("\t")
    end

    def parse_tree
      @lines = [].tap do |line|
        @tree.each do |klass, content|
          content.each do |entry|
            line << line_to_string(entry)
          end
        end
      end
    end

    def to_file
      str = ""
      @header.each do |header|
        str << header
        str << "\n"
      end

      @lines.each do |line|
        str << line
        str << "\n"
      end

      str
    end
  end
end
