class FaqsController < InheritedResources::Base

  private

    def faq_params
      params.require(:faq).permit(:title, :content, :user_id)
    end
end

