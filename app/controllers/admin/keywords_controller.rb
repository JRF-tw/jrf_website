class Admin::KeywordsController < Admin::BaseController
  before_action :set_keyword, except: [:index, :new, :sort, :add_faq, :order, :show_sort, :show_order]

  # GET /keywords
  def index
    @q = Keyword.includes(category: :catalog).search(params[:q])
    @keywords = @q.result(distinct: true)
    set_meta_tags({
      title: "專案管理"
    })
  end

  # GET /keywords/1
  def show
    @slides = @keyword.slides.all
    @faqs = @keyword.faqs.all
  end

  def order
    @catalogs = Catalog.includes(categories: :keywords).all
    set_meta_tags({
      title: "專案排序"
    })
  end

  def show_order
    @keywords = Keyword.includes(category: :catalog).showed
    set_meta_tags({
      title: "首頁顯示專案排序"
    })
  end

  # GET /keywords/new
  def new
    @keyword = Keyword.new
    @faq = @keyword.faqs.build
    set_meta_tags({
      title: "新增專案"
    })
  end

  # GET /keywords/1/edit
  def edit
    @faq = @keyword.faqs.build
    set_meta_tags({
      title: "編輯專案"
    })
  end

  # POST /keywords
  def create
    if @keyword.save
      redirect_to admin_keywords_url, notice: '專案建立成功'
    else
      render :new
    end
  end

  # PATCH/PUT /keywords/1
  def update
    if @keyword.update(keyword_params)
      redirect_to admin_keywords_url, notice: '文章更新成功'
    else
      render :edit
    end
  end

  # DELETE /keywords/1
  def destroy
    @keyword.destroy
    redirect_to admin_keywords_url, notice: '文章已刪除'
  end

  def sort
    keyword_params[:order].each do |key,value|
      Keyword.find(value[:id]).update_attribute(:position, value[:position])
    end
    render body: nil
  end

  def show_sort
    keyword_params[:order].each do |key,value|
      Keyword.find(value[:id]).update_attribute(:show_position, value[:position])
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_keyword
    @keyword = params[:id] ? Keyword.find(params[:id]) : Keyword.new(keyword_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def keyword_params
    params.require(:keyword).permit(:category_id, :name, :published, :showed,
      :image, :image_cache, :remove_image, :title, :content, :description,
      :cover, :cover_cache, :remove_cover, :position, :label, :label_type, {order: [:id, :position]},
      faqs_attributes: [:id, :question, :answer, :keyword_id, :_destroy],
      slides_attributes: [:id, :slideable_id, :slideable_type, :image, :image_cache, :remove_image, :_destroy])
  end
end
