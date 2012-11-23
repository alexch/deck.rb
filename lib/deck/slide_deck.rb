require 'erector'
require 'redcarpet'

require "deck/slide"

module Deck
 class SlideDeck < Erector::Widgets::Page
  needs :title => "deck.rb presentation",
    :description => nil,
    :author => nil
  needs :extensions => [
      'goto',
      'menu',
      'navigation',
      'status',
      'hash',
      'scale',
    ]
  needs :slides => nil

  needs :style_theme => "swiss"
  needs :transition_theme => "horizontal-slide"

  attr_reader :extensions

  def page_title
    @title
  end

  # todo: promote into Text
  # todo: support numbers a la '&#1234;'
  def entity entity_id
    raw("&#{entity_id};")
  end

# left over from deck.js' introduction/index.html

# <!DOCTYPE html>
# <!--[if lt IE 7]> <html class="no-js ie6" lang="en"> <![endif]-->
# <!--[if IE 7]>    <html class="no-js ie7" lang="en"> <![endif]-->
# <!--[if IE 8]>    <html class="no-js ie8" lang="en"> <![endif]-->
# <!--[if gt IE 8]><!-->  <html class="no-js" lang="en"> <!--<![endif]-->

  # todo: promote into Page
  def stylesheet src, attributes = {}
    link({:rel => "stylesheet", :href => src}.merge(attributes))
  end

  def public_asset path
    "/#{path}"
  end

  def head_content
    super
    meta 'charset' => 'utf-8'
    meta 'http-equiv'=>"X-UA-Compatible", 'content'=>"IE=edge,chrome=1"
    meta :name => "viewport", :content=> "width=1024, user-scalable=no"
    meta :name => "description", :content=> @description if @description
    meta :name => "author", :content=> @author if @author

    #  <!-- Core and extension CSS files -->
    stylesheet public_asset("deck.js/core/deck.core.css")
    extensions.each do |extension|
      stylesheet public_asset("deck.js/extensions/#{extension}/deck.#{extension}.css")
    end

    # <!-- Theme CSS files -->
    stylesheet public_asset("deck.js/themes/style/#{@style_theme}.css"), :id=>"style-theme-link"
    stylesheet public_asset("deck.js/themes/transition/#{@transition_theme}.css"), :id=>"transition-theme-link"

    stylesheet public_asset("coderay.css")
    stylesheet public_asset("tables.css")
    stylesheet public_asset("toc.css")
  end

  def scripts
    script :src => public_asset("deck.js/modernizr.custom.js")

    # comment 'Grab CDN jQuery, with a protocol relative URL; fall back to local if offline'
    # script :src => '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.2.min.js'
    script :src => public_asset('deck.js/jquery-1.7.2.min.js')

    jquery <<-JAVASCRIPT
    $('.slide_toc .toggle').click(function(){
      $('.slide_toc ul').toggle();
    });
    JAVASCRIPT

    comment 'Deck Core and extensions'
    script :type => "text/javascript", :src => public_asset('deck.js/core/deck.core.js')

    extensions.each do |extension|
      script :type => "text/javascript", :src => public_asset("deck.js/extensions/#{extension}/deck.#{extension}.js")
    end

    # fire up deck.js
    script "$(function(){$.deck('.slide');});"

  end

  def body_attributes
    {:class=>"deck-container"}
  end

  def body_content
    slides
    slide_navigation
    toc
    deck_status
    goto_slide
    permalink
    scripts
  end

  def slide slide_id
    # todo: use Slide object, but without markdown
    # slide = Slide.new(:slide_id => slide_id)
    section.slide :id => slide_id do
      yield
    end
  end

  def slides
    if @slides
      @slides.each do |slide|
        widget slide
      end
    else
      default_slide
    end
  end

  def default_slide
    slide 'readme' do
      h2 "deck.rb"
      ul {
        li "based on deck.js"
        li "create a subclass of Deck (see introduction.rb)"
        li "run erector to build it"
      }
      pre "erector --to-html ./deck.rb  # generates deck.html"
    end
  end

  def slide_navigation
    a :href => '#', :class => 'deck-prev-link', :title => 'Previous' do
      character 8592
    end
    a :href => '#', :class => 'deck-next-link', :title => 'Next' do
      character 8594
    end
  end

  def toc
    div.slide_toc do
      div.toggle "[toc]"
      ul do
        if @slides
          @slides.each do |slide|
            li do
              a slide.title, :href => "##{slide.slide_id}"
            end
          end
        end
      end
    end
  end

  def deck_status
    p :class => 'deck-status' do
      span :class => 'deck-status-current' do
      end
      text '/'
      span :class => 'deck-status-total' do
      end
    end
  end

  def goto_slide
    form :action => '.', :method => 'get', :class => 'goto-form' do
      label :for => 'goto-slide' do
        text 'Go to slide:'
      end
      input :type => 'text', :name => 'slidenum', :id => 'goto-slide', :list => 'goto-datalist'
      datalist :id => 'goto-datalist' do
        end
      input :type => 'submit', :value => 'Go'
    end
  end

  def permalink
    a "#", :href => '.', :title => 'Permalink to this slide', :class => 'deck-permalink'
  end

 end
end
