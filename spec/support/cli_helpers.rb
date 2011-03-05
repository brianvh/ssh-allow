module CLIHelpers

  def show_stdout
    @puts = true
    @announce_stdout = true
  end

  def ssh_command(cmd)
    ENV['SSH_REMOTE_COMMAND'] = cmd
  end

end
