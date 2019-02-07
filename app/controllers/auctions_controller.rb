class AuctionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :destroy]

  def index
    @auctions = Auction.all
  end

  def new
    @auction = Auction.new
    @paintings = Painting.where(user_id: current_user.id)
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
