$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var registeredbyField = $('#passenger_registered_with_disability_services');
    var hasbrochureField = $('#passenger_has_brochure');

    registeredbyField.prop('disabled', $(this).is(':checked'));
    registeredbyField.prop('checked', false);

    hasbrochureField.prop('disabled', $(this).is(':checked'));
    hasbrochureField.prop('checked', false);
  });
});
