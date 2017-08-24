class LogEntry < ApplicationRecord
  belongs_to :user

  validates :user, :text, presence: true

  def entry_time
    created_at.strftime '%A, %B %e, %Y — %l:%M %P'
  end
end
