// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
// CKEditor init is handled manually below
//= require modernizr
//= require isotope.pkgd
//= require owl.carousel
//= require magnific-popup
//= require jquery.appear
//= require jquery.sharrre
//= require jquery.countTo
//= require jquery.parallax
//= require jquery.validate
//= require template
//= require jquery-ui/widgets/datepicker
//= require chosen-jquery
//= require jquery.datetimepicker
//= require html.sortable
//= require cocoon
//= require ckeditor/ckeditor
//= require ckeditor/config

var ready_ran = 0;

set_positions = function(){
  // loop through and give each task a data-pos
  // attribute that holds its position in the DOM
  $('.panel.panel-default').each(function(i){
      $(this).attr("data-pos",i+1);
  });
}

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

var ready = function(){
  if (ready_ran == 1){
    return;
  }else{
    ready_ran = 1;
  }
  // datetiimepicker
  $('.datetimepicker').datetimepicker({format: 'Y-m-d H:i'});
  // enable chosen js
  $('.chosen-select').chosen({
    search_contains: true,
    allow_single_deselect: true,
    no_results_text: 'No results matched',
    width: '400px'
  });
  $(".chosen-select").trigger('chosen:updated');

  set_positions();
  $.ajaxSetup({
    headers: {
      'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    }
  });

  if ($('.sortable-catalog').length) {
    // after the order changes
    sortable('.sortable-catalog').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/catalogs/sort',
          data: {
            _method: 'put',
            catalog: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if ($('.sortable-category').length) {
    // after the order changes
    sortable('.sortable-category').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            catalog_id = this.parentElement.dataset['id'];
            updated_order.push({ id: $(this).data("id"), position: i+1, catalog_id: catalog_id });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/categories/sort',
          data: {
            _method: 'put',
            category: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if ($('.sortable-keyword').length) {
    // after the order changes
    sortable('.sortable-keyword').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/keywords/sort',
          data: {
            _method: 'put',
            keyword: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if ($('.sortable-showed-keyword').length) {
    sortable('.sortable-showed-keyword').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/keywords/show_sort',
          data: {
            _method: 'put',
            keyword: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if ($('.sortable-faq').length) {
    // after the order changes
    sortable('.sortable-faq').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/faqs/sort',
          data: {
            _method: 'put',
            faq: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if ($('.sortable-slide').length) {
    // after the order changes
    sortable('.sortable-slide').forEach(function(elem) {
      elem.addEventListener('sortupdate', function(e) {
        // array to store new order
        updated_order = [];
        // set the updated positions
        set_positions();

        // populate the updated_order array with the new task positions
        $('.panel.panel-default').each(function(i){
            updated_order.push({ id: $(this).data("id"), position: i+1 });
        });

        // send the updated order via ajax
        $.ajax({
          type: "PUT",
          url: '/admin/slides/sort',
          data: {
            _method: 'put',
            slide: {
              order: updated_order
            },
            authenticity_token: window._token
          }
        });
      });
    });
  }

  if (typeof(CKEDITOR) !== 'undefined') {
    // CKEDITOR.config.extraAllowedContent = 'i dl dt dd data-toggle[*]{*} data-parent[*]{*}';
    CKEDITOR.config.allowedContent = true ;
    CKEDITOR.dtd.$removeEmpty['i'] = false ;
  }

  $('textarea.ckeditor').each(function(){
    if ($(this).css('visibility') != 'hidden') {
      CKEDITOR.replace(this)
    }
  })
};


$(document).ready(ready);
