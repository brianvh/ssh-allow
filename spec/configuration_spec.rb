require 'spec_helper'

describe SSH::Allow::Configuration do
  before(:each) do
    @config = SSH::Allow::Configuration.new
  end

  context "#new" do
    it "is valid" do
      @config.should be_valid
    end

    it "has an empty rules array" do
      @config.rules.should be_empty
    end
  end

  context "#allow -- on a valid rule" do
    before(:each) do
      @rule = mock_rule(:invalid)
      @config.should_receive(:parse_command).once.and_return(@rule)
      @config.allow(:rule)
    end

    it "adds the rule" do
      @config.rules.should == [@rule]
    end

    context "#reset!" do
      before(:each) do
        @config.reset!
      end

      it "clears all rules" do
        @config.rules.should be_empty
      end
    end
  end

  context "#allow -- on an invalid rule" do
    before(:each) do
      rule = mock_rule(:invalid, false)
      @config.should_receive(:parse_command).once.and_return(rule)
      @allow = @config.allow(:rule)
    end

    it "returns false" do
      @allow.should == false
    end

    it "does not add the rule" do
      @config.rules.should be_empty
    end
  end
end
