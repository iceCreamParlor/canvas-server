class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_sns

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname])
  end
  def check_sns
    @is_sns = false
    if user_signed_in? 
      if Identity.find_by(user_id: current_user.id).present?
        @is_sns = true
      end
    end
  end
end
