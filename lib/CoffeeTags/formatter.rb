module Coffeetags
  class Formatter
    def self.header
      return [
        "!_TAG_FILE_FORMAT	2	/extended format/",
        "!_TAG_FILE_SORTED	0	/0=unsorted, 1=sorted, 2=foldcase/",
        "!_TAG_PROGRAM_AUTHOR	#{::Coffeetags::AUTHOR}",
        "!_TAG_PROGRAM_NAME	#{::Coffeetags::NAME}	//",
        "!_TAG_PROGRAM_URL	#{::Coffeetags::URL}	/GitHub repository/",
        "!_TAG_PROGRAM_VERSION	#{::Coffeetags::VERSION}	//"
      ].map { |h| "#{h}\n"}.join ''
    end

    def initialize  file, tree =[]
      @file = file
      @tree = tree


      @types = {
        'f' => 'type:function',
        'c' => 'type:class',
        'o' => 'type:object',
        'v' => 'type:var'
      }
      @header = Formatter.header
    end


    def regex_line line
      "/#{line}/;\""
    end

    def line_to_string entry
      namespace = (entry[:parent].blank?) ? entry[:name]: entry[:parent]
      namespace =  namespace == entry[:name] ? '' : "object:#{namespace}"

      [
        entry[:name],
        @file,
        regex_line(entry[:name]),
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
      @lines.map { |l| "#{l}\n"}.join ''
    end

  end
end
