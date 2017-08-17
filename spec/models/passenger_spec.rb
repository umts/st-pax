require 'rails_helper'

describe Passenger do
  before :each do 
    @passenger = create :passenger
  end

  describe 'expiration_display' do 
    context 'permanent passenger' do 
      it "returns 'None'" do 
        @passenger.update permanent: true
        expect(@passenger.expiration_display).to eql 'None'
      end
    end
    context 'doctors note with expiration date' do 
      it 'returns the expiration date' do 
        date = 14.days.since
        doctors_note = create :doctors_note, passenger: @passenger,
                              expiration_date: date
        expect(@passenger.expiration_display).to eql date.strftime("%m/%d/%Y")
      end
    end
    context 'doctors note no expiration date' do 
      it "returns 'No Note'" do 
        doctors_note = create :doctors_note, passenger: @passenger
        expect(@passenger.expiration_display).to eql 'No Note'
      end
    end
    context 'no doctors note' do 
      it "returns 'No Note'" do 
        expect(@passenger.expiration_display).to eql 'No Note'
      end
    end
  end

  describe 'temporary?' do 
    it 'gets the not of permanent' do 
      expect(@passenger.temporary?).to eql true
    end
  end

  describe 'self.deactivate_expired_doc_note' do 
    it 'deactivates the expired passenger' do 
      doctors_note = create :doctors_note, passenger: @passenger,
                              expiration_date: 10.days.ago
      @passenger.update active: true
      Passenger.deactivate_expired_doc_note
      expect(@passenger.active).to eql false
    end
  end
end
