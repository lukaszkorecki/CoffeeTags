require './lib/CoffeeTags'
require 'yaml'

file = './spec/fixtures/campfire.coffee'

sc = File.read file

parser = Coffeetags::Parser.new sc
parser.execute!
y parser.tree

formatter = Coffeetags::Formatter.new file, parser.tree

formatter.parse_tree

puts formatter.to_file
