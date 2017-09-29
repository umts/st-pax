$(document).on('turbolinks:load', function(){
    $('#active-checkbox').change(function(){
      $('#slide-date').slideToggle();
    });
});