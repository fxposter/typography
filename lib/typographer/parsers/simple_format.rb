# encoding: utf-8
require 'action_view'

module TypographerHelper
  module Parsers
    class SimpleFormat
      include ActionView::Helpers::TextHelper
      include ActionView::Helpers::TagHelper

      def initialize(options = {})
        @options = options
      end

      def parse(string)
        self.simple_format string, @options
      end
    end
  end
end
