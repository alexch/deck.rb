# based on work by Alex and others in Showoff
require 'redcarpet'
require 'deck/noko'
require 'deck/renderer'

module Deck
 class Slide < Erector::Widget

  include Deck::Noko

  # todo: test this method on its own
  def self.from_file markdown_file
    markdown_file = markdown_file.path if markdown_file.is_a? File   # fix for Ruby 1.8.7
    split File.read(markdown_file)
  end

  # given a chunk of Markdown text, splits it into an array of Slide objects
  # todo: move into SlideDeck?
  def self.split content
    unless content =~ /^\<?!SLIDE/m     # this only applies to files with no !SLIDEs at all, which is odd
      content = content.
        gsub(/^# /m, "<!SLIDE>\n# ").
        gsub(/^(.*)\n(===+)/, "<!SLIDE>\n\\1\n\\2")
    end

    lines = content.split("\n")
    slides = []
    slides << (slide = Slide.new)
    until lines.empty?
      line = lines.shift
      if line =~ /^<?!SLIDE(.*)>?/
        slides << (slide = Slide.new(:classes => $1))

      elsif (line =~ /^# / or lines.first =~ /^(===+)/) and !slide.empty?
        # every H1 defines a new slide, unless there's a !SLIDE before it
        slides << (slide = Slide.new)
        slide << line

      elsif line =~ /^\.notes/
        # don't include notes

      else
        slide << line
      end
    end

    slides.delete_if {|slide| slide.empty? }

    slides
  end

  ####

  attr_reader :classes, :markdown_text

  needs :classes => nil, :slide_id => nil
  needs :markdown_text => nil

  def initialize options = {}
    super options

    @classes = process_classes
    @markdown_text = ""
  end

  def ==(other)
    Slide === other and
    @classes == other.classes and
    @markdown_text == other.markdown_text
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
    @@markdown ||= Redcarpet::Markdown.new(Deck::Renderer,
      :autolink            => true,
      :fenced_code_blocks  => true,
      :lax_html_blocks     => false,
      :no_intra_emphasis   => true,
      :space_after_headers => true,
      :strikethrough       => true,
      :superscript         => false,
      :tables              => true
    )
  end

  def <<(s)
    if s.strip =~ /^\s*<?!VIDEO +([^\s>]*)>?$/
      youtube_id = $1
      # see https://developers.google.com/youtube/player_parameters
      s = %Q(<iframe class="video youtube" type="text/html" width="640" height="390" src="http://www.youtube.com/embed/#{youtube_id}" frameborder="0"></iframe>\n)
    end
    @markdown_text << s
    @markdown_text << "\n"
  end

  def empty?
    @markdown_text.strip == ""
  end

  def title
    lines = @markdown_text.strip.split("\n")
    raise "an empty slide has no id" if lines.empty?
    lines.first.gsub(/^[#=]*/, '').strip
  end

  def slide_id
    @slide_id ||= begin
      title.downcase.gsub(/[^\w\s]/, '').strip.gsub(/\s/, '_')
    end
  end

  def content
    section :class => @classes, :id => slide_id do
      text "\n" # markdown HTML should be left-aligned, in case of PRE blocks and other quirks
      html = markdown.render(markdown_text)
      html = munge(html)
      rawtext html
    end
  end

  private

    # if there is an H1, change it to an H2, unless it's the only thing there
    # TODO: or unless the slide class is whatever
    def mutate_h1? doc
      h1s = doc.css('h1') || []
      if h1s.size == 0
        false
      else
        stuff = doc.css('body>*')
        if stuff.size == 1
          false
        else
          true
        end
      end
    end

    def munge html
      doc = noko_doc(html)
      if mutate_h1? doc
        doc.css('h1').each {|node| node.node_name = "h2"}
        doc.css('body').inner_html + "\n"
      else
        html
      end
    end

 end
end
