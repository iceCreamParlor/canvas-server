class MagazineCommentsController < ApplicationController

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

    if @magazine_comment.save
      @is_saved = true
    else
      @is_saved = false
    end
  end

  def edit
  end

  def update
  end

  
end
