class LikesController < ApplicationController
  before_action :set_like, only: [:toggle_like]
  before_action :authenticate_user!

  def toggle_like
    if @like.present?
      @like.destroy
      if @like.destroyed?
        @is_destroyed = true
      else
        @is_destroyed = false
      end
    else
      painting_id = params[:painting_id].to_i
      user_id = current_user.id
      @like = Like.where(painting_id: painting_id, user_id: user_id).first_or_initialize do |like|
        like.painting_id = painting_id
        like.user_id = user_id
      end
  
      if @like.save
        @is_saved = true
      else
        @is_saved = false
      end
    end
  end

  private
    def set_like
      puts "SET"
      painting_id = params[:painting_id].to_i
      @like = Like.find_by(painting_id: painting_id, user_id: current_user.id)
    end 
end
