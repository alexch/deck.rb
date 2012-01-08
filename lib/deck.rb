require 'erector'

class Deck < Erector::Widgets::Page
  needs :title => "deck.rb presentation",
    :description => nil,
    :author => nil
  
  def page_title
    @title
  end
  
# left over from deck.js' introduction/index.html

# <!DOCTYPE html>

# <!--[if lt IE 7]> <html class="no-js ie6" lang="en"> <![endif]-->
# <!--[if IE 7]>    <html class="no-js ie7" lang="en"> <![endif]-->
# <!--[if IE 8]>    <html class="no-js ie8" lang="en"> <![endif]-->
# <!--[if gt IE 8]><!-->  <html class="no-js" lang="en"> <!--<![endif]-->

  # todo: promote into Page
  def stylesheet src, attributes = {}
    link {:rel => "stylesheet", :href => src}.merge({attributes})
  end

  def head_content
    super
    meta 'charset' => 'utf-8'
    meta 'http-equiv'=>"X-UA-Compatible", 'content'=>"IE=edge,chrome=1"
    meta :name=>"viewport", :content="width=1024, user-scalable=no"
    meta :name => "description", :content=> @description if @description
    meta :name => "author", :content=> @author if @author

    #  <!-- Core and extension CSS files -->
    stylesheet "deck/core/deck.core.css"
    stylesheet "deck/core/deck.core.css"
    stylesheet "deck/extensions/goto/deck.goto.css"
    stylesheet "deck/extensions/menu/deck.menu.css"
    stylesheet "deck/extensions/navigation/deck.navigation.css"
    stylesheet "deck/extensions/status/deck.status.css"
    stylesheet "deck/extensions/hash/deck.hash.css"
  
    # <!-- Theme CSS files (menu swaps these out) -->
    stylesheet "deck/themes/style/web-2.0.css", :id=>"style-theme-link"
    stylesheet "deck/themes/transition/horizontal-slide.css", :id => "transition-theme-link"
  
    # <!-- Custom CSS just for this page -->
    stylesheet "introduction.css"
  
    script :src=>"deck/modernizr.custom.js"
  end

  def body_attributes
    {:class=>"deck-container"}
  end

  def body_content
    theme_menu
    slides
    slide_navigation
    deck_status
    goto_slide
  end
  
  def theme_menu
    div :class => 'theme-menu' do
      h2 do
        text 'Themes'
      end
      label :for => 'style-themes' do
        text 'Style:'
      end
      select :id => 'style-themes' do
        option :selected => 'selected', :value => '../themes/style/web-2.0.css' do
          text 'Web 2.0'
        end
        option :value => '../themes/style/swiss.css' do
          text 'Swiss'
        end
        option :value => '../themes/style/neon.css' do
          text 'Neon'
        end
        option :value => '' do
          text 'None'
        end
      end
      label :for => 'transition-themes' do
        text 'Transition:'
      end
      select :id => 'transition-themes' do
        option :selected => 'selected', :value => '../themes/transition/horizontal-slide.css' do
          text 'Horizontal Slide'
        end
        option :value => '../themes/transition/vertical-slide.css' do
          text 'Vertical Slide'
        end
        option :value => '../themes/transition/fade.css' do
          text 'Fade'
        end
        option :value => '' do
          text 'None'
        end
      end
    end
  end

  def slides
    section :class => 'slide', :id => 'how-to-overview' do
      h2 do
        text 'How to Make a Deck'
      end
      ol do
        li do
          h3 do
            text 'Write Slides'
          end
          p do
            text 'Slide content is simple&nbsp;HTML.'
          end
        end
        li do
          h3 do
            text 'Choose Themes'
          end
          p do
            text 'One for slide styles and one for deck&nbsp;transitions.'
          end
        end
        li do
          h3 do
            text 'Include Extensions'
          end
          p do
            text 'Add extra functionality to your deck, or leave it stripped&nbsp;down.'
          end
        end
      end
    end
    section :class => 'slide', :id => 'markup' do
      h2 do
        text 'The Markup'
      end
      p do
        text 'Slides are just HTML elements with a class of'
        code do
          text 'slide'
        end
        text '.'
      end
      pre do
        code do
          text '<section class="slide">
