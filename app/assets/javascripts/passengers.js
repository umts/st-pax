$( document ).on("turbolinks:load", function() {
  $('.no-doctors-info').change(function(){
    $('.doctors-note-fields').toggle(!$(this).prop('checked'));
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
