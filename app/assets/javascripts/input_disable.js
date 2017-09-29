$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var expirationField = $('.doctors_note_expiration_date');
    if($(this).is(':checked')){
      expirationField.prop('disabled', true);
      expirationField.val('');
    }
    else expirationField.prop('disabled', false);
  });
});
