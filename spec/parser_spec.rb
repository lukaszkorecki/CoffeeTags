require './lib/CoffeeTags'
describe 'CoffeeTags::Parser' do
  before :all do
    @campfire_class = File.read File.expand_path('./spec/fixtures/campfire.coffee')
    @class_with_dot = File.read File.expand_path('./spec/fixtures/class_with_dot.coffee')
    @test_file = File.read File.expand_path('./spec/fixtures/test.coffee')

    @cf_tree = YAML::load_file File.expand_path('./spec/fixtures/tree.yaml')
    @test_tree = YAML::load_file File.expand_path('./spec/fixtures/test_tree.yaml')

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
    it 'gets the scope path for function' do
      @parser.scope_path(@cf_tree[1], @cf_tree[0...1] ).should == 'Campfire'
    end

    it 'gets the scope path for second function' do
      @parser.scope_path(@cf_tree[3], @cf_tree[0..2] ).should == 'Campfire'
    end

    it "gets the scope for nested function" do
      @parser.scope_path(@cf_tree[5], @cf_tree[0..4]).should == 'Campfire.handlers.resp'
    end

    it "gets the scope of a function which comes after nested function" do
      @parser.scope_path(@cf_tree[7], @cf_tree[0..6]).should == 'Campfire'
    end

    it 'gets scope for last method defined in diff class' do
      @parser.scope_path(@cf_tree.last, @cf_tree).should == 'Test'
    end
  end

  context 'Parsing' do
    context 'Scoping' do
      before(:each) do
        @coffee_parser = Coffeetags::Parser.new @campfire_class, true
        @test_parser = Coffeetags::Parser.new @test_file, true
        @coffee_parser.execute!
      end

      it "parses the class" do
        c =@coffee_parser.tree.find { |i| i[:name] == 'Campfire'}
        c.should == @cf_tree.find {|i| i[:name] == 'Campfire'}
      end

      it "parses the 2nd class" do
        c =@coffee_parser.tree.find { |i| i[:name] == 'Test'}
        c.should == @cf_tree.find {|i| i[:name] == 'Test'}
      end

      it "parses the class with dot in name" do
        @coffee_parser = Coffeetags::Parser.new @class_with_dot, true
        @coffee_parser.execute!

        c = @coffee_parser.tree.find { |i| i[:name] == 'App.Campfire'}
        c.should == @cf_tree.find {|i| i[:name] == 'App.Campfire'}
      end

      it "parses the instance variable" do
        c =@coffee_parser.tree.find { |i| i[:name] == '@url'}
        c.should == @cf_tree.find {|i| i[:name] == '@url'}
      end

      it "parses the object literal with functions" do
        c =@coffee_parser.tree.find { |i| i[:name] == 'resp'}
        c.should == @cf_tree.find {|i| i[:name] == 'resp'}
      end

      it "parses a nested function" do
        c =@coffee_parser.tree.find { |i| i[:name] == 'onSuccess'}
        c.should == @cf_tree.find {|i| i[:name] == 'onSuccess'}
      end

      it "parses a method var" do
        c =@coffee_parser.tree.find { |i| i[:name] == 'url'}
        c.should == @cf_tree.find {|i| i[:name] == 'url'}
      end
    end
  end

  context 'Test.coffee parsing' do
    before(:each) do
      @parser_test = Coffeetags::Parser.new @test_file, true
      @parser_test.execute!
    end

    it "doesnt extract a variable from a tricky line" do
      @parser_test.tree.find { |i| i[:name] == 'Filter'}.should == nil
    end

    it 'correctly recognizes an object in if block' do
      pro = @parser_test.tree.find { |i| i[:name] == 'fu'}
      pro[:parent].should == '_loop'

      pro = @parser_test.tree.find { |i| i[:name] == 'nice'}
      pro[:parent].should == '_loop'
    end

    it 'correctly recognizes an object in for block' do
      pro = @parser_test.tree.find { |i| i[:name] == 'ugh'}
      pro[:parent].should == '_loop.element'

    end
      it "detects a fat arrow function" do
        c =@parser_test.tree.find { |i| i[:name] == 'bound_func'}
        c.should == @test_tree.find {|i| i[:name] == 'bound_func'}

      end

    it "extracts a method defined in a prototype" do
      pending 'methods defined on prototype needs implementing'
      pro = @parser_test.tree.find { |i| i[:name] == '_loop'}
      exp = @test_tree.find { |i| i[:name] == '_loop'}
      pro.should_not be nil
      pro.should == exp
    end

    context 'for loop' do
      subject {
        @parser_test = Coffeetags::Parser.new @test_file, true
        @parser_test.execute!
        @parser_test.tree.find { |i| i[:name] == 'element'}
      }
      it "finds variables defined in for loop" do
        subject[:line].should == 28
      end

      it "extracts the name" do
        subject[:name].should == 'element'
      end

      it "detects the scope" do

        subject[:parent].should == '_loop'
      end
    end
  end
end
