# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'CoffeeTags/version'

Gem::Specification.new do |s|
  s.name        = 'CoffeeTags'
  s.version     = Coffeetags::VERSION
  s.authors     = ['Łukasz Korecki', 'Matthew Smith']
  s.email       = ['lukasz@korecki.me', 'mtscout6@gmail.com']
  s.homepage    = 'http://github.com/lukaszkorecki/CoffeeTags'
  s.summary     = 'tags generator for CoffeeScript'
  s.description = 'CoffeeTags generates ctags compatibile tags for CoffeeScript.'

  s.rubyforge_project = 'CoffeeTags'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.licenses      = ['MIT']
end
