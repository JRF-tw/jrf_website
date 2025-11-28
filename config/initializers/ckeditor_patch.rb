# Patch CKEditor::AssetResponse to support qqfile parameter with JSON response type
#
# When using XHR upload with responseType=json, CKEditor sends:
# - filename in params[:qqfile]
# - file content in request.raw_post
#
# The gem's file method only checks params[:upload] when json? is true,
# but we need it to also check params[:qqfile]
#
# The CKEditor gem's filebrowser expects asset data with id, type, etc
# so we return asset JSON instead of fileTools format

module Ckeditor
  class AssetResponse
    private

    # Override file method to check both upload and qqfile parameters
    def file
      params[:upload] || params[:qqfile]
    end

    # Override success_json to return asset data expected by filebrowser
    # The filebrowser JavaScript expects: { asset: { id, type, size, ... } }
    def success_json(_relative_url_root = nil)
      response_data = { asset: asset.as_json }
      Rails.logger.info "[CKEditor] JSON response: #{response_data.to_json}"
      {
        json: response_data.to_json,
        content_type: 'application/json'
      }
    end
  end
end
