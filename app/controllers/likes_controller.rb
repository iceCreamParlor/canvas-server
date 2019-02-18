class LikesController < ApplicationController
  before_action :set_like, only: [:toggle_like]
  before_action :authenticate_user!

  def toggle_like
    
    if @like.present?
      # 기존의 @like 가 있을 경우, @like 를 삭제한다.
      @is_destroyed = @like.destroy ? true : false
    else
      # 기존의 @like 가 없을 경우, @like 를 생성한다.
      painting_id = params[:painting_id].to_i
      user_id = current_user.id
      @like = Like.where(painting_id: painting_id, user_id: user_id).first_or_initialize do |like|
        like.painting_id = painting_id
        like.user_id = user_id
      end
      @is_saved = @like.save ? true : false
      
    end
    
    @like_cnt = @like.painting.likes.count
    
  end

  private
    def set_like
      painting_id = params[:painting_id].to_i
      @like = Like.find_by(painting_id: painting_id, user_id: current_user.id)
    end 
end
