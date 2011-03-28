require 'ssh/allow/cli'
require 'ssh/allow/rule_set'
require 'ssh/allow/rule'
require 'ssh/allow/command'

module SSH
  module Allow

    # module wrapper method for accessing the Singleton Configuration instance
    def self.rules
      SSH::Allow::RuleSet::Single.instance
    end

    # module wrapper method for parsing and verifying the passed in command string
    def self.command(cmd_str)
      @@command ||= SSH::Allow::Command.guard(cmd_str)
    end

  end
end
