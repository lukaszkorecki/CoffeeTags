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

      @types = {
        'f' => 'type:function',
        'c' => 'type:class',
        'v' => 'type:var'
      }
    end

    def regex_line line
      "/^#{line}$/;\""
    end

    def line_to_string entry
      namespace = (entry[:parent].blank?) ? entry[:name]: entry[:parent]
      namespace =  namespace == entry[:name] ? '' : "object:#{namespace}"

      [
        entry[:name],
        @file,
        regex_line(entry[:source]),
        entry[:kind],
        "lineno:#{entry[:line]}",
        namespace,
        @types[entry[:kind]]
      ].join("\t")
    end

    def parse_tree
      @lines = @tree.map do | content|
        line_to_string content if content[:kind] == 'f'
      end.reject{|l| l.nil? }
    end

    def header
      str = ""
      @header.each do |header|
        str << header
        str << "\n"
      end
    end

    def tags

      @lines.each do |line|
        str << line
        str << "\n"
      end

      str
    end

    def to_file
      header + "\n" + tags
    end
  end
end
