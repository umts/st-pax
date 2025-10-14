# frozen_string_literal: true

class ApplicationController < ActionController::Base
  helper_method :authenticated?

  before_action :check_primary_account
  before_action :set_current_user
  before_action :login_as_passenger
  before_action :require_authentication
  before_action :restrict_to_employee
  before_action :set_passenger_information

  def authenticated?
    Current.user.present? || @registrant.present?
  end

  private

  def deny_access
    if request.xhr?
      head :forbidden
    else
      file = authenticated? ? '403-no-access.html' : '403-no-account.html'

      render file: Rails.public_path.join(file), status: :forbidden
    end
  end

  def set_current_user
    Current.user =
      if session.key? :user_id
        User.active.find_by id: session[:user_id]
      elsif request.env.key? 'fcIdNumber'
        User.active.find_by spire: request.env['fcIdNumber']
      end
    session[:user_id] = Current.user.id if Current.user.present?
  end

  def login_as_passenger
    return if Current.user.present?

    @registrant =
      if session[:passenger_id]
        Passenger.find_by(id: session[:passenger_id])
      elsif request.env['fcIdNumber']
        find_or_initialize_passenger
      end

    session[:passenger_id] = @registrant&.id
  end

  def require_authentication
    return if authenticated?
    redirect_to dev_login_path and return if Rails.env.development?

    deny_access
  end

  def find_or_initialize_passenger
    passenger = Passenger.find_or_initialize_by(
      spire: request.env['fcIdNumber'],
      name: "#{request.env['givenName']} #{request.env['surName']}"
    )
    passenger.email = request.env['mail'] if passenger.new_record?
    passenger
  end

  def check_primary_account
    deny_access && return unless request.env['UMAPrimaryAccount'] == request.env['uid']
  end

  def restrict_to_admin
    deny_access && return unless Current.user&.admin?
  end

  def restrict_to_employee
    deny_access && return if Current.user.blank?
  end

  def set_passenger_information
    @pending = Passenger.pending.count
  end
end
