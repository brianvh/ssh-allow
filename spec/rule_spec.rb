require 'spec_helper'

describe SSH::Allow::Rule do

  context "creating an Allow rule, with a single command" do
    before(:each) do
      @cmd = "ls"
    end

    context "with no options or arguments" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd)
      end

      it "returns [:none] for options" do
        @rule.options.should == [:none]
      end

      it "match_command? matches 'ls'" do
        @rule.should be_match_command(@cmd)
      end

      it "match_command? doesn't match 'ln'" do
        @rule.should_not be_match_command('ln')
      end

      it "match_options? matches no options" do
        @rule.should be_match_options([])
      end

      it "match_options? doesn't match a passed in option" do
        @rule.should_not be_match_options(['foo'])
      end

      it "match_arguments? matches no arguments" do
        @rule.should be_match_arguments([])
      end

      it "match_arguments? doesn't match a passed in argument" do
        @rule.should_not be_match_arguments(['foo'])
      end
    end

    context "with options and arguments, via a block" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd) do
          opts '-ld'
          args '^\/foo\/bar\/.*'
        end
      end

      it "returns \"ld\" for the rule options" do
        @rule.options.should == ['ld']
      end

      it "returns the correct pattern for the argument" do
        @rule.arguments[0].should == Regexp.new('^\/foo\/bar\/.*')
      end

      it "match_options? matches the correct options" do
        @rule.should be_match_options(['ld'])
      end

      it "match_options? doesn't match more than one option" do
        @rule.should_not be_match_options(['ld', 'foo'])
      end

      it "match_arguments? matches an argument that starts with '/foo/bar/'" do
        @rule.should be_match_arguments(['/foo/bar/*'])
      end

      it "match_arguments? doesn't match an argument that starts with '/foo/baz/'" do
        @rule.should_not be_match_arguments(['/foo/baz/*'])
      end

      it "match_arguments? doesn't match more than one argument" do
        @rule.should_not be_match_arguments(['/foo/bar/*', '/foo/baz/*'])
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
        @rule.should be(false)
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
