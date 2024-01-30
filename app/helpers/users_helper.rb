# frozen_string_literal: true

module UsersHelper
  def staff_titles_and_names
    User.active.where.not(title: [nil, '']).group_by(&:title).map do |title, users|
      [title.pluralize(users.size), users.map(&:name).to_sentence]
    end
  end
end
