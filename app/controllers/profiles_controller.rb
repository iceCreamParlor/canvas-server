class ProfilesController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]

  def show
    @user_category = Category.where(id: @user.paintings.pluck(:category_id).uniq)
  end
  
  def edit
  end

  def update
  end

  private
    def set_user
      @user = User.find(params[:id])
    end
end
