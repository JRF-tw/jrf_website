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
//= require bootstrap
//= require vendor/modernizr
//= require vendor/isotope.pkgd
//= require vendor/owl.carousel
//= require vendor/magnific-popup
//= require vendor/jquery.appear
//= require vendor/jquery.sharrre
//= require vendor/jquery.parallax
//= require vendor/jquery.validate
//= require template
//= require bootstrap_dropdown_init
//= require gtm


var ready_ran = 0;

var ready = function(){
  if (ready_ran == 1){
    return;
  }else{
    ready_ran = 1;
  }
  // if ($("#disqus_thread").length) {
  //   var disqus_shortname = 'jrf-tw';
  //   (function() { // DON'T EDIT BELOW THIS LINE
  //     var d = document, s = d.createElement('script');
  //     s.src = 'https://' + disqus_shortname + '.disqus.com/embed.js';
  //     s.setAttribute('data-timestamp', +new Date());
  //     (d.head || d.body).appendChild(s);
  //   })();
  // }
};

$(document).ready(ready);
