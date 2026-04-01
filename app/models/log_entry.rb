# frozen_string_literal: true

class LogEntry < ApplicationRecord
  belongs_to :user

  validates :text, presence: true

  def entry_time
    created_at.strftime '%A, %B %e, %Y — %l:%M %P'
  end

  def self.to_export_csv
    CSV.generate headers: %w[text pinned spire created_at updated_at], write_headers: true do |csv|
      find_each do |log_entry|
        csv << {
          'text' => log_entry.text, 'pinned' => log_entry.pinned, 'spire' => log_entry.user.spire.chomp('@umass.edu'),
          'created_at' => log_entry.created_at.iso8601, 'updated_at' => log_entry.updated_at.iso8601
        }
      end
    end
  end
end
