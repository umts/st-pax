$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var expirationField = $('.verification-expires');
    if($(this).is(':checked')){
      expirationField.prop('disabled', true);
      expirationField.val('');
    }
    else expirationField.prop('disabled', false);
  });
});
