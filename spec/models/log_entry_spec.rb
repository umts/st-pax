require 'rails_helper' 

describe LogEntry do 
  describe 'entry_time' do 
    before do 
      Timecop.freeze(Time.local(2017, 03, 16, 10, 30, 0))
    end
    after do 
      Timecop.return
    end
    it 'returns a string of created_at date and time' do 
      time = "10:30 am, Thursday, March 16, 2017"
      log_entry = create :log_entry
      expect(log_entry.entry_time).to eql time
    end
  end
end