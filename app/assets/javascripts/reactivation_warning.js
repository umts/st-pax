$(document).on('turbolinks:load', function(){
  $('input#passenger_active').change(function(){
    if($(this).is(':checked')){
      if(moment($('#doctors_note_expiration_date').val(), 'YYYY-MM-DD') <= moment()){
        alert("You are about to temporarily reactivate this passenger. \
        \n Please note that, unless an updated expiration date is \
        \n obtained, this passenger will deactivate again in one week");
      }
    }
  });
});
