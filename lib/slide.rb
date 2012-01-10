# based on work by Alex and others in Showoff
require 'redcarpet'

class Slide < Erector::Widget

  # given a chunk of Markdown text, splits it into an array of Slide objects
  def self.split content
    unless content =~ /^\<?!SLIDE/m
      content = content.gsub(/^# /m, "<!SLIDE>\n# ")
    end

    lines = content.split("\n")
    slides = []
    slides << (slide = Slide.new)
    until lines.empty?
      line = lines.shift
      if line =~ /^<?!SLIDE(.*)>?/
        slides << (slide = Slide.new(:classes => $1))

      elsif line =~ /^# / and !slide.empty?
        # every H1 defines a new slide, unless there's a !SLIDE before it
        slides << (slide = Slide.new)
        slide << line

      else
        slide << line
      end
    end

    slides.delete_if {|slide| slide.empty? }

    slides
  end

  ####

  attr_reader :classes, :markdown_text

  needs :classes => nil, :markdown_text => nil
  
  
  def initialize options = {}
    super options
    
    @classes = process_classes
    @markdown_text = ""
  end
  
  def process_classes
    ["slide"] + case @classes
    when NilClass
      []
    when String
      @classes.strip.chomp('>').split
    when Array
      @classes
    else
      raise "can't deal with :classes => #{@classes.inspect}"
    end
  end  

  def markdown
    @@markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML,
      :no_intra_emphasis => true,
      :tables => true,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => false,
      :space_after_headers => true,
      :superscript => false
    )
  end
  
  def <<(s)
    @markdown_text << s
    @markdown_text << "\n"
  end
  
  def empty?
    @markdown_text.strip == ""
  end
  
  def slide_id
    lines = @markdown_text.split("\n")
    raise "an empty slide has no id" if lines.empty?
    lines.first.gsub(/^#*/, '').strip.downcase.gsub(/[^\w\s]/, '').gsub(/\s/, '_')
  end
  
  def header_only?
    markdown_text.strip =~ /^# / and markdown_text.strip.split("\n").size == 1
  end
  
  def massaged_markdown_text
    unless header_only?
      "##{markdown_text.strip}"
    else
      markdown_text
    end
  end
  
  def content
    section :class => @classes, :id => slide_id do
      text "\n" # markdown HTML should be left-aligned, in case of PRE blocks and other quirks
      html = markdown.render(massaged_markdown_text)
      rawtext html
    end    
  end
end
