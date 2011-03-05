require 'thor'

module SSH::Allow
  class CLI < Thor

    desc  "guard --config | -c=<file> [--echo | -e]",
          "Guard against the SSH_REMOTE_COMMAND, using rules in the --config file."
    method_option :config, :type => :string, :aliases => '-c', :required => true,
                  :default => File.expand_path("~/.rkey"), :banner => "Path to configuration file"
    method_option :echo, :type => :boolean, :default => false, :aliases => '-e',
                  :banner => "Echo the SSH_REMOTE_COMMAND."
    def guard
      config.read(options[:config]) or fail(config.error)
      puts ssh_cmd if options[:echo]
      command = SSH::Allow.command(ssh_cmd)
      command.allowed? ? command.run : fail(command.error)
    end

    private

      def config
        SSH::Allow.configure
      end

      def fail(msg='ssh-allow: Something went wrong.')
        raise Thor::Error, msg
      end

      def ssh_cmd
        @ssh_cmd ||= ENV['SSH_REMOTE_COMMAND']
      end

  end
end
