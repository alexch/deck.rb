here = File.expand_path File.dirname(__FILE__)
top = File.expand_path "#{here}/.."
$: << "#{top}/lib"

require "date"
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

def normalize_html_whitespace html
  html.strip.gsub(/[\n ]+/, " ")  # all strings of newlines or spaces -> single space
      .gsub(/>(?=[^\s])/, '> ')   # add a single space after each close tag
      .gsub(/( )+</, '<')         # remove any space before any tag
end

def assert_html_like actual, expected
  actual = normalize_html_whitespace(actual)
  expected = normalize_html_whitespace(expected)
  assert {actual == expected}
end

