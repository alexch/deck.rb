here = File.expand_path File.dirname(__FILE__)
top = File.expand_path "#{here}/.."
$: << "#{top}/lib"

require "rspec"
require "wrong/adapters/rspec"
require "nokogiri"
require "wrong"
require "files"

require "deck/noko"
include Deck::Noko

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
  end
end
