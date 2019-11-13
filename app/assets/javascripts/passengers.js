$( document ).on("turbolinks:load", function() {
  $('#passenger_has_verification').on('change', function(){
    $('#passenger_verification_attributes_expiration_date').prop('required', $(this).prop('checked'));
  });

  $('#passenger_permanent').on('change', function(){
    $('.verification_expiration_date').prop('disabled', $(this).prop('checked'))
  });

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
});
