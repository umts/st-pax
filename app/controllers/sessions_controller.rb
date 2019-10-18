# frozen_string_literal: true

class SessionsController < ApplicationController
  layout false
  skip_before_action :access_control, :check_primary_account, :set_current_user, :login_as_passenger

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
      if find_user
        redirect_to passengers_path and return
      end
      set_passenger
      redirect_to register_passengers_path and return
    end
  end

  private

  def find_user
    user = User.find_by(id: params[:user_id])
    session[:user_id] = user.id if user.present?
  end

  def set_passenger
    passenger = Passenger.find_by(id: params[:passenger_id])
    session[:passenger_id] = passenger.id if passenger.present?
  end

  def new_spire
    if Passenger.any?
      (Passenger.pluck(:spire).map(&:to_i).max + 1).to_s.rjust(8, '0') + '@umass.edu'
    else
      '00000000@umass.edu'
    end
  end
end
