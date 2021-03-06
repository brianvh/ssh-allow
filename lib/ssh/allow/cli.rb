require 'thor'

module SSH ; module Allow
  class CLI < Thor

    desc  "guard --rules | -r=<file> [--echo | -e]",
          "Guard against the SSH_ORIGINAL_COMMAND, using rules in the --rules file."
    method_option :rules, :type => :string, :aliases => '-r', :required => true,
                  :default => File.expand_path("~/.ssh-rules"), :banner => "Path to rules file"
    method_option :echo, :type => :boolean, :default => false, :aliases => '-e',
                  :banner => "Echo the SSH_ORIGINAL_COMMAND."
    def guard
      rule_set.read(options[:rules])
      puts command if options[:echo]
      command.allowed?(rule_set.rules) ? command.run : fail
    end

    private

    def rule_set
      @rule_set ||= SSH::Allow::RuleSet.new
    end

    def command
      @command ||= SSH::Allow::Command.new(ENV['SSH_ORIGINAL_COMMAND'])
    end

    def fail
      raise Thor::Error, "Remote Command Not Allowed: #{command}"
    end

  end
end ; end
