# frozen_string_literal: true

module ApplicationHelper
  def navbar_link(text, url)
    button_classes = %w[mx-2 nav-link btn btn-outline-secondary]
    button_classes << 'active' if current_page? url
    link_to text, url, class: button_classes
  end

  def checkmark_glyph(value, yes: 'fa-check', no: 'fa-times')
    icon_class = value ? ['yes-glyph', yes] : ['no-glyph', no]
    content_tag :span, nil, class: icon_class << 'fas'
  end
end
