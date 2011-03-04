require 'spec_helper'
require 'aruba/api'

RSpec.configure do |config|
  config.include Aruba::Api

  config.before(:all) do
    @__aruba_original_paths = (ENV['PATH'] || '').split(File::PATH_SEPARATOR)
    ENV['PATH'] = ([File.expand_path('bin')] + @__aruba_original_paths).join(File::PATH_SEPARATOR)
    FileUtils.rm_rf(current_dir)
  end

  config.after(:all) do
    ENV['PATH'] = @__aruba_original_paths.join(File::PATH_SEPARATOR)
    restore_env
  end

end

