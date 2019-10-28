# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogEntry do
  describe 'entry_time' do
    it 'returns a string of created_at date and time' do
      time = 'Thursday, March 16, 2017 — 10:30 am'
      Timecop.freeze(Time.zone.local(2017, 3, 16, 10, 30)) do
        log_entry = create :log_entry
        expect(log_entry.entry_time).to eql time
      end
    end
  end
end
