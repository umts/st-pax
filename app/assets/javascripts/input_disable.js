$(document).on('turbolinks:load', function(){
  $('input#passenger_permanent').change(function(){
    var expirationField = $('input#passenger_expiration')
    if($(this).is(':checked')){
      expirationField.prop('disabled', true);
      expirationField.val('');
    }
    else expirationField.prop('disabled', false);
  });
});
