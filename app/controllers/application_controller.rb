class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def require_admin
      # ... and return is correct here
      # rubocop:disable Style/AndOr
      head :unauthorized and return unless @current_user.admin?
      # rubocop:enable Style/AndOr
  end
  def set_current_user
    if session.key? :user_id
      @current_user = User.find_by id: session[:user_id]
    else
      @current_user = User.find_by spire: request.env['fcIdNumber']
      if @current_user.present?
        session[:user_id] = @current_user.id
      else redirect_to unauthenticated_session_path
      end
    end
  end
end
