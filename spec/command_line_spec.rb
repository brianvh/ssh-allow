require 'spec_helper'

describe "The CommandLine parser" do
  before(:each) do
    @parser = CommandLineParser.new
  end

  context "with only the command" do
    before(:each) do
      @cmd = '/bin/ls'
    end

    context "when not quoted" do
      before(:each) do
        @parsed_cmd = @parser.parse(@cmd)
      end

      it "parses the command" do
        @parsed_cmd.name.text_value.should == @cmd
      end
    end

    context "when quoted" do
      before(:each) do
        @parsed_cmd = @parser.parse("\"#{@cmd}\"")
      end

      it "parses the quoted command" do
        @parsed_cmd.text_value.should == "\"#{@cmd}\""
      end
    end
  end

  context "with options" do
    before(:each) do
      @cmd = 'ls'
      @opts = []
    end

    context "one short" do
      before(:each) do
        @opts << '-l'
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['l']
      end
    end

    context "one long" do
      before(:each) do
        @opts << '--long'
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['long']
      end
    end

    context "one long and one short" do
      before(:each) do
        @opts = ['--long', '-a']
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['long', 'a']
      end
    end

    context "one short w/argument" do
      before(:each) do
        @opts << '-l=foo/bar'
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['l']
      end

      it "parses the list of arguments" do
        @parsed_cmd.argument_list.should == ['foo/bar']
      end
    end

    context "one long w/argument" do
      before(:each) do
        @opts << '--long=foo/bar'
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['long']
      end

      it "parses the list of arguments" do
        @parsed_cmd.argument_list.should == ['foo/bar']
      end
    end

    context "one long and one short w/arguments" do
      before(:each) do
        @opts = ['--long=foo', '-a=bar']
        @parsed_cmd = @parser.parse("#{@cmd} #{@opts.join(' ')}")
      end

      it "parses the list of options" do
        @parsed_cmd.option_list.should == ['long', 'a']
      end

      it "parses the list of arguments" do
        @parsed_cmd.argument_list.should == ['foo', 'bar']
      end
    end
  end

  context "with just arguments" do
    before(:each) do
      @cmd = 'cp'
      @args = []
    end

    context "one argument" do
      before(:each) do
        @args << 'foo'
        @parsed_cmd = @parser.parse("#{@cmd} #{@args.join(' ')}")
      end

      it "parses the list of arguments" do
        @parsed_cmd.argument_list.should == @args
      end
    end
  end

end
