class Admin::SlidesController < Admin::BaseController

  def sort
    slide_params[:order].each do |key,value|
      if not value[:id].blank? and Slide.exists?(id: value[:id])
        Slide.find(value[:id]).update_attribute(:position, value[:position])
      end
    end
    render body: nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_slide
    @slide = params[:id] ? Slide.find(params[:id]) : Slide.new(slide_params)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def slide_params
    params.require(:slide).permit( {order: [:id, :position]} )
  end
end
