require './lib/CoffeeTags'

describe 'CoffeeTags::Formatter' do
  before :each do
    @tree = YAML::load_file './spec/fixtures/tree.yaml'
  end

  it "works!" do
    lambda { Coffeetags::Formatter.new 'lol.coffee' }.should_not raise_exception
  end

  before :each do
    @instance = Coffeetags::Formatter.new 'test.coffee', @tree
  end

  it "generates a line for class definition" do
    exp = 'Campfire	test.coffee	//;"	c	lineno:3	namespace:Campfire	type:class'
    @instance.parse_tree.first.should == exp
  end

  it "generates a line for method definition" do
    exp = 'constructor	test.coffee	//;"	f	lineno:7	namespace:Campfire	type:function'
    @instance.parse_tree[1].should == exp
  end

  it "generates line for second class" do
    exp = 'bump	test.coffee	//;"	f	lineno:45	namespace:Test	type:function'
    @instance.parse_tree.last.should == exp
  end
end
