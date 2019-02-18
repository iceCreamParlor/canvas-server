class UserMailer < ApplicationMailer
  default from: 'wearegreedyturtles@gmail.com'
 
  def message_arrived_email(user: , message: )
    @user = user
    if Rails.env.development?
      @url  = "127.0.0.1:3000/messages"
    elsif Rails.env.production?
      @url  = "#{ENV['BASE_URL']}/messages"
    end
    
    mail(to: @user.email, subject: '회원님에게 메세지가 도착했습니다(캔버스).')
  end
  
end
