class MagazinesController < InheritedResources::Base
  before_action :authenticate_user!, only: [:new, :create, :edit, :update]

  def index
    @normal_magazines = Magazine.where(priority: "normal").order("created_at DESC")
    @head_magazines = Magazine.where(priority: "head").order("created_at DESC")
    @main_magazines = Magazine.where(priority: "main").order("created_at DESC")
    @painting_magazines = Magazine.where(magazine_type: "painting") - @head_magazines - @main_magazines
    @artist_magazines = Magazine.where(magazine_type: "artist") - @head_magazines - @main_magazines
    @paintings = Painting.last(3)
    
    # render layout: 'layouts/customized_layout', template: 'magazines/index_mobile' if @is_mobile
    # render layout: 'layouts/customized_layout' if !@is_mobile

  end

  def show
    @magazine = Magazine.find(params[:id])
    @magazine_comments = MagazineComment.where(magazine_id: @magazine.id).order("created_at DESC")
    
    render layout: 'layouts/customized_layout'
  end

  def new
    @magazine = Magazine.new
  end

  def create
    @magazine = Magazine.new(magazine_params)
    
    if @magazine.save!
      redirect_to magazines_path, notice: "The article has been successfully created."
    else
      render action: "new"
    end
  end

  def edit
    @magazine = Magazine.find(params[:id])
  end

  def update
    @magazine = Magazine.find(params[:id])
    if @magazine.update_attributes(magazine_params)
      redirect_to magazines_path, notice: "The article has been successfully updated."
    else
      render action: "edit"
    end
  end

  private
    def magazine_params
      params.require(:magazine).permit(:title, :content, :thumbnail, :user_id, :magazine_type, :priority)
    end
end

