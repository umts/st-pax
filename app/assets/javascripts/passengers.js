$( document ).on("turbolinks:load", function() {
  $('#passenger_has_doctors_note').on('change', function(){
    $('#passenger_doctors_note_attributes_expiration_date').prop('required', $(this).prop('checked'));
  });
  $('#passenger_permanent').on('change', function(){
    $('.doctors-note-fields').toggle(!$(this).prop('checked'));
  });
});
