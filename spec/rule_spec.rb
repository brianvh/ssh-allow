require 'spec_helper'

describe SSH::Allow::Rule do
  before(:each) do
    @rule = SSH::Allow::Rule.new
  end

  context "when initially created" do
    it "is invalid" do
      @rule.should_not be_valid
    end
  end
end
