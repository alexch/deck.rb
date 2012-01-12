require 'erector'
here = File.expand_path(File.dirname(__FILE__))
require "#{here}/deck"

class Introduction < Deck
  
  needs :title => "Getting Started with deck.js",
    :description => "A jQuery library for modern HTML presentations",
    :author => "Caleb Troughton"

  def head_content
    super
    # <!-- Custom CSS just for this page -->
    # (this is really just for the theme menu, so we'll leave it in the parent)
    # stylesheet "deck.js/introduction/introduction.css"
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
            text 'Slide content is simple', entity('nbsp'), 'HTML.'
          end
        end
        li do
          h3 do
            text 'Choose Themes'
          end
          p do
            text 'One for slide styles and one for deck', entity('nbsp'), 'transitions.'
          end
        end
        li do
          h3 do
            text 'Include Extensions'
          end
          p do
            text 'Add extra functionality to your deck, or leave it stripped', entity('nbsp'), 'down.'
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
        text 'Customizes the colors, typography, and layout of slide', entity('nbsp'), 'content.'
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
        text 'Defines transitions between slides using CSS3 transitions.  Less capable browsers fall back to cutaways. But '
        strong do
          text 'you'
        end
        text ' aren', entity('rsquo'), 't using '
        em do
          text 'those'
        end
        text ' browsers to give your presentations, are', entity('nbsp'), 'you', entity('hellip'), '?'
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
        text 'Core gives you basic slide functionality with left and right arrow navigation, but you may want more. Here are the ones included in this', entity('nbsp'), 'deck:'
      end
      ul do
        li :class => 'slide', :id => 'extensions-goto' do
          strong do
            text 'deck.goto'
          end
          text ': Adds a shortcut key to jump to any slide number.  Hit g, type in the slide number, and hit', entity('nbsp'), 'enter.'
        end
        li :class => 'slide', :id => 'extensions-hash' do
          strong do
            text 'deck.hash'
          end
          text ': Enables internal linking within slides, deep linking to individual slides, and updates the address bar & a permalink anchor with each slide', entity('nbsp'), 'change.'
        end
        li :class => 'slide', :id => 'extensions-menu' do
          strong do
            text 'deck.menu'
          end
          text ': Adds a menu view, letting you see all slides in a grid. Hit m to toggle to menu view, continue navigating your deck, and hit m to return to normal view. Touch devices can double-tap the deck to switch between', entity('nbsp'), 'views.'
        end
        li :class => 'slide', :id => 'extensions-navigation' do
          strong do
            text 'deck.navigation'
          end
          text ': Adds clickable left and right buttons for the less keyboard', entity('nbsp'), 'inclined.'
        end
        li :class => 'slide', :id => 'extensions-status' do
          strong do
            text 'deck.status'
          end
          text ': Adds a page number indicator. (current/total)'
        end
      end
      p :class => 'slide', :id => 'extension-folders' do
        text 'Each extension folder in the download package contains the necessary JavaScript, CSS, and HTML', entity('nbsp'), 'files. For a complete list of extension modules included in deck.js, check out the', entity('nbsp'), ''
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
        text 'Embed videos from your favorite online video service or with an HTML5 video', entity('nbsp'), 'element.'
      end
      # iframe :src => 'http://player.vimeo.com/video/1063136?title=0&byline=0&portrait=0', :width => '400', :height => '225', :frameborder => '0'
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
        text 'If you want to learn about making your own themes, extending deck.js, and more, check out the', entity('nbsp'), ''
        a :href => '../docs/' do
          text 'documentation'
        end
        text '.'
      end
    end
  end
  
  def scripts
    super
    comment 'Specific to this page'
    script :src => 'deck.js/introduction/introduction.js'
  end
end
