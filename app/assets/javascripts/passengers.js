$( document ).on("turbolinks:load", function() {
  $('#passenger_spire').change(function(){
    $.ajax({
      type: 'GET',
      url: '/passengers/check_existing',
      data: { spire_id: $(this).val() },
      success: function(response) {
        if(response == undefined){ return }
        $('body').append(response)
        $('#check-existing').modal()
      }
    });
  });
});
