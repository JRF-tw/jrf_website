class Admin::FaqsController < Admin::BaseController
  before_action :find_keyword, except: [:sort]

  # GET /faqs
  def index
    @faqs = @keyword.faqs
    set_meta_tags({
      title: "專案FAQ管理"
    })
  end

  def sort
    faq_params[:order].each do |key,value|
      if not value[:id].blank? and Faq.exists?(id: value[:id])
        Faq.find(value[:id]).update_attribute(:position, value[:position])
      end
    end
    render nothing: true
  end

  private

  def find_keyword
    @keyword = Keyword.find(params[:keyword_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_faq
    @faq = params[:id] ? Faq.find(params[:id]) : Faq.new(faq_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def faq_params
    params.require(:faq).permit( {order: [:id, :position]} )
  end
end
