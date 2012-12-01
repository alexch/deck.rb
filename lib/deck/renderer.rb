require 'pygments'
require 'redcarpet'

module Deck
  class Renderer < Redcarpet::Render::HTML
    def block_code(code, language)
      if language
        Pygments.highlight(code, :options => {:encoding => 'utf-8', :lexer => language})
      else
        "<pre>%s</pre>" % code
      end
    end
  end
end

