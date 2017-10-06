$(document).on('turbolinks:load', function(){
    $('#passenger_doctors_note_attributes_override_expiration').change(function(){
      $('#passenger_doctors_note_attributes_override_until').slideToggle();
    });
});