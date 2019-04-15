class PaintingsController < ApplicationController
  before_action :set_options, only: [:new, :edit]
  before_action :set_painting, only: [:show, :edit, :update, :destroy]
  before_action :recent_paintings , only: [:index, :show, :new, :edit]
  before_action :check_authority, only: [:new, :create, :edit, :update, :destroy]

  # GET /paintings
  # GET /paintings.json
  def index
    # 필터링, infinite-scroll 을 위한 자바스크립트 고도화로 인해
    # 코드가 좀 길어졌습니다 ^^;; - heej (2019.01.28)
    
    @categories = Category.all
    @colors = Color.all
    @prices = Price.all.order(:value)

    if params[:only_commerce]
      @paintings = Painting.only_commerce
      @only_commerce = true
    else
      @paintings = Painting.except_commerce
    end

    @is_filtering = false
    # 필터링을 하는 경우
    if params[:status].present?
      @paintings = @paintings.where(status: params[:status]) unless params["status"] == "all"
      @is_filtering = true
    end
    
    if params[:category_id].present?
      # 카테고리 필터링 조건이 있을 경우
      @is_filtering = true
      @paintings = @paintings.where(category_id: params[:category_id])
    end

    if params[:min_price].present? && params[:max_price].present?
      @paintings = @paintings.where("price <= ? AND price >= ?", params[:max_price].to_i, params[:min_price].to_i)
      @is_filtering = true
    end

    if params[:color_id].present?
      # 색깔 필터링 조건이 있을 경우
      @paintings = @paintings.where(color_id: params[:color_id])
      @is_filtering = true
    end

    # 그림 목록을 모두 지웠다 다시 표시해야 하는 경우 (필터링 등)
    @need_refresh = params[:refresh].present? ? true : false
    
    @paintings = @paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
    @min_price = Painting.order_price.first.price
    @max_price = Painting.order_price.last.price

    respond_to do |format|
      format.html
      format.js
    end

  end

  def show
    # 최근 열람한 그림을 세션에 담아놓는다. (최근 본 그림)
    session[:recent_paintings] << @painting.id
    session[:recent_paintings] = session[:recent_paintings].uniq

    @user = @painting.user
    @user_category = @user.user_categories
    @user_line_json = @user.get_line_info
    @user_category = @user.user_categories

    @other_paintings = @user.paintings.select(:thumbnail, :name, :id).last(10)

    # COMMENTS
    @painting_comments = PaintingComment.where(painting_id: @painting.id).order("created_at DESC")

    @is_following = (user_signed_in? && current_user.is_following(@user)) ? true : false

    @like = Like.where(user_id: current_user.id, painting_id: @painting.id) if user_signed_in?

    @line_item = LineItem.new

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
        @painting.generate_options
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

  def search
    category = params[:search_category]
    @query = params[:search_query]

    case category
    when "title"
      @paintings = Painting.where("name like ?", "%#{@query}%")
    when "artist"
      puts "artist"
      @paintings = Painting.joins(:user).where("nickname like ?", "%#{@query}%")
    else 
      puts "exception occured"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_options
      # form_for > form.select 에서 사용될 선택지들을 생성해주는 함수
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
    def check_authority
      if user_signed_in? && current_user.user_type == "seller"
        return true
      else
        flash[:notice] = "작가 권한이 없습니다."
        redirect_to paintings_path
      end
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def painting_params
      params.require(:painting).permit(:name, :category_id, :color_id, :price, :desc, :status, :thumbnail, {images: []})
    end
end
