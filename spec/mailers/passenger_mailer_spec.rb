#frozen_string_literal: true

require 'rails_helper'

RSpec.describe PassengerMailer do

  describe '.send_brochure' do

    before :each do
      @passenger = create :passenger
      @from_add = PassengerMailer.default[:from]
    end

    let :output do
      PassengerMailer.send_brochure(@passenger)
    end

    it 'emails from correct value' do
      expect(output.from).to eql Array(@from_add)
    end

    it 'emails correct passenger' do
      expect(output.to).to eql Array(@passenger.email)
    end

    it 'has correct subject' do
      expect(output.subject).to eql 'Your UMass Transit Account'
    end

  end
end
