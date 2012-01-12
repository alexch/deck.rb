module Deck
  class App
    def self.build app_root, slide_root, slide_files
      
      if const_defined?(:Thin)
        if require "thin/logging"
          Thin::Logging.debug = true
        end
      end

      Rack::Builder.app do
        use Rack::ShowExceptions
        use Rack::ShowStatus
        use Rack::Static, :urls => ["/deck.js"], :root => app_root
        slide_files.each do |slide_file|
          slide_dir = File.dirname slide_file
          use Rack::Static, :urls => ["/img"], :root => slide_dir
        end
        run ::Deck::App.new(slide_root, slide_files)
      end
    end

    def initialize slide_root, slide_files
      @slide_root, @slide_files = slide_root, slide_files
    end

    def call env
      slides = []
      @slide_files.each do |file|
        slides += Slide.from_file "#{@slide_root}/#{file}"  
      end
      deck = Deck.new :slides => slides
      [200, {}, [deck.to_pretty]]
    end
  end
end
