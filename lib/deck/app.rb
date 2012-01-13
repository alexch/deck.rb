here = File.expand_path File.dirname(__FILE__)

module Deck
  class App
    def self.build slide_files
      
      if const_defined?(:Thin)
        if require "thin/logging"
          Thin::Logging.debug = true
        end
      end
      
      here = File.dirname(__FILE__)
      app_root = File.expand_path "#{here}/../.."
      
      Rack::Builder.app do
        use Rack::ShowExceptions
        use Rack::ShowStatus
        use Rack::Static, :urls => ["/deck.js"], :root => app_root
        run ::Deck::App.new(slide_files)
      end
    end

    def initialize slide_files
      @slide_files = [slide_files].flatten
      
      @file_servers = @slide_files.map do |slide_file|
        Rack::File.new(File.dirname slide_file)
      end
    end

    def call env
      request = Rack::Request.new(env)
      if request.path == "/"
        slides = []
        @slide_files.each do |file|
          slides += Slide.from_file file
        end
        deck = Deck.new :slides => slides
        [200, {}, [deck.to_pretty]]
      else
        result = [404, {}, []]
        @file_servers.each do |file_server|
          result = file_server.call(env)
          break if result.first == 200
        end
        result
      end
    end
  end
end
