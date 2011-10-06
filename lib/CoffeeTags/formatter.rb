module Coffeetags
  class Formatter
    @@header = []

    def initialize  file, tree =[]
      @file = file
      @tree = tree


      @types = {
        'f' => 'type:function',
        'c' => 'type:class',
        'o' => 'type:object',
        'v' => 'type:var'
      }
    end

    def regex_line line
      "/^#{line.gsub('/', '\/')}$/;\""
      "/^#{Regexp.escape line}$/;\""
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
        line_to_string content  unless content[:line].nil? or content[:name].blank?
      end.reject{|l| l.nil? }
    end


    def tags
      @lines.map { |l| "#{l}\n"}
    end

    def to_file
      self.header +  tags
    end

    def self.header

      header = [
      "!_TAG_FILE_FORMAT	2	/extended format/",
      "!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/",
      "!_TAG_PROGRAM_AUTHOR	#{Coffeetags::AUTHOR}",
      "!_TAG_PROGRAM_NAME	#{Coffeetags::NAME}	//",
      "!_TAG_PROGRAM_URL	#{Coffeetags::URL}	/GitHub repository/",
      "!_TAG_PROGRAM_VERSION	#{Coffeetags::VERSION}	//"
    ].map { |h| "#{h}\n"}
    end
  end
end
