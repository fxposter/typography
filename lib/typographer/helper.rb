# encoding: utf-8
require 'action_view'

module ActionView::Helpers::TextHelper
  def ty(text, type = :default)
    TypographerHelper.parse text.to_s, type
  end
end
