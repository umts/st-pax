$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var registeredbyField = $('#pax_registered_with_DS');
    var hasbrochureField = $('#pax_has_brochure');
    if($(this).is(':checked')){
      registeredbyField.prop('disabled', true);
      registeredbyField.prop('checked', false);
    }
    else {
      registeredbyField.prop('disabled', false);
      registeredbyField.prop('checked', false);
    }
    if($(this).is(':checked')){
      hasbrochureField.prop('disabled', true);
      hasbrochureField.prop('checked', false);
    }
    else {
      hasbrochureField.prop('disabled', false);
      hasbrochureField.prop('checked', false);
    }
  });
});
