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

  describe "#allowed?" do
    context "with 1 'allow' rule, each, for cp and mv commands" do
      before(:each) do
        @cp = mock(:cp_rule)
        @mv = mock(:mv_rule)
        @cp.should_receive(:match?).once.and_return([false, false])
        @rules = [@cp, @mv]
        cmd_text = 'mv /foo/bar /baz/bar'
        @command = SSH::Allow::Command.new(cmd_text)
      end

      context "when the mv command matches" do
        before(:each) do
          @mv.should_receive(:match?).once.and_return([true, true])
        end

        it "returns true" do
          @command.should be_allowed(@rules)
        end
      end

      context "when the mv command doesn't match" do
        before(:each) do
          @mv.should_receive(:match?).once.and_return([false, false])
        end

        it "returns false" do
          @command.should_not be_allowed(@rules)
        end
      end
    end
  end

end
