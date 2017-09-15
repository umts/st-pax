$(document).on('turbolinks:load', function(){
    $('#check-click').change(function(){
      $('#slide-date').slideToggle();
    });
});