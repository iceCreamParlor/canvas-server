class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:index]

  def index
  end

  def show
    @user_category = @user.user_categories
  end
  
  def edit
  end

  def update
    image = params[:image]
    instagram = params[:instagram]
    desc = params[:desc]
    nickname = params[:nickname]
    user = User.find(params[:id])
    user.update(image: image, nickname: nickname, desc: desc, instagram: instagram)
    redirect_to profile_path(user.id)
  end

  def follow
    follower_id = params[:follower_id]
    followed_id = params[:followed_id]
    Follow.create(follower_id: follower_id, followed_id: followed_id)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    
end
