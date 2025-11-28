# Patch CKEditor::AssetResponse to support qqfile parameter with JSON response type
#
# When using XHR upload with responseType=json, CKEditor sends:
# - filename in params[:qqfile]
# - file content in request.raw_post
#
# The gem's file method only checks params[:upload] when json? is true,
# but we need it to also check params[:qqfile]

module Ckeditor
  class AssetResponse
    private

    # Override file method to check both upload and qqfile parameters
    def file
      params[:upload] || params[:qqfile]
    end
  end
end
