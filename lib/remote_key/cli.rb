require 'thor'

module RemoteKey

  class CLI < Thor

    desc  "guard --config | -c=<file> [--echo | -e]",
          "Guard against the SSH_REMOTE_COMMAND, using rules in the --config file."
    method_option :config, :type => :string, :aliases => '-c', :required => true,
                  :default => File.expand_path("~/.rkey"), :banner => "Path to configuration file"
    method_option :echo, :type => :boolean, :default => false, :aliases => '-e',
                  :banner => "Echo the SSH_REMOTE_COMMAND."
    def guard
      cmd = ENV['SSH_REMOTE_COMMAND']
      puts cmd if options[:echo]
      system("#{cmd}")
    end
  end

end
