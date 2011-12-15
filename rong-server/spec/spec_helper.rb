require 'rspec'
require 'rong/server'

RSpec.configure do |config|
  config.mock_with :rspec
  config.color_enabled = true
  config.fail_fast = true
end
