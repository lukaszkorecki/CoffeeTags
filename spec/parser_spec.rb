require './lib/CoffeeTags'
describe 'CoffeeTags::Parser' do
  before :all do
    @campfire_class = File.read File.expand_path('./spec/fixtures/campfire.coffee')
    @test_file = File.read File.expand_path('./spec/fixtures/test.coffee')
    @test_tree = YAML::load_file File.expand_path('./spec/fixtures/test_tree.yaml')
    @cf_tree = YAML::load_file File.expand_path('./spec/fixtures/tree.yaml')

  end

  it "should work" do
    lambda { Coffeetags::Parser.new "\n" }.should_not raise_exception
  end


  context 'detect item level' do
    before :each do
      @parser = Coffeetags::Parser.new ''
    end

    it 'gets level from a string with no indent' do
      @parser.line_level("zooo").should == 0
    end

    it "gets level from spaces" do
      @parser.line_level("    def lol").should == 4
    end

    it "gets level from tabs" do
      @parser.line_level("\t\t\tdef lol").should == 3
    end
  end


  context "Creating scope path" do
    before(:each) do
      @parser = Coffeetags::Parser.new ''
    end
    it 'gets the scope path for first function' do
      @parser.scope_path(@cf_tree[1], @cf_tree[0...1] ).should == 'Campfire'
    end

    it 'gets the scope path for second function' do
      @parser.scope_path(@cf_tree[2], @cf_tree[0..1] ).should == 'Campfire'
    end

    it "gets the scope for nested function" do
      @parser.scope_path(@cf_tree[4], @cf_tree[0..3]).should == 'Campfire.handlers.resp'
    end

    it "gets the scope of a function which comes after nested function" do

      @parser.scope_path(@cf_tree[6], @cf_tree[0..5]).should == 'Campfire'
    end

    it 'gets scope for last method defined in diff class' do
      @parser.scope_path(@cf_tree.last, @cf_tree).should == 'Test'
    end
  end

  context 'Parsing' do
    context 'Scoping' do
      before(:each) do
        @coffee_parser = Coffeetags::Parser.new @campfire_class
        @test_parser = Coffeetags::Parser.new @test_file
      end

      it "generates the scope list" do
        @coffee_parser.execute!
        @coffee_parser.tree.should == @cf_tree
      end
    end
  end
end
