require './lib/CoffeeTags'
describe 'CoffeeTags::Formatter' do
  include Coffeetags
  before :each do
    @tree = YAML::load_file './spec/fixtures/tree.yaml'
  end

  it "works!" do
    lambda { Formatter.new 'lol.coffee' }.should_not raise_exception
  end

  it "generates a ctags-formatted line for each tree entry" do

    instance = Formatter.new 'test.coffee', @tree

    exp = 'constructor	test.coffee	//;"	f	lineno:7	namespace:Campfire.constructor	type:void function(any)'
    instance.parse_tree.first.should == exp

  end

  it "generates line for second class" do
    instance = Formatter.new 'test.coffee', @tree
    exp = 'bump	test.coffee	//;"	f	lineno:45	namespace:Test.bump	type:void function(any)'
    instance.parse_tree.last.should == exp
  end
end
