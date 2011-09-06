require './lib/CoffeeTags'
describe 'CoffeeTags::Parser' do
  before :all do
    @campfire_class = File.read File.expand_path('./spec/fixtures/campfire.coffee')
  end

  it "should work" do
    lambda { Coffeetags::Parser.new "\n" }.should_not raise_exception
  end

  it "loads the source and parses it" do
    inst = Coffeetags::Parser.new @campfire_class
    inst.execute!

    inst.tree.length.should == 2
  end

  context 'parsing' do
    before :each do
      @instance = Coffeetags::Parser.new @campfire_class
      @instance.execute!
    end

    it "extracts the classes" do
      @instance.tree.keys.should == ['Campfire', 'Test']
    end

    it "extracts the functions and methods for CampfireClass" do
      @instance.tree['Campfire'].map { |m| m[:name]}.should == [
        'Campfire',
        'constructor',
        'handlers',
        'onSuccess',
        'onFailure',
        'rooms',
        'roomInfo',
        'recent',
      ]
    end

    it 'extracts the line numbers for each method' do
      @instance.tree['Campfire'].map { |m| m[:line]}.should == [
        3, 7, 13, 15, 23, 28, 33, 39
      ]

    end

    it "generates the tree for file" do
      @instance.tree.should == {
        'Campfire' => [
          {:parent => '', :name => 'Campfire', :line => 3, :kind => 'c'},
          {:parent => 'Campfire', :name => 'constructor', :line => 7, :kind => 'f'},
          {:parent => 'Campfire', :name => 'handlers', :line => 13 , :kind => 'f'},
          { :parent => 'Campfire', :name => 'onSuccess', :line => 15, :kind => 'f'},
          { :parent => 'Campfire', :name => 'onFailure', :line => 23, :kind => 'f'},
          {:parent => 'Campfire', :name => 'rooms', :line => 28, :kind => 'f'},
          {:parent => 'Campfire', :name => 'roomInfo', :line => 33, :kind => 'f'},
          {:parent => 'Campfire', :name => 'recent', :line => 39, :kind => 'f'},
        ],
        'Test' => [
          {:parent => '', :name => 'Test', :line => 44, :kind => 'c'},
          { :parent => 'Test', :name => 'bump' , :line => 45, :kind => 'f'}
        ]
      }
    end
  end
end
