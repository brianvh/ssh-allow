require 'acceptance/acceptance_helper'

describe "Executing the remote_key CLI" do
  context "GIVEN: a path-limited 'ls' config file" do
    before(:each) do
      @file = 'test.rkey'
      @dir_path = File.expand_path(current_dir + '/../')
      @allow = %(
      allow('ls', '/bin/ls') do
        opts '-ld'
        args "#{@dir_path}/.*"
      end
      ).gsub(/^ {6}/, '')
      write_file(@file, @allow)
    end

    context "WHEN: we run 'remote_key guard --echo' with a valid path" do
      before(:each) do
        @ssh = "ls -ld #{@dir_path}/*"
        ENV['SSH_REMOTE_COMMAND'] = @ssh
        @cmd = "remote_key guard --config=#{current_dir}/#{@file} --echo"
        run_simple(@cmd)
      end

      context "THEN: the output of the run" do
        it "should contain the remote command" do
          all_output.should include(@ssh)
        end

        it "should contain a listing for the 'tmp/aruba' directory" do
          all_output.should match(/tmp\/aruba$/)
        end
      end
    end
  end
end
