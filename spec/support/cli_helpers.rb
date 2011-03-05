module CLIHelpers

  def show_stdout
    @puts = true
    @announce_stdout = true
  end

  def show_stderr
    @puts = true
    @announce_stderr = true
  end

  def ssh_command(cmd)
    ENV['SSH_REMOTE_COMMAND'] = cmd
  end

end
