$( document ).on("turbolinks:load", function() {
  $('#passenger_has_doctors_note').on('change', function(){
    $('#passenger_eligibility_verification_attributes_expiration_date').prop('required', $(this).prop('checked'));
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
