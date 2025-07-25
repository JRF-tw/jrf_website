$(document).on('turbolinks:load', function() {
  $('textarea.ckeditor').each(function() {
    CKEDITOR.replace(this);
  });
});