here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/slide_deck"

module Deck
  describe SlideDeck do

    include Files

    let(:html) { deck_widget.to_html }
    let(:doc) { noko_doc html }

    def deck_widget options = {}
      @deck_widget ||= SlideDeck.new options
    end

    it "renders a basic deck.js HTML page" do
      assert { html.include? '<link href="/deck.js/core/deck.core.css" rel="stylesheet" />' }
    end

    it "starts the deck script running" do
      assert { html.include? "$.deck('.slide');" }
    end

    it "contains a single dummy slide" do
      assert { doc.css('section.slide').size == 1 }
    end

    it "renders a markdown file with one slide" do
      file = file("hello.md", "# hello")
      deck_widget :slides => Slide.split(File.read file)
      slides = doc.css('section.slide')
      assert { slides.size == 1 }
      slide = slides.first
      assert { slide["id"] == "hello" }

      slide_html = noko_html(slide)
      slide_html.gsub!("\n", "") # WTF Nokogiri inconsistently outputs newlines between Ruby 1.9 and 2.0
      assert { slide_html == "<section class=\"slide markdown-body\" id=\"hello\">" + "<h1>hello</h1>" + "</section>" }
    end

    it "includes a table of contents" do
      deck_widget :slides => Slide.split("# Foo\n\n# Bar\n")
      toc = doc.css('.slide_toc')
      assert { toc.size == 1 }
      assert_html_like noko_html(toc.first), "<div class=\"slide_toc\">" +
          "<div class=\"toggle\">[contents]</div>" +
          "<div class=\"table\">" +
          "<h2>deck.rb presentation</h2>" +
          "<ul>" +
          "<li><a href=\"#foo\">Foo</a></li>" +
          "<li><a href=\"#bar\">Bar</a></li>" +
          "</ul>" +
          "</div>" +
          "</div>"
    end

    describe "themes" do

      def style_theme_node
        doc.css("head link[rel='stylesheet'][id='style-theme-link']").first
      end

      def transition_theme_node
        doc.css("head link[rel='stylesheet'][id='transition-theme-link']").first
      end

      it "defaults to 'swiss' style theme" do
        deck_widget :slides => Slide.split("# Foo\n")
        link_node = style_theme_node()
        assert { link_node['href'] == "/deck.js/themes/style/swiss.css" }
      end

      it "defaults to 'horizontal-slide' transition theme" do
        deck_widget :slides => Slide.split("# Foo\n")
        link_node = transition_theme_node()
        assert { link_node['href'] == "/deck.js/themes/transition/horizontal-slide.css" }
      end

      it "accepts theme names params" do
        deck_widget :slides => Slide.split("# Foo\n"), :theme => "foo", :transition => "bar"

        assert { style_theme_node['href'] == "/deck.js/themes/style/foo.css" }
        assert { transition_theme_node['href'] == "/deck.js/themes/transition/bar.css" }
      end

    end

  end
end
