class Admin::CatalogsController < Admin::BaseController
  before_action :set_catalog, except: [:index, :new, :sort]

  # GET /catalogs
  def index
    @q = Catalog.includes(:categories).ransack(params[:q])
    @catalogs = @q.result(distinct: true).page(params[:page])
    set_meta_tags({
      title: "主分類管理"
    })
  end

  # GET /catalogs/1
  def show
  end

  # GET /catalogs/new
  def new
    @catalog = Catalog.new
    set_meta_tags({
      title: "新增主分類"
    })
  end

  # GET /catalogs/1/edit
  def edit
    set_meta_tags({
      title: "編輯主分類"
    })
  end

  # POST /catalogs
  def create
    if @catalog.save
      redirect_to admin_catalogs_url, notice: '主分類建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /catalogs/1
  def update
    if @catalog.update(catalog_params)
      redirect_to admin_catalogs_url, notice: '主分類更新成功'
    else
      render :edit
    end
  end

  # DELETE /catalogs/1
  def destroy
    @catalog.destroy
    redirect_to admin_catalogs_url, notice: '主分類已刪除'
  end

  def sort
    catalog_params[:order].each do |key,value|
      Catalog.find(value[:id]).update_attribute(:position, value[:position])
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_catalog
    @catalog = params[:id] ? Catalog.find(params[:id]) : Catalog.new(catalog_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def catalog_params
    params.require(:catalog).permit(:published, :name, :position,
      :image, :image_cache, :remove_image, :position, {order: [:id, :position]})
  end
end
