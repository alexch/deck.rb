require 'nokogiri'

module Deck
  # Wrappers around Nokogiri's occasionally inscrutable API
  module Noko
    def noko_html nokogiri_node
      nokogiri_node.serialize(:save_with => 0).chomp
    end

    def noko_doc html_snippet
      html_doc = html_snippet =~ /<html/ ? html_snippet : "<html>#{html_snippet}</html>"
      Nokogiri.parse(html_doc)
    end
  end
end
