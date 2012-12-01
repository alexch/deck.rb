require 'pygments'
require 'redcarpet'

module Deck
  class Renderer < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, :options => {:encoding => 'utf-8', :lexer => language})
    end
  end
end

