# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_current_user
  before_action :login_as_passenger
  before_action :access_control
  before_action :check_primary_account

  private

  def deny_access
    if request.xhr?
      head :unauthorized
    else
      render file: 'public/401.html',
             status: :unauthorized,
             layout: false
    end
  end

  # Disable ABC size because this block will likely be
  # changed in a later branch
  # rubocop:disable AbcSize
  def set_current_user
    @current_user =
      if session.key? :user_id
        User.find_by id: session[:user_id]
      elsif request.env.key? 'fcIdNumber'
        User.find_by spire: request.env['fcIdNumber']
      end
    session[:user_id] = @current_user.id if @current_user.present?
  end
  # rubocop:enable AbcSize

  def login_as_passenger
    return if @current_user.present?

    @registrant =
      if session[:passenger_id]
        Passenger.find_by(id: session[:passenger_id])
      elsif request.env.key?('fcIdNumber')
        Passenger.new(
          spire: "#{request.env['fcIdNumber']}@umass.edu",
          name: "#{request.env['givenName']} #{request.env['surName']}",
          email: request.env['mail']
        )
      end
    session[:passenger_id] = @registrant&.id
  end

  # '... and return' is the correct behavior here, disable rubocop warning
  # rubocop:disable Style/AndOr
  def show_errors(object)
    flash[:errors] = object.errors.full_messages
    redirect_back(fallback_location: 'public/404.html') and return
  end
  # rubocop:enable Style/AndOr

  def check_primary_account
    return if request.env['UMAPrimaryAccount'] == request.env['uid']

    @primary_account = request.env['UMAPrimaryAccount']
    @uid = request.env['uid']
    render 'sessions/unauthenticated_subsidiary',
           status: :unauthorized,
           layout: false
  end

  def access_control
    deny_access && return unless @current_user&.admin?
  end
end
