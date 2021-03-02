$(document).on('turbolinks:load', function() {
  $('.dispatch-log').on('click', '.edit-entry', function(e) {
    e.preventDefault()
    var li = $(this).parents('li');
    li.find('.text p').hide();
    li.find('.text .edit-form').show();
    li.find('.actions .button_to').hide();
    $(this).hide()
  });
});
