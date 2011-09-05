module Coffeetags
  class Formatter
    def initialize tree
      @tree = tree || []
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
    end
  end
end
