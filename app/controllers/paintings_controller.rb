class PaintingsController < ApplicationController
  before_action :set_options, only: [:new, :edit]
  before_action :set_painting, only: [:show, :edit, :update, :destroy]
  before_action :recent_paintings , only: [:index, :show, :new, :edit]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /paintings
  # GET /paintings.json
  def index
    
    @categories = Category.all
    @colors = Color.all
    @prices = Price.all.order(:value)

    @is_filtering = false
    # 필터링을 하는 경우
    if params[:category_id].present?
      
      @is_filtering = true
      @paintings = Painting.where(category_id: params[:category_id])
    end

    if params[:price_id].present?
      
      price = Price.find(params[:price_id][0])
      
      cheap_price = @prices.index(price) == 0 ? nil : @prices[@prices.index(price)-1]
      
      if @paintings.present? && cheap_price.present?
        
        @paintings = @paintings.where("price <= ? AND price > ?", price.value, cheap_price.value)
      elsif cheap_price.present? 
        
        @paintings = Painting.where("price <= ? AND price > ?", price.value, cheap_price.value)
      else
        @paintings = Painting.where("price <= ?", price.value)
      end
      
      @is_filtering = true
      
    end

    if params[:color_id].present?
      if @paintings.present?
        @paintings = @paintings.where(color_id: params[:color_id])
      else 
        @paintings = Painting.where(color_id: params[:color_id])
      end
      @is_filtering = true
    end
    if @is_filtering
      @paintings = @paintings .paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
    end
    if params[:refresh].present?
      @need_refresh = true
    else 
      @need_refresh = false
    end
    
    # 필터링을 하지 않는 경우
    if !@is_filtering
      @paintings = Painting.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
    end
    # @paintings = Painting.all.order(created_at: :desc)

    

    respond_to do |format|
      format.html
      format.js
    end

  end

  # GET /paintings/1
  # GET /paintings/1.json
  def show
    session[:recent_paintings] << @painting.id
    
    @user = @painting.user
    @user_category = @user.user_categories

    @is_following = false
    if user_signed_in?
      if current_user.is_following(@user)
        @is_following = true
      end
      if current_user.id == @user.id
        @is_following = false
      end
      @like = Like.where(user_id: current_user.id, painting_id: @painting.id)
    end
  end

  # GET /paintings/new
  def new
  end

  # GET /paintings/1/edit
  def edit
  end

  # POST /paintings
  # POST /paintings.json
  def create
    completed_date = Time.at(params[:painting][:completed_date].to_i)
    @painting = Painting.new(painting_params)
    @painting.completed_date = completed_date
    @painting.user_id = current_user.id

    respond_to do |format|
      if @painting.save
        format.html { redirect_to @painting, notice: 'Painting was successfully created.' }
        format.json { render :show, status: :created, location: @painting }
      else
        format.html { render :new }
        format.json { render json: @painting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /paintings/1
  # PATCH/PUT /paintings/1.json
  def update

    completed_date = Time.at(params[:painting][:completed_date].to_i)
    @painting.completed_date = completed_date

    respond_to do |format|
      if @painting.update(painting_params)
        format.html { redirect_to @painting, notice: 'Painting was successfully updated.' }
        format.json { render :show, status: :ok, location: @painting }
      else
        format.html { render :edit }
        format.json { render json: @painting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /paintings/1
  # DELETE /paintings/1.json
  def destroy
    @painting.destroy
    respond_to do |format|
      format.html { redirect_to paintings_url, notice: 'Painting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_options
      @painting = Painting.new
      @options_for_category = []
      @options_for_color = []
      Category.all.each do |c|
        @options_for_category << [c.name, c.id]
      end
      Color.all.each do |c|
        @options_for_color << [c.name, c.id]
      end
    end
    def set_painting
      @painting = Painting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def painting_params
      params.require(:painting).permit(:name, :category_id, :color_id, :price, :desc, :thumbnail, {images: []})
      
    end
end
