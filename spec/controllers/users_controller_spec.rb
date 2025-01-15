# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController do
  context 'when the current user is not an admin' do
    before do
      when_current_user_is :anyone
    end

    it 'denies access to the index' do
      get :index
      expect(response).to have_http_status :forbidden
    end

    it 'denies access to show a user' do
      user = create(:user)
      get :show, params: { id: user.id }
      expect(response).to have_http_status :forbidden
    end

    it 'denies access to create a user' do
      put :create, params: { user: attributes_for(:user) }
      expect(response).to have_http_status :forbidden
    end

    it 'denies access to update a user' do
      user = create(:user)
      patch :update, params: { id: user.id, user: { name: 'New Name' } }
      expect(response).to have_http_status :forbidden
    end

    it 'denies access to destroy a user' do
      user = create(:user)
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status :forbidden
    end
  end
end
