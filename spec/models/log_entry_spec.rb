# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogEntry do
  describe '#entry_time' do
    it 'returns a string of created_at date and time' do
      log_entry = create(:log_entry, created_at: Time.zone.local(2017, 3, 16, 10, 30))
      expect(log_entry.entry_time).to eq('Thursday, March 16, 2017 — 10:30 am')
    end
  end
end
