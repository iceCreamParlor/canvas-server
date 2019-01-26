class MagazinesController < InheritedResources::Base

  def index
    @magazines = Magazine.order("created_at DESC")
  end

  def show
    @magazine = Magazine.find(params[:id])
    @magazine_comments = MagazineComment.where(magazine_id: @magazine.id)
  end

  def new
    @magazine = Magazine.new
  end

  def create
    @magazine = Magazine.new(magazine_params)
    if @magazine.save
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
      params.require(:magazine).permit(:title, :content, :thumbnail, :user_id)
    end
end

