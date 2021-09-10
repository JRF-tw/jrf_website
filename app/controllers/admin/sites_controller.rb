class Admin::SitesController < Admin::BaseController
  before_action :set_site, except: [:index, :new, :sort]

  # GET /sites
  def index
    @q = Site.search(params[:q])
    @sites = @q.result(distinct: true).page(params[:page])
    set_meta_tags({
      title: "對外連結管理"
    })
  end

  # GET /sites/1
  def show
  end

  # GET /sites/new
  def new
    @site = Site.new
    set_meta_tags({
      title: "新增對外連結"
    })
  end

  # GET /sites/1/edit
  def edit
    set_meta_tags({
      title: "編輯對外連結"
    })
  end

  # POST /sites
  def create
    if @site.save
      redirect_to admin_sites_url, notice: '對外連結建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /sites/1
  def update
    if @site.update(site_params)
      redirect_to admin_sites_url, notice: '對外連結更新成功'
    else
      render :edit
    end
  end

  # DELETE /sites/1
  def destroy
    @site.destroy
    redirect_to admin_sites_url, notice: '對外連結已刪除'
  end

  def sort
    site_params[:order].each do |key,value|
      site.find(value[:id]).update_attribute(:position, value[:position])
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_site
    @site = params[:id] ? Site.find(params[:id]) : Site.new(site_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def site_params
    params.require(:site).permit(:published, :title, :link,
      :image, :image_cache, :remove_image, :position, {order: [:id, :position]})
  end
end
