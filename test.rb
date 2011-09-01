require './lib/CoffeeTags'

res = Coffeetags.run(ARGV).first


example = File.read 'examples/campfire.js.tags'

puts res == example
