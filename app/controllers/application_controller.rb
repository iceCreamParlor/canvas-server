class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_sns

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :image, :instagram, :desc])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :image, :instagram, :desc])
  end
  def check_sns
    @is_sns = false
    if user_signed_in? 
      if Identity.find_by(user_id: current_user.id).present?
        @is_sns = true
      end
    end
    @is_mobile = mobile_device?
  end
  def mobile_device?
    agent = request.user_agent
    return true if agent =~ /(tablet|ipad)|(android(?!.*mobile))/i
    return true if agent =~ /Mobile/
    return false
  end
  def recent_paintings
    session[:recent_paintings] ||= []
    if session[:recent_paintings].count > 8
      session[:recent_paintings].delete_at(0)
    end
    @recent_paintings = session[:recent_paintings].map{ |id| Painting.find(id) }
  end
end
