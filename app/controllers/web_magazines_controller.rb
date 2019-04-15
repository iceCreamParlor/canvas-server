class WebMagazinesController < ApplicationController
  before_action :get_web_magazines, only: [:index, :show]

  def index
   
  end

  def show
    @web_magazine = WebMagazine.find(params[:id])
    @paintings = @web_magazine.paintings
    @interviews_left = @web_magazine.interviews.where(position: "left")
    @interviews_right = @web_magazine.interviews.where(position: "right")
  end

  private
    def get_web_magazines
      # @web_magazines = ConfigSetting.get_web_magazines
      @web_magazine_group = WebMagazineGroup.last
      @web_magazines = @web_magazine_group.web_magazines
    end
end
