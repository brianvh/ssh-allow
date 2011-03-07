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

  context "with a valid rule" do
    before(:each) do
      @rule = mock_rule(:invalid)
      @config.should_receive(:parse_command).once.and_return(@rule)
    end

    context "#allow" do
      before(:each) do
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

    context "#allow!" do
      it "does not raise an error" do
        lambda { @config.allow!(:rule) }.should_not raise_error
      end
    end
  end

  context "with an invalid rule" do
    before(:each) do
      rule = mock_rule(:invalid, false)
      @config.should_receive(:parse_command).once.and_return(rule)
    end

    context "#allow" do
      before(:each) do
        @allow = @config.allow(:rule)
      end

      it "returns false" do
        @allow.should == false
      end

      it "does not add the rule" do
        @config.rules.should be_empty
      end
    end

    context "#allow!" do
      it "raises an error" do
        lambda { @config.allow!(:rule) }.should raise_error(/Invalid rule: "rule"/)
      end
    end
  end

  context "with a config file with 2 valid rules" do
    before(:each) do
      @rule1 = mock_rule(:foo)
      @rule2 = mock_rule(:bar)
      @config.should_receive(:parse_command).twice.and_return(@rule1, @rule2)
      @config.should_receive(:read_config).once.and_return(sample_rules)
    end

    context "#read" do
      before(:each) do
        @config.read('/my/fake/rules')
      end

      it "adds 2 rules" do
        @config.rules.should == [@rule1, @rule2]
      end
    end
  end

  context "with a config file with 1 valid and 1 invalid rule" do
    before(:each) do
      @rule1 = mock_rule(:foo)
      @rule2 = mock_rule(:bar, false)
      @config.should_receive(:parse_command).twice.and_return(@rule1, @rule2)
      @config.should_receive(:read_config).once.and_return(sample_rules)
    end

    context "#read" do
      it "raises an error on the second rule" do
        lambda { @config.read('/my/fake/rules') }.should raise_error(/Invalid rule: "bar"/)
      end
    end
  end
end
