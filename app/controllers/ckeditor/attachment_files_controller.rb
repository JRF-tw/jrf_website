class Ckeditor::AttachmentFilesController < Ckeditor::ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
end
