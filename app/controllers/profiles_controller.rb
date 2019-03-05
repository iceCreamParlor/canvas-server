class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:index, :follow, :register_sellers, :create_register_sellers]

  def index
  end

  def show
    @user_category = @user.user_categories
    @is_following = false
    
    @paintings = Painting.where(user_id: @user.id).exclude_images
    @paintings_json = []
    @paintings.each do |painting|
      # 수평선을 위한 json화
      painting_hash = Hash.new
      painting_hash['id'] = painting.id
      painting_hash['supertag'] = painting.category.name
      painting_hash['date'] = painting.completed_date.to_i * 1000
      painting_hash['content'] = painting.desc
      painting_hash['title'] = painting.name
      painting_hash['thumbnail'] = painting.thumbnail.url
      @paintings_json << painting_hash.to_json
    end

    @is_following = (user_signed_in? && current_user.is_following(@user)) ? true : false

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

  def register_sellers
    @register_seller = RegisterSeller.new
  end
  
  def create_register_sellers
    register_seller = RegisterSeller.new(register_seller_params)
    register_seller.user_id = current_user.id

    if register_seller.save
      flash[:notice] = "작가 신청을 완료하였습니다."
      redirect_to profiles_path
    else
      flash[:notice] = "작가 신청에 실패하였습니다."
      redirect_to profiles_path
    end
  end

  def accept_seller
    user = User.find(params[:id])
    register_seller = RegisterSeller.where(user_id: user.id)

    @is_confirmed = false
    if user.update(user_type: "seller")
      register_seller&.update(is_confirmed: true)
      @is_confirmed = true
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
    def register_seller_params
      params.require(:register_seller).permit({ images: [] })
    end
end
