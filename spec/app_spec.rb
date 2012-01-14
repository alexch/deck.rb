here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck/app"

require "rack/test"

describe Deck::App do
  include Rack::Test::Methods
  
  describe "app with middleware" do
    def app
      @app ||= Deck::App.build []
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
      assert { raw_app.is_a? Deck::App }
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
      @app ||= Deck::App.new []
    end

    it "serves a .md file as a deck.js HTML file" do
      dir = Files do
        file "foo.md"
      end
      @app = Deck::App.new ["#{dir}/foo.md"]
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
      @app = Deck::App.build ["#{dir}/foo.md"]
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
    
    it "serves multiple slide files from multiple subdirs, and serves their sibling and child files too" do
      dir = Files do
        dir "foo" do
          file "foo.md"
          file "foo.css"
        end
        dir "bar" do
          file "bar.md"
          file "bar.css"
          dir "img" do
            file "bar.png"
          end
        end
      end
      
      @app = Deck::App.build ["#{dir}/foo/foo.md", "#{dir}/bar/bar.md"]

      get "/"
      assert_ok
      assert { last_response.body.include? "contents of foo.md" }
      assert { last_response.body.include? "contents of bar.md" }

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
end
