# frozen_string_literal: true

module ApplicationHelper
  def navbar_link(text, url)
    button_classes = %w[button btn btn-default navbar-btn navbar-left]
    button_classes << 'current' if current_page? url
    link_to url do
      content_tag :button, text, class: button_classes
    end
  end

  def checkmark_glyph(value, yes: 'glyphicon-ok', no: 'glyphicon-remove')
    icon_class = value ? yes : no
    content_tag :span, nil, class: "glyphicon #{icon_class}"
  end
end
