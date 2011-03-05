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
end
