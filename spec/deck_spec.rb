here = File.expand_path File.dirname(__FILE__)
require "#{here}/spec_helper"

require "deck"

describe Deck do
  def temp_dir options = {:remove => true}
    @temp_dir ||= begin
      require 'tmpdir'
      require 'fileutils'
      called_from = File.basename caller.first.split(':').first, ".rb"
      path = File.join(Dir::tmpdir, "#{called_from}_#{Time.now.to_i}_#{rand(1000)}")
      Dir.mkdir(path)
      at_exit {FileUtils.rm_rf(path) if File.exists?(path)} if options[:remove]
      path
    end
  end
  
  def to_html nokogiri_node
    nokogiri_node.serialize(:save_with => 0).chomp
  end
  
  def as_html_page snippet
    snippet =~ /<html/ ? snippet : "<html>#{snippet}</html>"
  end
  
  def deck_widget options = {}
    @deck_widget ||= Deck.new options
  end
  
  def doc
    @doc ||= begin
      @html = deck_widget.to_html
      Nokogiri.parse(as_html_page(@html))
    end
  end
  
  def write name, contents = "contents of #{name}"
    path = "#{temp_dir}/#{name}"
    File.open(path, "w") do |f|
      f.write contents
    end
    File.new path
  end

  describe "#write" do
    before do
      @hello = write "hello.txt"
      @goodbye = write "goodbye.txt", "farewell"
    end
  
    it "uses temp_dir" do
      File.dirname(@hello).should == temp_dir
      File.dirname(@goodbye).should == temp_dir
    end
  
    it "writes a default value" do
      File.read(@hello).should == "contents of hello.txt"
    end
  
    it "writes a given value" do
      # since write returns a File instance, we can call read on it
      @goodbye.read.should == "farewell"
    end

    it "writes a file" do
      file = write("hello.md", "# hello")
      assert { File.read(file) == "# hello" }
    end
  
  end
  
  
  it "renders a basic deck.js HTML page" do
    assert { doc }
    assert { @html.include? '<link href="deck/core/deck.core.css" rel="stylesheet" />' }
  end
  
  it "contains a single dummy slide" do
    assert { doc.css('section.slide').size == 1 }
  end
    
  it "renders a markdown file with one slide" do
    file = write("hello.md", "# hello")
    
    deck_widget :slides => Slide.split(File.read file)
    assert { doc.css('section.slide').size == 1 }
    slide = doc.css('section.slide').first
    assert { slide["id"] == "hello" }
    assert { to_html(slide) == "<section class=\"slide\" id=\"hello\">" + 
      "<h1>hello</h1>\n" + 
      "</section>" 
    }
  end
  
end
