# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( index.css )
Rails.application.config.assets.precompile += %w( index.js )
Rails.application.config.assets.precompile += %w( admin.js )
Rails.application.config.assets.precompile += %w( admin.css )
# Precompile additional image assets - simple string patterns only
Rails.application.config.assets.precompile += Ckeditor.assets
Rails.application.config.assets.precompile += %w[ckeditor/config.js]
# 後台「瀏覽伺服器」的附件清單會用到各檔案類型的縮圖，沒列入會 500
Rails.application.config.assets.precompile += [%r{\Ackeditor/filebrowser/thumbs/.+\.gif\z}]
