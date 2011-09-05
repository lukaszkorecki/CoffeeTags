guard 'rspec', :version => 2, :bundler => true, :cli => '-f n --color', :all_on_start => false     do
  watch(%r{^spec/(.*).rb$}) { |m| m[0] }
  watch(%r{^lib/(.*).rb$}) do |m|
    "spec/#{m[0].split('/').last.split('.').first}_spec.rb"
  end
end
