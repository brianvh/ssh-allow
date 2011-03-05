require 'ssh/allow/cli'
require 'ssh/allow/configuration'

module SSH
  module Allow

    # module wrapper method for accessing the Singleton Configuration instance
    def self.configure
      SSH::Allow::Configuration::Single.instance
    end

    # module wrapper method for parsing and verifying the passed in command string
    def self.command(cmd_str)
      SSH::Allow::Command.guard(cmd_str)
    end

  end
end
