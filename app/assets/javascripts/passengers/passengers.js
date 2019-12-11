$( document ).on("turbolinks:load", function() {
  $('#passenger_spire').change(function(){
    $.ajax({
      type: 'GET',
      url: '/passengers/check_existing',
      data: { spire_id: $(this).val() },
      success: function(responseBody) {
        if(responseBody == undefined){ return }
        $('body').append(responseBody)
        $('#check-existing').modal()
      }
    });
  });
  $('#passenger_permanent').change(function(){
    var expirationField = $('.verification-expires');
    var permanent = $(this).is(':checked')
    expirationField.prop('disabled', permanent);
    if(permanent) { expirationField.val('') }
  });
});
