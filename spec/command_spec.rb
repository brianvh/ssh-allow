require 'spec_helper'

describe SSH::Allow::Command do

  context "for a simple command" do
    before(:each) do
      @cmd_text = 'git help'
      @command = SSH::Allow::Command.new(@cmd_text)
    end

    it "returns the correct name" do
      @command.name.should == 'git'
    end

    it "returns the array of arguments" do
      @command.arguments.should == ['help']
    end

    it "returns an empty array for options" do
      @command.options.should == []
    end
  end

  context "for a complex command" do
    before(:each) do
      @cmd_text = %(git log --since="6 months ago" Gemfile)
      @command = SSH::Allow::Command.new(@cmd_text)
    end

    it "returns the array of arguments" do
      @command.arguments.should == ['log', '"6 months ago"', 'Gemfile']
    end

    it "returns the array of options" do
      @command.options.should == ['since']
    end
  end

end
