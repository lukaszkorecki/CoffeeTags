require "CoffeeTags/version"

module Coffeetags
  class << self
    def run

      fail "no files" if ARGV.empty?
      ARGV.each do |file|
        puts emit parse File.read file
      end

    end

    def parse content
    end


    def emit source
    end
  end
end
