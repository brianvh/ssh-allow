require 'acceptance/acceptance_helper'

describe "Executing the ssh-allow CLI" do
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
      @cmd = "ssh-allow guard --config=#{current_dir}/#{@file} --echo"
    end

    context "WHEN: we run 'ssh-allow guard --echo' with a valid path" do
      before(:each) do
        @ssh = ssh_command %(ls -ld #{@dir_path}/*)
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

    context "WHEN: we run 'ssh-allow guard --echo' with an invalid path" do
      before(:each) do
        @ssh = ssh_command %(ls -ld /foo/bar/*)
        run_simple(@cmd, false)
      end

      context "THEN: the output of the run" do
        it "should fail with an error" do
          @last_exit_status.should_not == 0
        end
      end
    end
  end
end
