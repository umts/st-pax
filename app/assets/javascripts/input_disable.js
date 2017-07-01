$(document).on("turbolinks:load", function() {
  $('input#permanent_passenger').change(function(){
      if($('input#permanent_passenger').is(":checked")){
        $('input#expiration_date').prop("disabled", true);
        $('input#expiration_date').val('');
      }
      else{
        $('input#expiration_date').prop("disabled", false);
      }
  });
});
//Checking in browser console with: $('input#passenger_permanent').is(":checked")
