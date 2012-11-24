here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/slide_deck"

module Deck
  describe SlideDeck do

    include Files

    def doc
      @doc ||= begin
        @html = deck_widget.to_html
        noko_doc @html
      end
    end

    def deck_widget options = {}
      @deck_widget ||= SlideDeck.new options
    end

    it "renders a basic deck.js HTML page" do
      assert { doc }
      assert { @html.include? '<link href="/deck.js/core/deck.core.css" rel="stylesheet" />' }
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
      assert { noko_html(slide) == "<section class=\"slide\" id=\"hello\">" +
          "<h1>hello</h1>\n" +
          "</section>"
      }
    end

    it "includes a table of contents" do
      deck_widget :slides => Slide.split("# Foo\n\n# Bar\n")
      toc = doc.css('.slide_toc')
      assert { toc.size == 1 }
      assert { noko_html(toc.first) == "<div class=\"slide_toc\">" +
          "<div class=\"toggle\">[contents]</div>" +
          "<div class=\"table\">" +
          "<h2>deck.rb presentation</h2>" +
          "<ul>" +
          "<li><a href=\"#foo\">Foo</a></li>" +
          "<li><a href=\"#bar\">Bar</a></li>" +
          "</ul>" +
          "</div>"
          "</div>"
      }
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
        deck_widget :slides => Slide.split("# Foo\n"), :style => "foo", :transition => "bar"

        assert { style_theme_node['href'] == "/deck.js/themes/style/foo.css" }
        assert { transition_theme_node['href'] == "/deck.js/themes/transition/bar.css" }
      end

    end

  end
end
