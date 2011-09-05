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
      @type_str = 'type:void function(any)'

      # array:
      # name
      # file path
      # line number
      # scope

      @template = "%s\t%s\t//;\"\tf\tlineno:%s\tnamespace:%s\t#{@type_str}"

    end

    def parse_tree
      @lines = [].tap do |line|
        @tree.each do |klass, content|
          content.each do |entry|
            line << sprintf(
              @template,
              entry[:name],
              @file,
              entry[:line],
              "#{entry[:parent]}.#{entry[:name]}"
            )
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
