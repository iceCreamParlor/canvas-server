class WebMagazinesController < ApplicationController
  before_action :get_web_magazines, only: [:index, :show]

  def index
   
    @paintings = Painting.last(3)

    # render template: 'web_magazines/index_mobile' if @is_mobile
    # render layout: 'layouts/customized_layout' if !@is_mobile

  end

  def show
    @web_magazine = WebMagazine.find(params[:id])
    @interviews_left = @web_magazine.interviews.where(position: "left")
    @interviews_right = @web_magazine.interviews.where(position: "right")

    @paintings = @web_magazine.paintings

  end

  private
    def get_web_magazines
      # @web_magazines = ConfigSetting.get_web_magazines
      @web_magazine_group = WebMagazineGroup.last
      @web_magazines = @web_magazine_group.web_magazines
    end
end
