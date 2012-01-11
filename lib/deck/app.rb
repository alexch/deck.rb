module Deck
 class App
  def initialize root, files
    @root, @files = root, files
  end
  
  def call env
    slides = []
    @files.each do |file|
      slides += Slide.from_file "#{@root}/#{file}"  
    end
    deck = Deck.new :slides => slides
    [200, {}, deck.to_pretty]
  end
 end
end
