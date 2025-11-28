class Ckeditor::AttachmentFilesController < Ckeditor::ApplicationController
  def create
    # Handle both 'upload' and 'qqfile' parameters
    if params[:qqfile].present? && params[:upload].blank?
      params[:upload] = params[:qqfile]
    end

    super
  end
end
