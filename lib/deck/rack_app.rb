here = File.expand_path File.dirname(__FILE__)

require 'json'
require 'coderay'
require 'rack/codehighlighter'
require 'deck'

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
        use Rack::Codehighlighter, :coderay,
          :element => "pre>code",
          :markdown => true,
          :pattern => /\A[:@]{3}\s?(\w+)\s*(\n|&#x000A;)/i
        run ::Deck::RackApp.new(slide_files)
      end
    end

    def initialize slide_files
      @slide_files = [slide_files].flatten.map do |slide_file|
        case slide_file
        when /\/?showoff.json$/
          json_file_dir = File.expand_path(File.dirname(slide_file))
          json_file = slide_file
          config = JSON.parse(File.read(json_file))
          config['sections'].map do |markdown_file|
            if markdown_file =~ /^# /   # you can use literal markdown instead of a file name
              s = Slide.split(markdown_file)
              s
            else
              File.new(json_file_dir + '/' + markdown_file)
            end
          end
        else
          File.new(slide_file)
        end
      end.flatten

      @file_servers =
        [Rack::File.new("#{::Deck::RackApp.app_root}/public")] +
        @slide_files.map do |slide_file|
          File.expand_path File.dirname(slide_file) if slide_file.is_a? File
        end.compact.uniq.map do |slide_file_dir|
          Rack::File.new(slide_file_dir)
        end
    end

    def call env
      request = Rack::Request.new(env)
      if request.path == "/"
        [200, {'Content-Type' => 'text/html'}, [deck.to_pretty]]
      else
        result = [404, {}, []]
        @file_servers.each do |file_server|
          result = file_server.call(env)
          return result if result.first < 400
        end
        result
      end
    end

    def deck
      SlideDeck.new :slides => slides
    end

    def slides
      out = []
      @slide_files.each do |file|
        out += if file.is_a? Slide
          [file]
        else
          Slide.from_file file
        end
      end
      out
    end
  end
end
