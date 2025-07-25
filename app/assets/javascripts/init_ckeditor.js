$(document).on('turbolinks:load', function() {
  if (typeof CKEDITOR != 'undefined') {
    for (var i in CKEDITOR.instances) {
      CKEDITOR.instances[i].destroy(true);
    }
  }
  $('textarea.ckeditor').each(function() {
    CKEDITOR.replace(this);
  });
});