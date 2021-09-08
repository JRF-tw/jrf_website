class Admin::SitesController < Admin::BaseController
  before_action :set_site, except: [:index, :new, :sort]

  # GET /sites
  def index
    @q = Site.search(params[:q])
    @Sites = @q.result(distinct: true).page(params[:page])
    set_meta_tags({
      title: "對外連結管理"
    })
  end

  # GET /Sites/1
  def show
  end

  # GET /Sites/new
  def new
    @Site = Site.new
    set_meta_tags({
      title: "新增對外連結"
    })
  end

  # GET /Sites/1/edit
  def edit
    set_meta_tags({
      title: "編輯對外連結"
    })
  end

  # POST /Sites
  def create
    if @Site.save
      redirect_to admin_Sites_url, notice: '對外連結建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /Sites/1
  def update
    if @Site.update(Site_params)
      redirect_to admin_Sites_url, notice: '對外連結更新成功'
    else
      render :edit
    end
  end

  # DELETE /Sites/1
  def destroy
    @Site.destroy
    redirect_to admin_Sites_url, notice: '對外連結已刪除'
  end

  def sort
    Site_params[:order].each do |key,value|
      Site.find(value[:id]).update_attribute(:position, value[:position])
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_Site
    @Site = params[:id] ? Site.find(params[:id]) : Site.new(Site_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def Site_params
    params.require(:Site).permit(:published, :name, :position,
      :image, :image_cache, :remove_image, :position, {order: [:id, :position]})
  end
end
