# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile +=
  %w(
      jquery/jquery.fileupload-angular.js
      jquery/jquery.fileupload-audio.js
      jquery/jquery.fileupload-image.js
      jquery/jquery.fileupload-jquery-ui.js
      jquery/jquery.fileupload.js
      jquery/jquery.fileupload-process.js
      jquery/jquery.fileupload-ui.js
      jquery/jquery.fileupload-validate.js
      jquery/jquery.fileupload-video.js
      jquery/jquery.iframe-transport.js
      jquery/vendor/jquery.ui.widget.js
      jquery/jquery.fileupload.css
      jquery/jquery.fileupload-noscript.css
      jquery/jquery.fileupload-ui.css
      jquery/jquery.fileupload-ui-noscript.css
    )
