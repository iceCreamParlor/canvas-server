class MagazineCommentsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_magazine_comment, only: [:destroy]

  def index
  end

  def show
  end

  def new
  end

  def create
    content = params[:content]
    magazine_id = params[:magazine_id].to_i
    user_id = params[:user_id].to_i

    @user = User.find(user_id)
    @magazine_comment = MagazineComment.new(content: content, magazine_id: magazine_id, user_id: user_id)
    @magazine = Magazine.find(magazine_id)

    @is_saved = @magazine_comment.save ? true : false

  end

  def edit
  end

  def update
  end

  def destroy
    @is_destroyed = false
    magazine_id = @magazine_comment.magazine_id
    if @magazine_comment.destroy
      @magazine_comments = MagazineComment.where(magazine_id: magazine_id).order("created_at ASC")
      @is_destroyed = true
    end
  end

  private
    def set_magazine_comment  
      @magazine_comment = MagazineComment.find(params[:id])
    end
end
