# frozen_string_literal: true

require 'rails_helper'

describe LogEntry do
  describe 'entry_time' do
    it 'returns a string of created_at date and time' do
      time = '10:30 am, Thursday, March 16, 2017'
      Timecop.freeze(Time.local(2017, 0o3, 16, 10, 30, 0)) do 
        log_entry = create :log_entry
        expect(log_entry.entry_time).to eql time
      end
    end
  end
end