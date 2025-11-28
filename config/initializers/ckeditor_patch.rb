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
      result = params[:upload].presence || params[:qqfile]
      Rails.logger.info "[CKEditor] file method - upload: #{params[:upload].present?}, qqfile: #{params[:qqfile].present?}, using: #{result.class}"
      result
    end

    # Override success_json to handle both fileTools and filebrowser formats
    # - qqfile parameter (XHR upload): expects { asset: { id, ... } } for filebrowser
    # - upload parameter (multipart form): expects { uploaded: 1, fileName, url } for fileTools
    def success_json(_relative_url_root = nil)
      # If using qqfile parameter, it's for filebrowser
      if params[:qqfile].present?
        response = {
          json: { asset: asset.as_json(root: false) }
        }
      else
        # Otherwise it's for fileTools
        response = {
          json: { uploaded: 1, fileName: asset.filename, url: asset.url }
        }
      end
      Rails.logger.info "[CKEditor] success_json - qqfile: #{params[:qqfile].present?}, response: #{response.inspect}"
      response
    end
  end
end
