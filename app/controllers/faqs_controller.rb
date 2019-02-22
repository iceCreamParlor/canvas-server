class FaqsController < InheritedResources::Base

  def index
    @faqs = Faq.all.paginate(page: params[:page], per_page: Faq::PER_PAGE).order('created_at DESC')
  end

  private

    def faq_params
      params.require(:faq).permit(:title, :content, :user_id)
    end
end

