$(document).on('turbolinks:load', function(){
  $('input#passenger_active').change(function(){
    if($(this).is(':checked')){
      alert("You are about to temporarily reactivate this passenger. \
      \n Please note that, unless an updated doctor's note is \
      \n obtained, this passenger will deactivate again in one week");
    }
  });
});
