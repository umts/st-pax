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

  def list_messages(messages)
    if messages.is_a? Array
      content_tag :ul do
        messages.each do |message|
          concat content_tag(:li, message)
        end
      end
    else
      messages
    end
  end
end
