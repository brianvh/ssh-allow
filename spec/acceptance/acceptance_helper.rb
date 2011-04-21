require 'spec_helper'
require 'aruba/api'

RSpec.configure do |config|
  config.include Aruba::Api
  config.include CLIHelpers

  config.before(:all) do
    @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
    ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
    FileUtils.rm_rf(current_dir)
    @aruba_io_wait_seconds = 1.5
  end

  config.after(:all) do
    ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
    restore_env
  end

end

