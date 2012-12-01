require 'albino'
require 'redcarpet'

module Deck
  class Renderer < Redcarpet::Render::HTML
    def block_code(code, language)
      Albino.colorize(code, language)
    end
  end
end

