$( document ).on("turbolinks:load", function() {
  $('#passenger_has_doctors_note').on('change', function(){
    $('#passenger_doctors_note_attributes_expiration_date').prop('required', $(this).prop('checked'));
  });

  $('#passenger_permanent').on('change', function(){
    $('.doctors-note-fields').toggle(!$(this).prop('checked'));
  });

  var clipboard = new ClipboardJS('#copybtn', {
    text: function() {
      return $("#passengers tbody tr").map(function(){
        return $(this).data("email")
      }).get().join(";")
    }
  });
  clipboard.on('success', function() {
    $('#copybtn').tooltip({title: "Copied"}).tooltip('show');
  });

  clipboard.on('error', function() {
    $('#copybtn').tooltip({title: "Failed to copy!"}).tooltip('show');
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

  $('#passenger_permanent').change(function(){
    var expirationField = $('.verification-expires');
    var permanent = $(this).is(':checked')
    expirationField.prop('disabled', permanent);
    if(permanent) { expirationField.val('') }
  });

  $('#passenger_eligibility_verification_attributes_verifying_agency_id').change(function(){
    var needsContactInfo = $(this).children("option:selected").data('needs-contact-info');
    $('.contact-information').toggle(needsContactInfo);
  });
});
