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
