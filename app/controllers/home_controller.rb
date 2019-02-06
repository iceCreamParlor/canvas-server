class HomeController < ApplicationController
  def index
    @paintings1 = Painting.all.sample(10).map{ |p| { 'id' => p.id, 'thumbnail' => p.thumbnail.url } }
    @paintings2 = Painting.all.select(:thumbnail).sample(10)
    @paintings3 = Painting.all.select(:thumbnail).sample(10)
    @magazines = Magazine.all.map{ |p| p.thumbnail }
  end
end
