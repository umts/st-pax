class LogEntry < ApplicationRecord
  belongs_to :user

  validates :user, :text, presence: true

  def entry_time
    created_at.strftime '%l:%M %P, %A, %B %e, %Y'
  end
end
