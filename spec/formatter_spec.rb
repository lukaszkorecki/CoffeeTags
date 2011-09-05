require './lib/CoffeeTags'
describe 'CoffeeTags::Formatter' do
  it "works!" do
    lambda { Coffeetags::Formatter.new []}.should_not raise_exception
  end
end
