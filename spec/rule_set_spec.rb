require 'spec_helper'

describe SSH::Allow::RuleSet do
  before(:each) do
    @rule_set = SSH::Allow::RuleSet.new
  end

  context "#new" do
    it "has an empty rules array" do
      @rule_set.rules.should be_empty
    end
  end

  context "with a valid rule" do
    before(:each) do
      @rule = mock_rule(:invalid)
      @rule_set.should_receive(:get_rule).once.and_return(@rule)
    end

    context "#allow" do
      before(:each) do
        @rule_set.allow(:rule)
      end

      it "adds the rule" do
        @rule_set.rules.should == [@rule]
      end
    end

    context "#allow!" do
      it "does not raise an error" do
        lambda { @rule_set.allow!(:rule) }.should_not raise_error
      end
    end
  end

  context "with an invalid rule" do
    before(:each) do
      rule = mock_rule(:invalid, false)
      @rule_set.should_receive(:get_rule).once.and_return(rule)
    end

    context "#allow" do
      before(:each) do
        @allow = @rule_set.allow(:rule)
      end

      it "returns false" do
        @allow.should == false
      end

      it "does not add the rule" do
        @rule_set.rules.should be_empty
      end
    end

    context "#allow!" do
      it "raises an error" do
        lambda { @rule_set.allow!(:rule) }.should raise_error(/Invalid rule: "rule"/)
      end
    end
  end

  context "with a config file with 2 valid rules" do
    before(:each) do
      @rule1 = mock_rule(:foo)
      @rule2 = mock_rule(:bar)
      @rule_set.should_receive(:get_rule).twice.and_return(@rule1, @rule2)
      @rule_set.should_receive(:read_rules).once.and_return(sample_rules)
    end

    context "#read" do
      before(:each) do
        @rule_set.read('/my/fake/rules')
      end

      it "adds 2 rules" do
        @rule_set.rules.should == [@rule1, @rule2]
      end
    end
  end

  context "with a config file with 1 valid and 1 invalid rule" do
    before(:each) do
      @rule1 = mock_rule(:foo)
      @rule2 = mock_rule(:bar, false)
      @rule_set.should_receive(:get_rule).twice.and_return(@rule1, @rule2)
      @rule_set.should_receive(:read_rules).once.and_return(sample_rules)
    end

    context "#read" do
      it "raises an error on the second rule" do
        lambda { @rule_set.read('/my/fake/rules') }.should raise_error(/Invalid rule: "bar"/)
      end
    end
  end
end
