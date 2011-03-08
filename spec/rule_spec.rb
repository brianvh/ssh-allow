require 'spec_helper'

describe SSH::Allow::Rule do

  context "creating an Allow rule, with a single command" do
    before(:each) do
      @cmd = "ls"
    end

    context "without a block" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd)
      end

      context "the rule options" do
        it "returns :none" do
          @rule.options.should == [:none]
        end
      end
    end

    context "with a valid block" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd) do
          opts "-ld"
          args "/foo/bar/.*"
        end
      end

      context "the rule options" do
        it "returns \"-ld\"" do
          @rule.options.should == ["-ld"]
        end
      end

      context "the rule arguments" do
        it "returns \"/foo/bar/.*\"" do
          @rule.arguments.should == ["/foo/bar/.*"]
        end
      end
    end

    context "with an invalid block" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd) do
          opts "-ld"
          foo "bar"
        end
      end

      it "returns false" do
        @rule.should be_false
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
