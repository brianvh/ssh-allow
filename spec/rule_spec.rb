require 'spec_helper'

describe SSH::Allow::Rule do
  context "when initially created" do
    before(:each) do
      @rule = SSH::Allow::Rule.new
    end

    it "is invalid" do
      @rule.should_not be_valid
    end
  end
end
