# frozen_string_literal: true

module ApplicationHelper
  def navbar_link(text, url)
    button_classes = %w[button btn btn-default navbar-btn navbar-left]
    button_classes << 'current' if current_page? url
    link_to url do
      content_tag :button, text, class: button_classes
    end
  end

  def checkmark_glyph(value, yes: 'fa-check', no: 'fa-times')
    icon_class = value ? ['yes-glyph', yes] : ['no-glyph', no]
    content_tag :span, nil, class: icon_class << 'fas'
  end
end
