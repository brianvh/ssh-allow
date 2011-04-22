require 'spec_helper'

describe SSH::Allow::Rule do

  context "creating an Allow rule, with a single command" do
    before(:each) do
      @cmd = "ls"
    end

    context "when specifying no options or arguments" do
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

    context "when specifying :any for options and arguments " do
      before(:each) do
        @rule = SSH::Allow::Rule.allow(@cmd)
        @rule.opts(:any)
        @rule.args(:any)
      end

      it "match_options? matches no options" do
        @rule.should be_match_options([])
      end

      it "match_options? matches any number of options" do
        @rule.should be_match_options(['foo', 'bar', 'baz'])
      end

      it "match_arguments? matches no arguments" do
        @rule.should be_match_arguments([])
      end

      it "match_arguments? matches any number of arguments" do
        @rule.should be_match_arguments(['foo', 'bar', :baz])
      end
    end

    context "when specifying strings for options and arguments, via a block" do
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

    context "when sending an invalid block" do
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

describe SSH::Allow::Rule::Allow do
  context "A Command for 'ls -ld /foo/bar/*'" do
    before(:each) do
      @cmd = mock(:command)
      @cmd.should_receive(:name).once.and_return('ls')
      @cmd.should_receive(:options).once.and_return(['ld'])
      @cmd.should_receive(:arguments).once.and_return(['/foo/bar/*'])
    end

    context "matched against an 'ls' rule with no options or arguments" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow('ls')
        @match, @allow = @rule.match?(@cmd)
      end

      it "is not a match" do
        @match.should_not be(true)
      end

      it "would not be allowed" do
        @allow.should_not be(true)
      end
    end

    context "matched against an 'ls' rule with matching options and arguments" do
      before(:each) do
        @rule = SSH::Allow::Rule.allow('ls') do
          opts '-ld'
          args '^\/foo\/bar\/.*'
        end
        @match, @allow = @rule.match?(@cmd)
      end

      it "is a match" do
        @match.should be(true)
      end

      it "would be allowed" do
        @allow.should be(true)
      end
    end
  end
end

describe SSH::Allow::Rule::Deny do
  context "A Command for 'mv /foo/bar/file.txt /foo/baz/'" do
    before(:each) do
      @cmd = mock(:command)
      @cmd.should_receive(:name).once.and_return('mv')
      @cmd.should_receive(:options).once.and_return([])
      @cmd.should_receive(:arguments).once.and_return(['/foo/bar/file.txt', '/foo/baz/'])
    end

    context "matched against an 'mv' rule with no options or arguments" do
      before(:each) do
        @rule = SSH::Allow::Rule.deny('mv')
        @match, @allow = @rule.match?(@cmd)
      end

      it "is not a match" do
        @match.should_not == true
      end

      it "would be allowed" do
        @allow.should == true
      end
    end

    context "matched against an 'mv' rule with matching options and arguments" do
      before(:each) do
        @rule = SSH::Allow::Rule.deny('mv') do
          args '^\/foo\/bar\/.*'
          args '^\/foo\/baz\/.*'
        end
        @match, @allow = @rule.match?(@cmd)
      end

      it "is a match" do
        @match.should == true
      end

      it "would not be allowed" do
        @allow.should_not == true
      end
    end
  end
end
