class PaintingsController < ApplicationController
  before_action :set_options, only: [:new, :edit]
  before_action :set_painting, only: [:show, :edit, :update, :destroy]
  before_action :recent_paintings , only: [:index, :show, :new, :edit]
  # before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
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
      if params[:status] == "all"
        # @paintings = Painting.all
      else
        @paintings = @paintings.where(status: params[:status])
      end
      @is_filtering = true
    end
    
    if params[:category_id].present?
      # 카테고리 필터링 조건이 있을 경우
      @is_filtering = true
      if !@paintings.nil?
        @paintings = @paintings.where(category_id: params[:category_id])
    
      else
        # @paintings = Painting.where(category_id: params[:category_id])
        @paintings = @painting.where(category_id: params[:category_id])
        
      end
    end
    
    if params[:price_id].present?
      # 가격 필터링 조건이 있을 경우
      price = Price.find(params[:price_id][0])
      
      # cheap_price : 가격 필터링 조건의 하한선(10만원 - 20만원) => 10만원
      cheap_price = @prices.index(price) == 0 ? nil : @prices[@prices.index(price)-1]
      
      if !@paintings.nil? && cheap_price.present?
        # 가격 외의 다른 필터링 조건이 있을 경우, 
        # 다른 필터링 조건과 가격 필터링 조건을 교집합
        @paintings = @paintings.where("price <= ? AND price > ?", price.value, cheap_price.value)

      elsif cheap_price.present? 
        # 가격 필터링 조건밖에 없을 경우
        # @paintings = Painting.where("price <= ? AND price > ?", price.value, cheap_price.value)
        @paintings = @paintings.where("price <= ? AND price > ?", price.value, cheap_price.value)

      else
        # 기타 예외 사항 처리
        # @paintings = Painting.where("price <= ?", price.value)
        @paintings = @paintings.where("price <= ?", price.value)

      end
      
      @is_filtering = true
      
    end

    if params[:color_id].present?
      # 색깔 필터링 조건이 있을 경우
      if !@paintings.nil?
        # 색 필터링 외에 다른 필터링 조건이 있을 경우,
        # 색 필터링 조건과 교집합한다.
        @paintings = @paintings.where(color_id: params[:color_id])
      else 
        # 색 필터링 조건만 조건에 있을 경우
        @paintings = @paintings.where(color_id: params[:color_id])
        # @paintings = Painting.where(color_id: params[:color_id])
      end
      @is_filtering = true
    end
    if @is_filtering
      @paintings = @paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
    end
    if params[:refresh].present?
      # 그림 목록을 모두 지웠다 다시 표시해야 하는 경우 (필터링 등)
      @need_refresh = true
    else 
      # 그림 목록을 지우지 않고, append 해 나가야 하는 경우 (infinite-scroll 등)
      @need_refresh = false
    end
    
    # 필터링을 하지 않는 경우
    if !@is_filtering
      # @paintings = Painting.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
      # @paintings = Painting.where(status: "sale").paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images

      @paintings = @paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
      
    end

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


  # def filter(paintings, filter_type)

  #   case filter_type
  #   when 0 
  #     # 최신순
  #     @paintings = paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('created_at DESC').exclude_images
  #   when 1
  #     # 좋아요 순

  #   when 2
  #     # 낮은 가격 순
  #     @paintings = paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('price ASC').exclude_images
  #   when 3
  #     # 높은 가격 순
  #     @paintings = paintings.paginate(page: params[:page], per_page: Painting::PER_PAGE).order('price DESC').exclude_images
  #   else
  #     puts "undefined filter"
  #   end
    
  # end

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
