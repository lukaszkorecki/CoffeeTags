require 'lib/CoffeeTags'
include Coffeetags
describe Utils do
  context 'Argument parsing' do
    it "returns nil when nothing is passed" do
      Utils.option_parser( []).should == nil
    end

    it "returns files list" do
      Utils.option_parser( [ 'lol.coffee']).should == [ nil, false,  ['lol.coffee']]
    end

    it "parses --include-vars option" do
      Utils.option_parser( [ '--include-vars',  'lol.coffee']).should == [ nil, true,  ['lol.coffee']]
    end

    it "parses -f <file> option" do
      Utils.option_parser( [ '-f','tags' ,'lol.coffee']).should == [ 'tags', false,  ['lol.coffee']]
    end

  end

  context 'Parser runner' do
    before do
      @fake_parser = mock('Parser')
      @fake_parser.stub! :"execute!"
      @fake_parser.stub!( :tree).and_return []

      Parser.stub!(:new).and_return @fake_parser

      @fake_formatter = mock 'Formatter'
      @fake_formatter.stub! :parse_tree
      @fake_formatter.stub!(:tags).and_return <<-TAG
tag
tag2
tag3
      TAG
      Coffeetags::Formatter.stub!(:new).and_return @fake_formatter
      Coffeetags::Formatter.stub!(:header).and_return "header\n"

      File.stub!(:read).and_return 'woot@'

    end


    it "opens the file and writes tags to it" do
      Utils.run 'test.tags', false, ['woot']
      `cat test.tags`.should== <<-FF
header
tag
tag2
tag3
FF

    end
    after :each do
      `rm test.tags`
    end

  end

end
