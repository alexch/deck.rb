here = File.expand_path File.dirname(__FILE__)

module Deck
  class RackApp
    def self.app_root
      here = File.dirname(__FILE__)
      app_root = File.expand_path "#{here}/../.."
    end

    def self.build slide_files

      if const_defined?(:Thin)
        if require "thin/logging"
          Thin::Logging.debug = true
        end
      end

      Rack::Builder.app do
        use Rack::ShowExceptions
        use Rack::ShowStatus
        run ::Deck::RackApp.new(slide_files)
      end
    end

    def initialize slide_files
      @slide_files = [slide_files].flatten

      @file_servers =
        [Rack::File.new("#{::Deck::RackApp.app_root}/public")] +
        @slide_files.map do |slide_file|
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
        deck = SlideDeck.new :slides => slides
        [200, {}, [deck.to_pretty]]
      else
        result = [404, {}, []]
        @file_servers.each do |file_server|
          result = file_server.call(env)
          return result if result.first < 400
        end
        result
      end
    end
  end
end
