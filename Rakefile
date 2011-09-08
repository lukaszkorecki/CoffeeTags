desc 'uninstall CoffeeTags'
task :uninstall  do
  STDOUT << `gem uninstall CoffeeTags`
end

desc 'install from generated gem'
task :install do
  STDOUT << `gem install CoffeeTags*.gem`
end

desc 'build CoffeeTags.gem'
task :build do
  STDOUT << `gem build CoffeeTags.gemspec`
end


desc 'build and install CoffeeTags'
task :test_install do
  Rake::Task['uninstall'].execute
  Rake::Task['build'].execute
  Rake::Task['install'].execute
end
