# frozen_string_literal: true

require 'rails_helper'

describe User do
  before :each do
    @user = create :user, :admin
  end

  describe 'dispatcher?' do
    it 'gets the not of admin' do
      expect(@user.dispatcher?).to eql false
    end
  end

  describe 'can_delete?' do 
    context 'when admin' do 
      it 'returns true' do 
        item = create :log_entry
        expect(@user.can_delete?(item)).to eql true
      end
    end
    context 'when dispatcher' do 
      before :each do 
        @user = create :user
      end
      context 'with a log entry' do 
        context 'associated to the user' do
          it 'returns false' do 
            item = create :log_entry
            expect(@user.can_delete?(item)).to eql false
          end
        end
        context 'not associated to the user' do 
          it 'returns true' do 
            item = create :log_entry, user: @user
            expect(@user.can_delete?(item)).to eql true
          end
        end
      end
      context 'without a log entry' do 
        it 'returns false' do 
          item = create :passenger
          expect(@user.can_delete?(item)).to eql false
        end
      end
    end
  end
end
