# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the PassengersHelper. For example:
#
# describe PassengersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe PassengersHelper do
  describe 'passengers_table_row_class' do
    before :each do
      @passenger = create :passenger, :temporary, :with_note
      @doctors_note = @passenger.doctors_note
    end
    context 'will expire within warning period' do
      it "returns 'will_expire_soon'" do
        @doctors_note.update expiration_date: 5.days.since
        expect(helper.passengers_table_row_class(@passenger)).to eql 'will_expire_soon'
      end
    end
    context 'expired withing graced period' do
      it "returns 'expired_within_grace_period'" do
        @doctors_note.update expiration_date: 1.day.ago
        expect(helper.passengers_table_row_class(@passenger))
          .to eql 'expired_within_grace_period'
      end
    end
    context 'expired' do
      it "returns 'inactive'" do
        @doctors_note.update expiration_date: 10.days.ago
        expect(helper.passengers_table_row_class(@passenger)).to eql 'inactive'
      end
    end
    context 'no note' do
      it "returns 'no_note'" do
        @passenger = create :passenger, :temporary, :no_note
        expect(helper.passengers_table_row_class(@passenger)).to eql 'no_note'
      end
    end
  end

  describe 'passengers_table_class' do
    context 'current user is admin' do
      it 'returns admin class' do
        user = create :user, :admin
        assign(:current_user, user)
        expect(helper.passengers_table_class).to eql 'row-border admin-table'
      end
    end
    context 'current user is not admin' do
      it 'returns dispatcher class' do
        user = create :user
        assign(:current_user, user)
        expect(helper.passengers_table_class).to eql 'row-border dispatch-table'
      end
    end
  end
end
