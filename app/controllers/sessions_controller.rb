# frozen_string_literal: true

class SessionsController < ApplicationController
  layout false
  skip_before_action :access_control, :check_primary_account, :set_current_user

  def destroy
    session.clear
    if Rails.env.production?
      redirect_to '/Shibboleth.sso/Logout?return=https://webauth.umass.edu/Logout'
    else redirect_to dev_login_path
    end
  end

  # route not defined in production
  def dev_login
    if request.get?
      @admins = User.admins.order :name
      @dispatchers = User.dispatchers.order :name
    elsif request.post?
      find_user
      redirect_to passengers_path
    end
  end

  private

  def find_user
    user = User.find_by(id: params.require(:user_id))
    session[:user_id] = user.id
  end
end
