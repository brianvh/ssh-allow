require 'spec_helper'
require 'ssh/allow/configuration'

describe SSH::Allow::Configuration do
  before(:each) do
    @config = SSH::Allow::Configuration.new
  end

  context "when instantiated" do
    it "is valid" do
      @config.should be_valid
    end

    it "has an empty rules array" do
      @config.rules.should be_empty
    end
  end

  context "after adding a valid rule" do
    before(:each) do
      @rule = mock(:valid)
      @config.should_receive(:parse_command).once.and_return(@rule)
      @config.allow(:rule)
    end

    it "has 1 rule" do
      @config.rules.should have(1).items
    end

    it "contains the correct rule in the rules array" do
      @config.rules.should == [@rule]
    end

    context "after resetting" do
      before(:each) do
        @config.reset!
      end

      it "has 0 rules" do
        @config.rules.should have(0).items
      end
    end
  end
end
