# frozen_string_literal: true

module ApplicationHelper
  def map_project_url
    'https://www.google.com/maps/d/u/0/viewer' \
      '?ll=42.38924848859173%2C-72.52462826539438&z=16' \
      '&mid=1xXU7Hvn0xGzwQbmdNgn-W87bgg8'
  end

  def new_passenger_link_text
    return 'Add New Passenger' if @current_user.present?
    return 'Edit Registration' if @registrant&.persisted?

    "Register for #{t 'department.name'}"
  end

  def checkmark_glyph(value, options = {})
    options.reverse_merge!({ yes: 'fa-check', no: 'fa-xmark' })
    word = value ? 'yes' : 'no'

    capture do
      concat content_tag :span, nil,
                         class: ['fa-solid', "#{word}-glyph", options.fetch(word.to_sym)],
                         aria: { hidden: 'true' }, title: word
      concat content_tag :span, word, class: 'visually-hidden'
    end
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
