require "CoffeeTags/version"
require 'CoffeeTags/parser'
require 'CoffeeTags/formatter'

module Coffeetags
  class << self
    def run files

      fail "no files" if files.empty?
      files.map do |file|
        emit parse File.read file
      end

    end

    def parse content
      Parser.new(content).execute
    end


    def emit source
    end
  end
end
