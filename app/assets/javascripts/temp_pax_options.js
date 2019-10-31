$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var registeredbyField = $('#passenger_registered_with_disability_services');

    registeredbyField.prop('disabled', $(this).is(':checked'));
    registeredbyField.prop('checked', false);

  });
});
