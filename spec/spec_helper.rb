require 'rspec'

support_path = File.expand_path(File.dirname(__FILE__) + "/support/**/*.rb")

Dir[support_path].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rspec
end
