$( document ).on("turbolinks:load", function() {
  $('#passenger_spire').focusout(function(){
    $.ajax({
      type: 'GET',
      url: '/passengers/check_existing',
      data: { spire_id: $(this).val() },
      success: function(response) {
        if(response == undefined){ return }
        $('body').append('<div id="check-existing" class="modal" role="dialog" tabindex= "-1">')
        $('#check-existing').html(response)
        $('#check-existing').modal()
      }
    });
  });
});
