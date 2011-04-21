require 'acceptance/acceptance_helper'

describe "Executing the ssh-allow CLI" do
  context "GIVEN: a path-limited 'ls' config file" do
    before(:each) do
      @file = 'test.rules'
      @dir_path = File.expand_path(current_dir + '/../')
      @allow = %(
      allow!("ls") do
        opts "-ld"
        args "#{@dir_path}/.*"
      end
      ).gsub(/^ {6}/, '')
      write_file(@file, @allow)
      @cmd = "ssh-allow guard --rules=#{File.expand_path(current_dir)}/#{@file} --echo"
    end

    context "WHEN: we run 'ssh-allow guard --echo' with an allowed path" do
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

    context "WHEN: we run 'ssh-allow guard --echo' with an disallowed path" do
      before(:each) do
        @ssh = ssh_command %(ls -ld /foo/bar/*)
        run_simple(@cmd)
      end

      it "standard error indicates a bad command" do
        all_stderr.should match(/Remote Command Not Allowed: #{@ssh}/)
      end
    end

  end
end
