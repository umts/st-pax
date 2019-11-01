$( document ).on("turbolinks:load", function() {
  $(':input[required]:visible').each(function(){
    var label = $("label[for='" + $(this).attr('id') + "']");
    label.addClass('required');
  });
});
