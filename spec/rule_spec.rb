require 'spec_helper'

describe SSH::Allow::Rule do

  context "creating an Allow rule" do
    context "with a single command string" do
      before(:each) do
        @cmd = "ls"
        @rule = SSH::Allow::Rule.allow(@cmd)
      end

      it "returns an Allow rule" do
        @rule.should be_instance_of(SSH::Allow::Rule::Allow)
      end
    end
  end

  context "creating a Deny rule" do
    context "with a single command string" do
      before(:each) do
        @cmd = "ls"
        @rule = SSH::Allow::Rule.deny(@cmd)
      end

      it "returns a Deny rule" do
        @rule.should be_instance_of(SSH::Allow::Rule::Deny)
      end
    end
  end
end
