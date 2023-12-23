# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up,
                                      keys: %i[username first_name last_name email password password_confirmation])
    devise_parameter_sanitizer.permit(:sign_in,
                                      keys: %i[username password password_confirmation])
    devise_parameter_sanitizer.permit(:account_update,
                                      keys: %i[first_name last_name email password_confirmation current_password])
  end

  def not_found
    raise ActionController::RoutingError, 'Page Not Found'
  end
end