<h2>How to Make a Deck</h2>
<ol>
<li>
<h3>Write Slides</h3>
<p>Slide content is simple HTML.</p>
</li>
<li>
<h3>Choose Themes</h3>
<p>One for slide styles and one for deck transitions.</p>
</li>
&hellip;
</ol>
</section>'
        end
      end
    end
    section :class => 'slide', :id => 'themes' do
      h2 do
        text 'Style Themes'
      end
      p do
        text 'Customizes the colors, typography, and layout of slide&nbsp;content.'
      end
      pre do
        code do
          text '<link rel="stylesheet" href="/path/to/css/style-theme.css">'
        end
      end
      h2 do
        text 'Transition Themes'
      end
      p do
        text 'Defines transitions between slides using CSS3 transitions.  Less capable browsers fall back to cutaways. But'
        strong do
          text 'you'
        end
        text 'aren&rsquo;t using'
        em do
          text 'those'
        end
        text 'browsers to give your presentations, are&nbsp;you&hellip;'
      end
      pre do
        code do
          text '<link rel="stylesheet" href="/path/to/css/transition-theme.css">'
        end
      end
    end
    section :class => 'slide', :id => 'extensions' do
      h2 do
        text 'Extensions'
      end
      p do
        text 'Core gives you basic slide functionality with left and right arrow navigation, but you may want more. Here are the ones included in this&nbsp;deck:'
      end
      ul do
        li :class => 'slide', :id => 'extensions-goto' do
          strong do
            text 'deck.goto'
          end
          text ': Adds a shortcut key to jump to any slide number.  Hit g, type in the slide number, and hit&nbsp;enter.'
        end
        li :class => 'slide', :id => 'extensions-hash' do
          strong do
            text 'deck.hash'
          end
          text ': Enables internal linking within slides, deep linking to individual slides, and updates the address bar & a permalink anchor with each slide&nbsp;change.'
        end
        li :class => 'slide', :id => 'extensions-menu' do
          strong do
            text 'deck.menu'
          end
          text ': Adds a menu view, letting you see all slides in a grid. Hit m to toggle to menu view, continue navigating your deck, and hit m to return to normal view. Touch devices can double-tap the deck to switch between&nbsp;views.'
        end
        li :class => 'slide', :id => 'extensions-navigation' do
          strong do
            text 'deck.navigation'
          end
          text ': Adds clickable left and right buttons for the less keyboard&nbsp;inclined.'
        end
        li :class => 'slide', :id => 'extensions-status' do
          strong do
            text 'deck.status'
          end
          text ': Adds a page number indicator. (current/total)'
        end
      end
      p :class => 'slide', :id => 'extension-folders' do
        text 'Each extension folder in the download package contains the necessary JavaScript, CSS, and HTML&nbsp;files. For a complete list of extension modules included in deck.js, check out the&nbsp;'
        a :href => 'http://imakewebthings.github.com/deck.js/docs' do
          text 'documentation'
        end
        text '.'
      end
    end
    section :class => 'slide', :id => 'nested' do
      h2 do
        text 'Nested Slides'
      end
      p do
        text 'That last slide had a few steps.  To create substeps in slides, just nest them:'
      end
      pre do
        code do
          text '<section class="slide">
<h2>Extensions</h2>
<p>Core gives you basic slide functionality...</p>		
<ul>
<li class="slide">
<h3>deck.goto</h3>
<p>Adds a shortcut key to jump to any slide number...</p>
</li>
<li class="slide">...</li>	
<li class="slide">...</li>
<li class="slide">...</li>
</ul>
</section>'
        end
      end
    end
    section :class => 'slide', :id => 'elements-images' do
      h2 do
        text 'Other Elements: Images'
      end
      img :src => 'http://placekitten.com/600/375', :alt => 'Kitties'
      pre do
        code do
          text '<img src="http://placekitten.com/600/375" alt="Kitties">'
        end
      end
    end
    section :class => 'slide', :id => 'elements-blockquotes' do
      h2 do
        text 'Other Elements: Blockquotes'
      end
      blockquote :cite => 'http://example.org' do
        p do
          text 'Food is an important part of a balanced diet.'
        end
        p do
          cite do
            text 'Fran Lebowitz'
          end
        end
      end
      pre do
        code do
          text '<blockquote cite="http://example.org">
<p>Food is an important part of a balanced diet.</p>
<p><cite>Fran Lebowitz</cite></p>
</blockquote>'
        end
      end
    end
    section :class => 'slide', :id => 'elements-videos' do
      h2 do
        text 'Other Elements: Video Embeds'
      end
      p do
        text 'Embed videos from your favorite online video service or with an HTML5 video&nbsp;element.'
      end
      iframe :src => 'http://player.vimeo.com/video/1063136?title=0&byline=0&portrait=0', :width => '400', :height => '225', :frameborder => '0' do
      end
      pre do
        code do
          text '<iframe src="http://player.vimeo.com/video/1063136?title=0&amp;byline=0&amp;portrait=0" width="400" height="225" frameborder="0"></iframe>'
        end
      end
    end
    section :class => 'slide', :id => 'digging-deeper' do
      h2 do
        text 'Digging Deeper'
      end
      p do
        text 'If you want to learn about making your own themes, extending deck.js, and more, check out the&nbsp;'
        a :href => '../docs/' do
          text 'documentation'
        end
        text '.'
      end
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
  
  def scripts
    comment 'Grab CDN jQuery, with a protocol relative URL; fall back to local if offline'
    script :src => '//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.min.js'
    script "window.jQuery || document.write('<script src=\"../jquery-1.7.min.js\"><\/script>')"

    comment 'Deck Core and extensions'    
    script :src => 'deck/core/deck.core.js'
    script :src => 'deck/extensions/hash/deck.hash.js'
    script :src => 'deck/extensions/menu/deck.menu.js'
    script :src => 'deck/extensions/goto/deck.goto.js'
    script :src => 'deck/extensions/status/deck.status.js'
    script :src => 'deck/extensions/navigation/deck.navigation.js'

    comment 'Specific to this page'
    script :src => 'introduction.js'
  end
end
