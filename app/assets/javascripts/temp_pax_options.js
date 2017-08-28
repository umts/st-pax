$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var registeredbyField = $('#passenger_registered_with_disability_services');
    //var hasbrochureField = $('#has_brouchure');
    if($(this).is(':checked')){
      registeredbyField.prop('disabled', true);
     // hasbrochureField.prop('disabled', true);
    }
    else registeredbyField.prop('disabled', false);
         //hasbrochureField.prop('disabled', false);
  });
});
