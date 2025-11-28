# Patch CKEditor::AssetResponse to support qqfile parameter with JSON response type
#
# When using XHR upload with responseType=json, CKEditor sends:
# - filename in params[:qqfile]
# - file content in request.raw_post
#
# The gem's file method only checks params[:upload] when json? is true,
# but we need it to also check params[:qqfile]
#
# Also fix double JSON encoding issue in success_json response

module Ckeditor
  class AssetResponse
    private

    # Override file method to check both upload and qqfile parameters
    def file
      params[:upload] || params[:qqfile]
    end

    # Override success_json to avoid double JSON encoding
    # The original method calls .to_json which causes Rails to encode it twice
    def success_json(_relative_url_root = nil)
      {
        json: { uploaded: 1, fileName: asset.filename, url: asset.url }
      }
    end
  end
end
