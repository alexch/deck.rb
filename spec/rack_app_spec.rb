here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/rack_app"

require "rack/test"

module Deck
 describe RackApp do
  include Rack::Test::Methods

  def here
    File.expand_path File.dirname(__FILE__)
  end

  describe "app with middleware" do
    def app
      @app ||= Deck::RackApp.build []
    end

    def apps
      @apps ||= begin
        [app].tap do |apps|
          while (next_app = apps.last.instance_variable_get(:@app))
            apps << next_app
          end
        end
      end
    end

    def raw_app
      apps.last
    end

    it "middleware chain resolves to the real app" do
      assert { raw_app.is_a? Deck::RackApp }
    end

    it "serves up deck.js source files" do
      deckjs_core_path = "deck.js/core/deck.core.js"
      get "/#{deckjs_core_path}"
      assert { last_response.body ==
        File.read("#{here}/../public/#{deckjs_core_path}", :encoding => last_response.body.encoding)}
    end

  end

  describe "raw app" do
    def app
      @app ||= Deck::RackApp.new []
    end

    it "serves a .md file as a deck.js HTML file" do
      dir = Files do
        file "foo.md"
      end
      @app = Deck::RackApp.new ["#{dir}/foo.md"]
      get "/"
      assert_ok
      assert { last_response.body.include? "contents of foo.md" }
      assert { last_response.body.include? "<script src=\"deck.js/core/deck.core.js\"" }
    end

    it "404s anything but the root path" do
      get "/something"
      assert { last_response.status == 404 }
    end

    it "serves up non-markdown files in the top directory" do
      dir = Files do
        file "foo.md"
        file "foo.css"
      end
      @app = Deck::RackApp.build ["#{dir}/foo.md"]
      get "/foo.css"
      assert_ok
      assert { last_response.body.include? "contents of foo.css" }
    end

    def assert_ok
      unless last_response.ok?
        status, errors = last_response.status, last_response.errors
        assert(last_response.inspect) { errors.empty? && status == 200 }
      end
    end

    describe "serving multiple slide files from multiple subdirs" do

      before do
        @dir = Files do
          dir "foo" do
            file "foo.md", "# foo"
            file "foo.css"
          end
          dir "bar" do
            file "bar.md", "# barista\n\n# barbie\n\n# bartles & james"
            file "bar.css"
            dir "img" do
              file "bar.png"
            end
          end
        end

        @app = Deck::RackApp.build ["#{@dir}/foo/foo.md", "#{@dir}/bar/bar.md"]
      end

      it "stuffs all the source files into a single slide deck served off /" do
        get "/"
        assert_ok

        doc = noko_doc(last_response.body)

        slides = doc.css('section.slide')
        assert { slides.size == 4 }
        assert { slides[0].inner_html.include?("<h1>foo</h1>") }
        assert { slides[1].inner_html.include?("<h1>barista</h1>") }
        assert { slides[2].inner_html.include?("<h1>barbie</h1>") }
        assert { slides[3].inner_html.include?("<h1>bartles &amp; james</h1>") }
      end

      it "serves sibling and child files too" do

        get "/foo.css"
        assert_ok
        assert { last_response.body.include? "contents of foo.css" }

        get "/bar.css"
        assert_ok
        assert { last_response.body.include? "contents of bar.css" }

        get "/img/bar.png"
        assert_ok
        assert { last_response.body.include? "contents of bar.png" }

      end
    end

    describe "highlights code blocks" do
      def build_app markdown
        @dir = Files do
          file "foo.md", markdown
        end
        @app = Deck::RackApp.build ["#{@dir}/foo.md"]
      end

      def assert_code_is_highlighted
        get "/"
        assert_ok
        doc = noko_doc(last_response.body)

        slides = doc.css('section.slide')
        assert { slides.size == 1 }
        slide = slides.first
        code_block = slide.css('pre').first
        assert { code_block.inner_html == "sum = <span class=\"integer\">2</span> + <span class=\"integer\">2</span>\n"     }
      end

      it "with :::" do
        build_app <<-MARKDOWN
# some code

    :::ruby
    sum = 2 + 2
        MARKDOWN

        assert_code_is_highlighted
      end

      it "with @@@" do
        build_app <<-MARKDOWN
# some code

    @@@ruby
    sum = 2 + 2
        MARKDOWN

        assert_code_is_highlighted
      end
    end

    describe '#slides' do
      it "builds a bunch of slide objects from the slide_files property" do
        slide_file = nil
        @dir = Files do
          slide_file = file "foo.md", "# hello"
        end
        app = RackApp.new [slide_file]
        assert { app.slides == Slide.from_file(slide_file) }
      end

      it "reads a showoff.json file" do
        foo_file, bar_file, showoff_file = nil,nil,nil
        @dir = Files do
          foo_file = file "foo.md", "# hello"
          bar_file = file "bar.md", "# hello"
          showoff_file = file "showoff.json", <<-JSON
          {
            "name": "Ruby For Programmers",
            "description": "an introduction to the Ruby programming language",
            "sections": [
              "foo.md",
              "bar.md"
            ]
          }
          JSON
        end
        app = RackApp.new [showoff_file]
        assert { app.slides == Slide.from_file(foo_file) + Slide.from_file(bar_file) }
      end

      it "reads a showoff.json file including literal markdown as a section" do
        foo_file, bar_file, showoff_file = nil,nil,nil
        @dir = Files do
          foo_file = file "foo.md", "# hello"
          bar_file = file "bar.md", "# goodbye"
          showoff_file = file "showoff.json", <<-JSON
          {
            "name": "Ruby For Programmers",
            "description": "an introduction to the Ruby programming language",
            "sections": [
              "foo.md",
              "# literal markdown",
              "bar.md"
            ]
          }
          JSON
        end
        app = RackApp.new [showoff_file]
        assert {
          app.slides.size == 3
        }
        assert {
          app.slides[1].markdown_text == "# literal markdown\n"
        }
        assert { app.slides[0].slide_id == "hello" }
        assert { app.slides[1].slide_id == "literal_markdown" }
        assert { app.slides[2].slide_id == "goodbye" }
        # assert {
        #   app.slides ==
        #   Slide.from_file(foo_file) +
        #   [Slide.new(:markdown_text => "# literal markdown")] +
        #   Slide.from_file(bar_file)
        # }
        assert {
          app.deck.to_html.include?("<h1>literal markdown</h1>")
        }
      end

      it "if no slides are specified, it globs all markdown files under ."

    end

  end
 end
end
