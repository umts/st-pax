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
end
