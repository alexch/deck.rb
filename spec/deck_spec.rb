here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/deck"

module Deck
 describe Deck do
    
  def doc
    @doc ||= begin
      @html = deck_widget.to_html
      noko_doc @html
    end
  end
  
  def deck_widget options = {}
    @deck_widget ||= Deck.new options
  end
  
  it "renders a basic deck.js HTML page" do
    assert { doc }
    assert { @html.include? '<link href="deck.js/core/deck.core.css" rel="stylesheet" />' }
  end
  
  it "contains a single dummy slide" do
    assert { doc.css('section.slide').size == 1 }
  end
    
  it "renders a markdown file with one slide" do
    file = nil
    dir = Files do
      file = file("hello.md", "# hello")
    end
    
    deck_widget :slides => Slide.split(File.read file)
    assert { doc.css('section.slide').size == 1 }
    slide = doc.css('section.slide').first
    assert { slide["id"] == "hello" }
    assert { noko_html(slide) == "<section class=\"slide\" id=\"hello\">" + 
      "<h1>hello</h1>\n" + 
      "</section>" 
    }
  end
  
 end
end
