module ActionView::Helpers::TextHelper
  def ty(text, options = {})
    Typography::Core.new(text.html_safe, options).typography
  end
  def ty_simple(text, html_options={})
    simple_format ty(text), html_options
  end
end
