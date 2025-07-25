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
    faq_params[:order].each do |item|
      if item[:id].present? and Faq.exists?(id: item[:id])
        Faq.find(item[:id]).update_attribute(:position, item[:position])
      end
    end
    render body: nil
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
