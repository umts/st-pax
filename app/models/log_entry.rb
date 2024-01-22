# frozen_string_literal: true

class LogEntry < ApplicationRecord
  belongs_to :user

  validates :text, presence: true

  def entry_time
    created_at.strftime '%A, %B %e, %Y — %l:%M %P'
  end
end
