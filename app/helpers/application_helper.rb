# frozen_string_literal: true

module ApplicationHelper
  def navbar_link(text, url)
    button_classes = %w[button btn btn-default navbar-btn navbar-left]
    button_classes << 'current' if current_page? url
    link_to url do
      content_tag :button, text, class: button_classes
    end
  end

  def yes_no_image(value)
    icon_class = value ? 'glyphicon-ok' : 'glyphicon-remove'
    content_tag :span, nil, class: "glyphicon #{icon_class}"
  end

  def yes_image(value)
    icon_class = value ? 'glyphicon-ok' : ''
    content_tag :span, nil, class: "glyphicon #{icon_class}"
  end
end
