class NoticesController < InheritedResources::Base
  def index
    @notices = Notice.all.paginate(:page => params[:page], :per_page => Notice::PER_PAGE)
    @normal_magazines = Magazine.where(priority: "normal").order("created_at DESC")
    @head_magazines = Magazine.where(priority: "head").order("created_at DESC")
    @main_magazines = Magazine.where(priority: "main").order("created_at DESC")
    @painting_magazines = Magazine.where(magazine_type: "painting") - @head_magazines - @main_magazines
    @artist_magazines = Magazine.where(magazine_type: "artist") - @head_magazines - @main_magazines
  end
  private
  
    def notice_params
      params.require(:notice).permit(:title, :content)
    end
end

