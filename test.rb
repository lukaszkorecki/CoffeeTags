require './lib/CoffeeTags'
require 'yaml'

sc = File.read './examples/campfire.coffee'

parser = Coffeetags::Parser.new sc

parser.execute!

y parser.tree
