class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user

  # Returns the current logged-in user (if any).
  def current_user
    User.find(session[:user_id]) if session[:user_id]
  end

  private

  def error_message(errors)
    errors.full_messages.join(', ')
  end
end
