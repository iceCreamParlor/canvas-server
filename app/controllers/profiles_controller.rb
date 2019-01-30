class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:index, :follow]

  def index
  end

  def show
    @user_category = @user.user_categories
    @is_following = false
    
    @paintings = Painting.where(user_id: @user.id)
    @paintings_json = []
    @paintings.each do |painting|
      painting_hash = Hash.new
      painting_hash['supertag'] = painting.category.name
      painting_hash['date'] = painting.completed_date.to_i * 1000
      painting_hash['content'] = painting.desc
      painting_hash['title'] = painting.name
      painting_hash['thumbnail'] = painting.thumbnail.url
      @paintings_json << painting_hash.to_json
    end
    # @painting_json = @painting_json.to_json

    if user_signed_in?
      if current_user.is_following(@user)
        @is_following = true
      end
      if current_user.id == @user.id
        @is_following = false
      end
      
    end

    @liked_paintings = Painting.where(id: @user.likes.pluck(:painting_id)).last(10).reverse
    @follow_members = @user.follow_members
    @following_members = @user.following_members
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
    follow = Follow.where(follower_id: follower_id, followed_id: followed_id)
    if follow.present?
      # 이미 팔로우 하고 있는 경우  
      follow.destroy_all
      @is_following = false
      
    else
      # 팔로우를 생성해야 하는 경우
      Follow.create(follower_id: follower_id, followed_id: followed_id)
      @is_following = true
    end
    @following_members_count = current_user.following_members.count
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    
end
