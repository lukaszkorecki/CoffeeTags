require 'spec_helper'
include Coffeetags
describe Utils do
  context 'Argument parsing' do
    it "returns nil when nothing is passed" do
      expect {
      Utils.option_parser( [])
      }.to raise_error SystemExit

    end

    it "returns files list" do
      Utils.option_parser(['lol.coffee']).should == {:files => ['lol.coffee']}
    end

    it "parses --include-vars option" do
      Utils.option_parser( [ '--include-vars',  'lol.coffee']).should == {:include_vars => true, :files => ["lol.coffee"]}
    end

    it "parses -f <file> option" do
      Utils.option_parser( [ '-f','tags' ,'lol.coffee']).should == { :output => 'tags', :files => ['lol.coffee'] }
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
      @fake_formatter.stub!(:lines).and_return %w{ tag tag2 tag3 }
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
      Utils.run({ :output => 'test.tags', :files => ['woot'] })

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

  context "Complete output" do
    it "genrates tags for given file" do
      Coffeetags::Utils.run({ :output => 'test.out', :files => 'spec/fixtures/test.coffee' })

      File.read("test.out").should == File.read("./spec/fixtures/out.test.ctags")
    end


    it "genrates tags for given files" do
      Coffeetags::Utils.run({ :output => 'test.out', :files => ['spec/fixtures/test.coffee', 'spec/fixtures/campfire.coffee'] })

      File.read("test.out").should == File.read("./spec/fixtures/out.test-two.ctags")
    end

    after :each do
      `rm test.out`
    end
  end

end
