require 'json'
require 'deck'

module Deck
  class RackApp
    def self.app_root
      here = File.dirname(__FILE__)
      app_root = File.expand_path "#{here}/../.."
    end

    def self.public_file_server
      Rack::File.new("#{app_root}/public")
    end

    def self.build slide_files, options = {}
      enable_thin_logging()

      Rack::Builder.app do
        use Rack::ShowExceptions
        use Rack::ShowStatus
        run ::Deck::RackApp.new(slide_files, options)
      end
    end

    def self.enable_thin_logging
      if const_defined?(:Thin)
        if require "thin/logging"
          Thin::Logging.debug = true
        end
      end
    end

    def initialize slide_files, options = {}
      @options = options
      @slide_files = [slide_files].flatten.map do |slide_file|
        case slide_file
        when /\/?showoff(.*)\.json$/
          parse_showoff_json(slide_file)
        else
          File.new(slide_file)
        end
      end.flatten

      @file_servers =
        [::Deck::RackApp.public_file_server] +
        @slide_files.map do |slide_file|
          File.expand_path File.dirname(slide_file.path) if slide_file.is_a? File
        end.compact.uniq.map do |slide_file_dir|
          Rack::File.new(slide_file_dir)
        end
    end

    def parse_showoff_json(slide_file)
      json_file_dir = File.expand_path(File.dirname(slide_file))
      json_file = slide_file
      config = JSON.parse(File.read(json_file))
      extract_options(config)
      extract_slides(config, json_file_dir)
    end

    def extract_slides(config, json_file_dir)
      config['sections'].map do |markdown_file|
        if markdown_file =~ /^# / # you can use literal markdown instead of a file name
          s = Slide.split(markdown_file)
          s
        else
          File.new(json_file_dir + '/' + markdown_file)
        end
      end
    end

    def extract_options(config)
      ["style", "transition"].each do |key|
        if config[key] and !@options[key.to_sym]
          @options[key.to_sym] = config[key]
        end
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
      SlideDeck.new({:slides => slides}.merge(@options))
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
