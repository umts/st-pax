# frozen_string_literal: true

class LogEntry < ApplicationRecord
  belongs_to :user

  validates :user, :text, presence: true

  self.per_page = 100

  def entry_time
    created_at.strftime '%A, %B %e, %Y — %l:%M %P'
  end
end
