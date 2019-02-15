class RegisterController < ApplicationController
  before_action :set_user, only: [:info1, :info2, :infoget]
  # before_action :authenticate_user!
  # 카테고리 선택하기 추가
  def info1
  end

  def info2
  end

  def infoget
    # 이메일 있음
    if !@user.email.present?
      @user.email = params[:email]
      @user.nickname = params[:nickname]
      
    # 이메일 없음 = kakao
    else
      @user.nickname = params[:nickname]
    end
    @user.save
    redirect_to root_path
  end

  private
  def set_user
    @user = current_user
  end
end
