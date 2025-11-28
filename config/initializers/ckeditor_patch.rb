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
    # Original logic: !(ckeditor? || json?) ? params[:qqfile] : params[:upload]
    # But when using XHR with responseType=json, it sends qqfile not upload
    # So we check: if upload exists use it, otherwise use qqfile
    def file
      params[:upload].presence || params[:qqfile]
    end

    # Override success_json to return asset data expected by filebrowser
    def success_json(_relative_url_root = nil)
      {
        json: { asset: asset.as_json(root: false) }
      }
    end
  end
end
