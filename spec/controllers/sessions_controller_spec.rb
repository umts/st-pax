# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController do
  describe 'dev_login' do
    before :each do
      @admin = create :user, :admin
      @dispatcher = create :user
    end
    context 'GET request' do
      let(:submit) { get :dev_login }
      it 'finds the users and passengers for display' do
        expect(User).to receive(:admins).and_return User.admins
        expect(User).to receive(:dispatchers).and_return User.dispatchers
        expect(Passenger).to receive :temporary
        submit
      end
    end
    context 'POST request' do
      context 'logging in as a user' do
        let(:submit) { post :dev_login, params: { user_id: @admin.id } }
        it 'redirects to the proper page' do
          submit
          expect(response).to redirect_to passengers_path
        end
      end
      context 'logging in as a passenger' do
        let(:submit) { post :dev_login }
        it 'redirects to the proper page' do
          submit
          expect(response).to redirect_to brochure_passengers_path
        end
      end
    end
  end
end
