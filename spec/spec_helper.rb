$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'simplecov'
require 'simplecov-rcov'

SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start

require 'rspec'
require 'rspec/expectations'
require 'rubydariah'

# Dependencies
require 'vcr'
require 'webmock/rspec'

WebMock.allow_net_connect!

#VCR config
VCR.configure { |c|
  c.cassette_library_dir = 'spec/fixtures/rubydariah_cassettes'
  c.hook_into :webmock
}

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end
