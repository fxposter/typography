module TypographyHelper

  def ty(str, options = {})
    str.typography(options)
  end

end

module ActionView::Helpers::TextHelper
  def simple_format_with_typography(text, html_options={})
    simple_format_without_typography(text.typography, html_options)
  end
  alias_method :simple_format_without_typography, :simple_format
  alias_method :simple_format, :simple_format_with_typography
end
