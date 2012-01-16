here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/rack_app"

require "rack/test"

describe Deck::RackApp do
  include Rack::Test::Methods

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

    it ""

  end
end
