class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_sns
  before_action :check_app, :app?
  
  helper_method :get_cart

  # ApplicationController 에 현재 접속된 클라이언트의 플랫폼을 분류하는 코드 작성
  # by heej (2019.02.02)

  protected

  def get_cart
    order = current_user.orders.carts.first_or_create
  end

  def configure_permitted_parameters
    # FOR DEVISE
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :image, :instagram, :desc])
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :image, :instagram, :desc])
  end

  def check_sns
    # @is_sns = (user_signed_in? && Identity.find_by(user_id: current_user.id).present?) ? true : false
    @is_mobile = mobile_device?

    @is_sns = (user_signed_in? && Identity.find_by(user_id: current_user.id).present?) ? true : false

    # @is_sns = false
    # if user_signed_in? 
    #   if Identity.find_by(user_id: current_user.id).present?
    #     @is_sns = true
    #   end
    # end
    
  end
  def mobile_device?
    # 단순히 모바일 디바이스인지를 판별한다 (웹 브라우저의 경우, 여기에서 true가 반환됨)
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

  def check_app
    # 모바일 앱인지 / 브라우저인지 확인하는 함수
    if params[:platform].present?
      # 네이티브 앱에서 넘겨받는 platform 파라미터가 있다면
      if %w[ios android].include?(params[:platform])
        cookies[:platform] = params[:platform]
      else
        cookies[:platform] = nil
      end
    end
  end

  def ios?
    cookies[:platform] == "ios"
  end

  def android?
    cookies[:platform] == "android"
  end

  def app?
    # 앱인지 확인하는 함수이다. (모바일 브라우저에서는 false 가 반환됨)
    @is_app = %w[ios android].include? cookies[:platform]
  end

end
