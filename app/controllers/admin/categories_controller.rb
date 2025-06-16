class Admin::CategoriesController < Admin::BaseController
  before_action :set_category, except: [:index, :new, :sort]

  # GET /categories
  def index
    @q = Category.ransack(params[:q])
    @categories = @q.result(distinct: true).page(params[:page])
    set_meta_tags({
      title: "次分類管理"
    })
  end

  # GET /categories/1
  def show
  end

  # GET /categories/new
  def new
    @category = Category.new
    set_meta_tags({
      title: "新增次分類"
    })
  end

  # GET /categories/1/edit
  def edit
    set_meta_tags({
      title: "編輯次分類"
    })
  end

  # POST /categories
  def create
    if @category.save
      redirect_to admin_categories_url, notice: '次分類建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to admin_categories_url, notice: '次分類更新成功'
    else
      render :edit
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to admin_categories_url, notice: '次分類已刪除'
  end

  def sort
    category_params[:order].each do |key,value|
      Category.find(value[:id]).update_attribute(:position, value[:position])
      #Category.find(value[:id]).update_attribute(:catalog_id, value[:catalog_id])
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = params[:id] ? Category.find(params[:id]) : Category.new(category_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def category_params
    params.require(:category).permit(:name, :published, :position, :width, :catalog_id, :position, {order: [:id, :position, :catalog_id]})
  end
end
