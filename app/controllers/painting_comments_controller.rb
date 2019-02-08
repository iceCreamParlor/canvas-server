class PaintingCommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :set_painting_comment, only: [:destroy, :update]

  def index
  end

  def show
  end

  def new
  end

  def create
    content = params[:content]
    painting_id = params[:painting_id].to_i
    user_id = current_user.id

    @user = current_user
    @painting_comment = PaintingComment.new(content: content, painting_id: painting_id, user_id: user_id)
    @painting = Painting.find(painting_id)

    if @painting_comment.save
      @is_saved = true
    else
      @is_saved = false
    end
  end

  def edit
  end

  def update
  end
  
  def destroy
    @is_destroyed = false
    painting_id = @painting_comment.painting_id
    if @painting_comment.destroy
      @painting_comments = PaintingComment.where(painting_id: painting_id).order("created_at ASC")
      @is_destroyed = true
    end
  end

  private
    def set_painting_comment
      @painting_comment = PaintingComment.find(params[:id])
    end
end
