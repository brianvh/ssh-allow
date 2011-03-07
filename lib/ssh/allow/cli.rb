require 'thor'

module SSH::Allow
  class CLI < Thor

    desc  "guard --rules | -r=<file> [--echo | -e]",
          "Guard against the SSH_REMOTE_COMMAND, using rules in the --rules file."
    method_option :rules, :type => :string, :aliases => '-r', :required => true,
                  :default => File.expand_path("~/.ssh-rules"), :banner => "Path to rules file"
    method_option :echo, :type => :boolean, :default => false, :aliases => '-e',
                  :banner => "Echo the SSH_REMOTE_COMMAND."
    def guard
      rules.read(options[:rules])
      puts ssh_cmd if options[:echo]
      command = SSH::Allow.command(ssh_cmd)
      command.allowed? ? command.run : fail(command.error)
    end

    private

      def rules
        SSH::Allow.rules
      end

      def fail(msg='ssh-allow: Something went wrong.')
        raise Thor::Error, msg
      end

      def ssh_cmd
        @ssh_cmd ||= ENV['SSH_REMOTE_COMMAND']
      end

  end
end
