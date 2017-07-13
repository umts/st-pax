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

  def dev_login # route not defined in production
    if request.get?
      @admins = User.where(admin: true)
      @dispatchers = User.where(admin: false)
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
