$(document).on('turbolinks:load', function(){
  $('#passenger_permanent').change(function(){
    var hasbrochureField = $('#passenger_has_brochure');

    hasbrochureField.prop('disabled', $(this).is(':checked'));
    hasbrochureField.prop('checked', false);
  });
});
