class PaintingsController < ApplicationController
  before_action :set_options, only: [:new, :edit]
  before_action :set_painting, only: [:show, :edit, :update, :destroy]
  
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  # GET /paintings
  # GET /paintings.json
  def index
    @paintings = Painting.all.order(created_at: :desc)
    @categories = Category.all
    @colors = Color.all
  end

  # GET /paintings/1
  # GET /paintings/1.json
  def show
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
    @painting = Painting.new(painting_params)
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
