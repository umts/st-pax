$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var registeredbyField = $('#pax_registered_with_DS');
    var hasbrochureField = $('#pax_has_brochure');

    registeredbyField.prop('disabled', $(this).is(':checked'));
    registeredbyField.prop('checked', false);

    hasbrochureField.prop('disabled', $(this).is(':checked'));
    hasbrochureField.prop('checked', false);
  });
});
